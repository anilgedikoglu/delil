# DELİL Flutter Uygulaması — CLAUDE.md

## Proje Özeti
Allah'ın varlığının delillerini, mucizelerini, itiraz-cevaplarını ve önemli kişilerin sözlerini
kart tabanlı UI ile sunan Flutter mobil uygulaması. 4 modül, koyu lacivert/altın tema.

## Teknik Yapı
- **Flutter SDK**: `C:\flutter`
- **Proje dizini**: `C:\src\delil`
- **Paketler**: `google_fonts ^6.2.1`, `shared_preferences ^2.3.3`, `google_mobile_ads ^5.1.0`, `device_info_plus ^10.1.0`
- **Veri**: `const` Dart listeleri — JSON yok, runtime parse yok
- **Tema**: Koyu lacivert `#0D0B2B` + altın `#D4A017`
- **Emülatör**: `emulator-5554` (Medium_Phone_API_36)

## Modüller ve Veri Boyutları
| Modül     | ID Prefix  | Veri Dosyası           | Toplam |
|-----------|------------|------------------------|--------|
| Deliller  | `DELIL-`   | `data/delil_data.dart` | 117    |
| Mucizeler | `MUCIZE-`  | `data/mucize_data.dart`| ~60+   |
| Cevaplar  | `CEVAP-`   | `data/cevap_data.dart` | ~60+   |
| Sözler    | `SOZ-`     | `data/soz_data.dart`   | ~50+   |

## Dosya Yapısı
```
lib/
  main.dart                     # DelilApp → MainShell (IndexedStack, 4 tab)
  models/
    delil_model.dart            # Delil, DelilSource (module + description alanları var)
    mucize_model.dart           # Mucize, MucizeDetailedExplanation
    cevap_model.dart            # Cevap modeli
    soz_model.dart              # Soz modeli
  data/
    delil_data.dart             # 117 kart const verisi + helper fonksiyonlar
    mucize_data.dart            # Mucize kartları const verisi
    cevap_data.dart             # Cevap kartları const verisi
    soz_data.dart               # Söz kartları const verisi
    sources_data.dart           # 38 kaynak (4 modül için) + getSourcesByModule()
  theme/
    app_theme.dart              # AppColors, MucizeColors, SozColors, buildAppTheme()
  screens/
    home_screen.dart            # 4 tab, sabit header, _BottomStatLine (scroll sonu istatistik)
    category_screen.dart        # Deliller kategori (MarqueeTitle)
    mucize_category_screen.dart # Mucizeler kategori (MarqueeTitle)
    cevap_category_screen.dart  # Cevaplar kategori (MarqueeTitle)
    soz_category_screen.dart    # Sözler kategori (MarqueeTitle, AppColors.surface sabit)
    detail_screen.dart          # Delil detayı (TimeTracker, AdService)
    mucize_detail_screen.dart   # Mucize detayı (TimeTracker, AdService)
    cevap_detail_screen.dart    # Cevap detayı (TimeTracker, AdService)
    soz_detail_screen.dart      # Söz detayı (TimeTracker, AdService, SliverAppBar)
    search_screen.dart          # 4 modülde eş zamanlı arama, gruplu sonuçlar
    sources_screen.dart         # Modüle göre gruplu 38 kaynak
  services/
    read_tracker.dart           # ReadTracker singleton, ValueNotifier<Set<String>>, SharedPreferences
    time_tracker.dart           # TimeTracker singleton, ValueNotifier<Map<String,int>>, SharedPreferences
    ad_service.dart             # AdService singleton, her 5 kartta 1 interstitial, emülatörde kapalı
  widgets/
    delil_card_widget.dart      # DelilCardWidget (liste) + DelilCardFeatured (yatay)
    mucize_card_widget.dart     # MucizeCardWidget + MucizeCardFeatured
    cevap_card_widget.dart      # CevapCardWidget + CevapCardFeatured
    soz_card_widget.dart        # SozCardWidget + SozCardFeatured + _QuoteTypeBadge
    strength_badge.dart         # Güç göstergesi (oval, sarı, nokta + etiket)
    marquee_title.dart          # MarqueeTitle: >20 karakter → kayan yazı, gold '-' separator
    app_logo.dart               # AppLogoHeader (artık kullanılmıyor)
assets/
  images/
    logo.png
    logo_round.png
    logo_horizontal.png
android/
  app/src/main/AndroidManifest.xml  # INTERNET izni, AdMob App ID meta-data
  app/build.gradle.kts              # NDK 27, release signing config
  key.properties                    # Signing şifresi (repo'da mevcut)
  app/src/main/res/
    mipmap-*/ic_launcher.png            # Yuvarlak ikon (lacivert bg + logo)
    mipmap-*/ic_launcher_round.png      # Yuvarlak ikon (aynı)
    mipmap-*/ic_launcher_foreground.png # Adaptive icon foreground
    mipmap-anydpi-v26/ic_launcher.xml   # Adaptive icon XML
    values/colors.xml                   # launch_bg = #0D0B2B
delil.jks                         # Release keystore (repo'da mevcut, alias: delil)
docs/
  index.html                      # GitHub Pages ana sayfa (web sitesi)
  privacy_policy.html             # GitHub Pages gizlilik politikası
ios/
  Runner/Info.plist               # GADApplicationIdentifier, SKAdNetworkItems, ITSAppUsesNonExemptEncryption
  Runner/Assets.xcassets/AppIcon.appiconset/  # 15 ikon, Format24bppRgb (alpha yok)
  Runner.xcodeproj/project.pbxproj            # Bundle ID: com.futurastic.Delil
codemagic.yaml                    # android-release + ios-release workflow
```

