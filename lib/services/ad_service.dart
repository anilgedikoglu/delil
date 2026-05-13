// ignore_for_file: lines_longer_than_80_chars
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Her 5 kart okumada 1 geçiş reklamı (interstitial) gösterir.
/// Emülatörde hiç reklam göstermez.
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  // ── TODO: Gerçek ID'lerle değiştir ────────────────────────────────────────
  // AdMob Console → Uygulamalar → DELİL → Reklam birimleri → Interstitial
  // AndroidManifest.xml'deki APPLICATION_ID'yi de değiştirmeyi unutma!
  static const String _adUnitId =
      'ca-app-pub-6470338276121414/8002655354'; // gecisDelil
  // ──────────────────────────────────────────────────────────────────────────

  static const int _showEvery = 5; // kaç kartta bir reklam

  bool _initialized = false;
  bool _isEmulator  = false;
  int  _readCount   = 0;

  InterstitialAd? _ad;
  bool _adReady = false;

  // ── Başlatma ───────────────────────────────────────────────────────────────
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Emülatör kontrolü
    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      _isEmulator = !info.isPhysicalDevice;
    } else if (Platform.isIOS) {
      final info = await DeviceInfoPlugin().iosInfo;
      _isEmulator = !info.isPhysicalDevice;
    }

    if (_isEmulator) return; // emülatörde hiç başlatma

    await MobileAds.instance.initialize();
    _loadAd();
  }

  // ── Kart okundu — 4 detail screen'den çağrılır ────────────────────────────
  void onCardRead() {
    if (_isEmulator) return;
    _readCount++;
    if (_readCount % _showEvery == 0) {
      // Kart içeriği yüklendikten 600ms sonra göster
      Future.delayed(const Duration(milliseconds: 600), _showAd);
    }
  }

  // ── Reklam yükle ──────────────────────────────────────────────────────────
  void _loadAd() {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _adReady = true;
        },
        onAdFailedToLoad: (_) {
          _adReady = false;
          // 30 sn sonra tekrar dene
          Future.delayed(const Duration(seconds: 30), _loadAd);
        },
      ),
    );
  }

  // ── Reklamı göster ────────────────────────────────────────────────────────
  void _showAd() {
    if (!_adReady || _ad == null) return;

    _ad!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _ad = null;
        _adReady = false;
        _loadAd(); // bir sonraki için önceden yükle
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _ad = null;
        _adReady = false;
        _loadAd();
      },
    );

    _ad!.show();
    _ad = null;
    _adReady = false;
  }
}
