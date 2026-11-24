// ignore_for_file: lines_longer_than_80_chars
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Her 5 kart okumada 1 geçiş reklamı (interstitial) gösterir.
/// Emülatörde hiç reklam göstermez.
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  // ── Reklam birimi ID'leri ─────────────────────────────────────────────────
  // Android
  static const String _interstitialIdAndroid =
      'ca-app-pub-6470338276121414/8002655354'; // gecisDelil (Android)

  // iOS
  static const String _interstitialIdIOS =
      'ca-app-pub-6470338276121414/1488716764'; // gecisDelil (iOS)
  // ─────────────────────────────────────────────────────────────────────────

  static String get _interstitialAdUnitId =>
      Platform.isIOS ? _interstitialIdIOS : _interstitialIdAndroid;

  static const int _showEvery     = 5;  // kaç kartta bir reklam
  static const int _showEveryBack = 10; // kaç geri tuşunda bir reklam

  bool _initialized = false;
  bool _isEmulator  = false;
  int  _readCount   = 0;
  int  _backCount   = 0;
  static const Duration _minGap = Duration(seconds: 90); // iki reklam arası en az
  DateTime? _lastShown;

  InterstitialAd? _interstitialAd;
  bool _interstitialReady = false;

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

    if (_isEmulator) return;

    await MobileAds.instance.initialize();
    _loadInterstitial();
  }

  // ── Kart okundu — 4 detail screen'den çağrılır ────────────────────────────
  void onCardRead() {
    if (_isEmulator) return;
    _readCount++;
    if (_readCount % _showEvery == 0) {
      Future.delayed(const Duration(milliseconds: 600), _showInterstitial);
    }
  }

  // ── Geri tuşu — NavigatorObserver'dan çağrılır ───────────────────────────
  void onBackPressed() {
    if (_isEmulator) return;
    _backCount++;
    if (_backCount % _showEveryBack == 0) {
      Future.delayed(const Duration(milliseconds: 300), _showInterstitial);
    }
  }

  // ── Interstitial yükle ────────────────────────────────────────────────────
  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialReady = true;
        },
        onAdFailedToLoad: (_) {
          _interstitialReady = false;
          Future.delayed(const Duration(seconds: 30), _loadInterstitial);
        },
      ),
    );
  }

  // ── Interstitial göster ───────────────────────────────────────────────────
  void _showInterstitial() {
    if (!_interstitialReady || _interstitialAd == null) return;
    final last = _lastShown;
    if (last != null && DateTime.now().difference(last) < _minGap) return;
    _lastShown = DateTime.now();

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _interstitialReady = false;
        _loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        _lastShown = null;
        ad.dispose();
        _interstitialAd = null;
        _interstitialReady = false;
        _loadInterstitial();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
    _interstitialReady = false;
  }
}