## Servisler

### ReadTracker (`services/read_tracker.dart`)
```dart
ReadTracker.instance.markRead(id);   // Kart okundu işaretle
ReadTracker.instance.readIds         // ValueNotifier<Set<String>>
```

### TimeTracker (`services/time_tracker.dart`)
```dart
TimeTracker.instance.startSession('delil');  // initState'de çağır
TimeTracker.instance.endSession('delil');    // dispose'da çağır (async, 3sn min)
TimeTracker.instance.timeMs                 // ValueNotifier<Map<String, int>>
```
Modül anahtarları: `'delil'`, `'mucize'`, `'cevap'`, `'soz'`

### AdService (`services/ad_service.dart`)
```dart
AdService.instance.init();         // main()'de çağır (emülatörde otomatik skip)
AdService.instance.onCardRead();   // her detail screen initState'de çağır
AdService.instance.onBackPressed();// NavigatorObserver'dan otomatik çağrılır
AdService.instance.showRewarded(onRewarded: () {}); // isteğe bağlı
```
- Her 5 kart açılışında 1 interstitial reklam (600ms gecikmeyle)
- Her 10 geri tuşuna basışta 1 interstitial reklam (300ms gecikmeyle)
- Geri tuşu sayacı `_BackAdObserver` (NavigatorObserver) ile `main.dart`'tan otomatik beslenir
- Emülatörde hiç çalışmaz (`device_info_plus` ile tespit)
- Reklam kapanınca bir sonrakini önceden yükler
- Rewarded reklam altyapısı hazır (`showRewarded()` metodu), iOS'ta önceden yüklenir
- **Android AdMob App ID:** `ca-app-pub-6470338276121414~4246409025`
- **iOS AdMob App ID:** `ca-app-pub-6470338276121414~5227480364`
- **Android Interstitial Unit ID:** `ca-app-pub-6470338276121414/8002655354` (gecisDelil)
- **iOS Interstitial Unit ID:** `ca-app-pub-6470338276121414/1488716764` (gecisDelil iOS)
- **iOS Rewarded Unit ID:** `ca-app-pub-6470338276121414/2709128236` (delilrewardedios)
- Android Rewarded: henüz AdMob'da oluşturulmadı

### İstatistik Şeridi (`_BottomStatLine` in home_screen.dart)
Her içerik bölümünün scroll sonunda görünür:
`"X sa Y dk okundu  •  %Z.Z tamamlandı"`
Nested `ValueListenableBuilder` ile reaktif güncelleme.

## MarqueeTitle Widget
- 20 karakterden uzun başlıklar 2 sn sonra sola kayar
- Separator: 5 boşluk + altın `'-'` + 5 boşluk
- Seamless loop: iki kopya yan yana, `ClipRect + Transform.translate`
- Hız: 45 px/sn (ayarlanabilir)

## Tema Renk Sınıfları
- `AppColors` — temel renkler (background, surface, gold, textPrimary vs.)
- `MucizeColors` — mucize kategorileri için renk/ikon/etiket
- `SozColors` — söz kategorileri için 10 renk + `forQuoteType()` / `labelForQuoteType()`

