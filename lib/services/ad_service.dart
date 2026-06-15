// ignore_for_file: lines_longer_than_80_chars
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
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
  static const String _rewardedIdIOS =
      'ca-app-pub-6470338276121414/2709128236'; // delilrewardedios (iOS)
  // ─────────────────────────────────────────────────────────────────────────

  static String get _interstitialAdUnitId =>
      Platform.isIOS ? _interstitialIdIOS : _interstitialIdAndroid;

  static String get _rewardedAdUnitId => _rewardedIdIOS;

  static const int _showEvery     = 5;  // kaç kartta bir reklam
  static const int _showEveryBack = 10; // kaç geri tuşunda bir reklam

  bool _initialized = false;
  bool _isEmulator  = false;
  int  _readCount   = 0;
  int  _backCount   = 0;

  InterstitialAd? _interstitialAd;
  bool _interstitialReady = false;

  RewardedAd? _rewardedAd;
  bool _rewardedReady = false;

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
    if (Platform.isIOS) _loadRewarded();
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

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _interstitialReady = false;
        _loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
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

  // ── Rewarded yükle (iOS) ──────────────────────────────────────────────────
  void _loadRewarded() {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedReady = true;
        },
        onAdFailedToLoad: (_) {
          _rewardedReady = false;
          Future.delayed(const Duration(seconds: 30), _loadRewarded);
        },
      ),
    );
  }

  /// Rewarded reklamı göster. [onRewarded] kullanıcı ödülü kazanınca çağrılır.
  void showRewarded({VoidCallback? onRewarded}) {
    if (_isEmulator || !_rewardedReady || _rewardedAd == null) return;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _rewardedReady = false;
        if (Platform.isIOS) _loadRewarded();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _rewardedAd = null;
        _rewardedReady = false;
        if (Platform.isIOS) _loadRewarded();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (_, __) => onRewarded?.call(),
    );
    _rewardedAd = null;
    _rewardedReady = false;
  }

  bool get isRewardedReady => _rewardedReady && !_isEmulator;
}