## Önemli Kurallar
- Yeni özellik eklerken `AppColors` ve `GoogleFonts` stilini koru
- Detail screen initState: `ReadTracker.markRead` + `TimeTracker.startSession` + `AdService.onCardRead`
- Detail screen dispose: `TimeTracker.endSession` (animCtrl.dispose'dan ÖNCE)
- **AppBar arka planı her zaman `AppColors.surface`** — kart rengi KULLANMA (soz/mucize/cevap/delil hepsi)
- **Kart üst bandı arka planı `AppColors.surface`** — `catColorDim` değil
- **Tag arka planları `catColor.withAlpha(25)`** — `catColorDim` değil (mucize standardı)
- **MarqueeTitle rengi `AppColors.textPrimary`** — category rengi değil
- `withOpacity()` deprecation uyarıları var (info seviyesi, ignore edilebilir)
- NDK 27.0.12077973 sabit (google_mobile_ads gereksinimi)

## Strength Badge Mantığı
| Veri değeri   | Nokta | Etiket  |
|--------------|-------|---------|
| `yüksek`     | ●●●   | Güçlü   |
| `orta-yüksek`| ●●○   | Orta    |
| `orta`       | ●○○   | Zayıf   |

Tüm renkler: `AppColors.gold` (#D4A017)

## Codemagic CI/CD
- **Konfigürasyon:** `codemagic.yaml` (proje kökü)
- **İki workflow:** `android-release` (AAB) + `ios-release` (IPA → TestFlight)
- **Signing grubu:** `signing_credentials` (Codemagic → Environment variables → Groups)
  - `CERTIFICATE_PRIVATE_KEY` = base64 encode of `C:\src\magnus_app\ios_certs\ios_key_rsa.pem` (RSA formatı — BEGIN RSA PRIVATE KEY)
  - NOT: `ios_distribution.key` (PKCS#8) değil, `ios_key_rsa.pem` (RSA) kullan
- **App Store Connect entegrasyon adı:** `Codemagic` (Codemagic → Integrations → App Store Connect → "Codemagic")
- **Apple Team ID:** `SN5Y726ZKF`
- **Paylaşımlı sertifikalar:** `C:\src\magnus_app\ios_certs\` — tüm Futurastic projeleri bu sertifikaları paylaşır

### iOS ikon kuralı
- **Format:** `Format24bppRgb` (alpha kanalı OLMAMALI — App Store reddeder)
- **Arka plan:** `g.Clear(Color.FromArgb(255, 13, 11, 43))` → `#0D0B2B` doldur
- **Kaynak:** `assets/images/logo_round.png` → 15 boyut

### App Store screenshot kuralı
- iPhone: `1242 × 2688 px` (alpha kanalı olmadan)
- iPad: `2064 × 2752 px` (alpha kanalı olmadan)
- Format24bppRgb + `#0D0B2B` arka plan doldurma zorunlu

## Faydalı Araçlar
- **Play Store görselleri (screenshot, feature graphic):** https://www.launchshots.com/
- **Google Play Console uygulama silme işlem kimliği:** PDS.8886-0977-0480-55544

## Google Play & App Store & GitHub
- **Android paket adı:** `com.delilapp.delil`
- **iOS Bundle ID:** `com.futurastic.Delil`
- **App Store App ID:** `6780416985`
- **App Store Connect:** https://appstoreconnect.apple.com/apps/6780416985/distribution/ios/version/inflight
- **Web sitesi (GitHub repo):** https://anilgedikoglu.github.io/delil/
- **Gizlilik politikası (GitHub repo):** https://anilgedikoglu.github.io/delil/privacy_policy.html
- **Web sitesi (Futurastic):** https://futurastictech.github.io/delil/
- **Destek sayfası (Futurastic):** https://futurastictech.github.io/delil/support.html
- **Gizlilik politikası (Futurastic):** https://futurastictech.github.io/delil/privacy-policy.html
- **Geliştirici (Play Store):** Futurastic Tech. Ltd
- **İletişim e-postası:** deliltheapp@gmail.com
- **GitHub repo:** https://github.com/anilgedikoglu/delil

## Release İmzalama
- **Keystore:** `C:\src\delil\delil.jks` (repo'da mevcut)
- **Signing config:** `android/key.properties` (repo'da mevcut)
- **Alias:** `delil` | **Şifre:** `android/key.properties`'de
- **AAB build komutu:** `C:\flutter\bin\flutter.bat build appbundle --release`
- **Çıktı:** `build\app\outputs\bundle\release\app-release.aab`
- **Play Store'a yüklenen son sürüm:** versionCode 10, versionName 1.1.0
- **App Store (iOS) ilk sürüm:** build number timestamp bazlı (Codemagic), versionName 1.0.0
- **key.properties storeFile:** `../../delil.jks` (app/build.gradle.kts'e göre relative)
- **iOS App Store kategori:** Reference (ikincil: Education)
- **iOS App Store keywords:** `allah,mucize,islam,iman,kuran,tanrı,din,inanç,felsefe,kelam,ateizm,kanıt,varlık,akıl,söz,delil,cevap`
- **iOS SKU:** `delil001`

## Emülatör Komutları
```bash
# Emülatörü başlat
C:\Users\AG\AppData\Local\Android\Sdk\emulator\emulator.exe -avd Medium_Phone_API_36

# Uygulamayı çalıştır
cd C:\src\delil
C:\flutter\bin\flutter.bat run -d emulator-5554
```

## Yapılan Değişiklikler

### 2026-05-12
- Sabit header band: scroll ile kaymaması sağlandı
- Logo: şeffaf PNG header'a yerleştirildi (60px, 4px padding)
- Strength badge: oval çerçeve + sarı nokta + sarı etiket (compact mod da dahil)
- Badge etiketleri düzeltildi: Zayıf / Orta / Güçlü

### 2026-05-13 (Oturum 1)
- **Mucizeler modülü**: model, data, card widget, category screen, detail screen
- **Cevaplar modülü**: model, data, card widget, category screen, detail screen
- **Sözler modülü**: model, data, card widget, category screen, detail screen (SliverAppBar)
- **4. tab**: home_screen.dart IndexedStack → 4 tab (Sözler eklendi), tab font 10px
- **Arama**: search_screen.dart tamamen yeniden yazıldı — 4 modülde eş zamanlı arama
- **Kaynaklar**: sources_data.dart yeniden yazıldı — 38 kaynak, 4 modül gruplu
- **Uygulama ikonu**: circular PNG (lacivert bg + logo), adaptive icon XML, ic_launcher_round
- **Açılış ekranı**: beyaz arka plan kaldırıldı → sade lacivert (#0D0B2B)
- **MarqueeTitle**: kayan başlık widget'ı, gold separator, seamless loop
- **TimeTracker**: oturum süresi takibi, SharedPreferences kalıcılığı
- **İstatistik şeridi**: her modülün scroll sonunda "X sa Y dk · %Z tamamlandı"
- **Kaynaklar ekranı**: 4 modül başlıklı, açıklamalı kaynak listesi

### 2026-05-13 (Oturum 2)
- **AdMob reklamları**: google_mobile_ads + device_info_plus, her 5 kartta 1 interstitial
- **AdService**: emülatörde kapalı, reklam kapanınca sonrakini önceden yükler
- **Gizlilik politikası**: Futurastic Tech. Ltd, AdMob bölümü, deliltheapp@gmail.com
- **GitHub Pages**: docs/index.html (web sitesi ana sayfası) + docs/privacy_policy.html
- **Release keystore**: delil.jks + android/key.properties repo'ya eklendi
- **Play Store**: yeni uygulama olarak yüklendi (com.delilapp.delil, versionCode 2)
- **Sözler UI tutarlılığı**:
  - soz_category_screen: AppBar `AppColors.surface` sabit, MarqueeTitle `AppColors.textPrimary`
  - soz_card_widget: üst band `AppColors.surface`, tag bg `catColor.withAlpha(25)`
  - soz_detail_screen: SliverAppBar `AppColors.surface` (kart rengi yok)

### 2026-06-15
- **AdMob iOS/Android ayrı ID'ler**: ad_service.dart'ta `_interstitialIdAndroid`, `_interstitialIdIOS`, `_rewardedIdIOS` ayrı sabitler; `Platform.isIOS` getter ile otomatik seçim
- **iOS Info.plist**: `GADApplicationIdentifier` + `SKAdNetworkItems` + `ITSAppUsesNonExemptEncryption=false` eklendi
- **Geri tuşu reklamı**: Her 10 geri tuşuna 1 interstitial (300ms gecikmeyle)
- **_BackAdObserver**: `NavigatorObserver` → `didPop` olayını yakalar, tüm ekranları kapsar, tek kayıt `main.dart`'ta
- **iOS Bundle ID**: `com.futurastic.Delil` — xcodeproj'ta 3 Runner + RunnerTests yeri güncellendi
- **iOS App ikonları**: 15 boyut, Format24bppRgb (alpha yok), `#0D0B2B` arka plan, `logo_round.png` kaynak
- **key.properties storeFile**: `../../delil.jks` (file() android/app/ göreli → proje kökü için 2 üst dizin)
- **Codemagic CI/CD**: `codemagic.yaml` oluşturuldu — `android-release` + `ios-release` (signing_credentials grubu, Codemagic entegrasyonu)
- **Futurastic web**: `C:\src\futurastictech.github.io\delil\` — index.html, support.html, privacy-policy.html (TR/EN)
- **App Store screenshots**: iPhone 1242×2688, iPad 2064×2752, Format24bppRgb + `#0D0B2B` (alpha kanalı kaldırıldı)
- **Sürüm**: `pubspec.yaml` → `1.1.0+10`; Play Store son: versionCode 10, versionName 1.1.0
- **App Store**: SKU `delil001`, kategori Reference (ikincil Education), iOS ilk build gönderildi TestFlight'a
