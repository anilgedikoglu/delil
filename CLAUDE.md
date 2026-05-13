# DELİL Flutter Uygulaması — CLAUDE.md

## Proje Özeti
Allah'ın varlığının delillerini, mucizelerini, itiraz-cevaplarını ve önemli kişilerin sözlerini
kart tabanlı UI ile sunan Flutter mobil uygulaması. 4 modül, koyu lacivert/altın tema.

## Teknik Yapı
- **Flutter SDK**: `C:\flutter`
- **Proje dizini**: `C:\src\delil`
- **Paketler**: `google_fonts: ^6.2.1` (Noto Serif + Noto Sans), `shared_preferences`
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
    soz_category_screen.dart    # Sözler kategori (MarqueeTitle)
    detail_screen.dart          # Delil detayı (TimeTracker)
    mucize_detail_screen.dart   # Mucize detayı (TimeTracker)
    cevap_detail_screen.dart    # Cevap detayı (TimeTracker)
    soz_detail_screen.dart      # Söz detayı (TimeTracker, SliverAppBar)
    search_screen.dart          # 4 modülde eş zamanlı arama, gruplu sonuçlar
    sources_screen.dart         # Modüle göre gruplu 38 kaynak
  services/
    read_tracker.dart           # ReadTracker singleton, ValueNotifier<Set<String>>, SharedPreferences
    time_tracker.dart           # TimeTracker singleton, ValueNotifier<Map<String,int>>, SharedPreferences
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
android/app/src/main/res/
  mipmap-*/ic_launcher.png          # Yuvarlak ikon (lacivert bg + logo)
  mipmap-*/ic_launcher_round.png    # Yuvarlak ikon (aynı)
  mipmap-*/ic_launcher_foreground.png # Adaptive icon foreground
  mipmap-anydpi-v26/ic_launcher.xml # Adaptive icon XML
  values/colors.xml                 # launch_bg = #0D0B2B
docs/
  privacy_policy.html               # GitHub Pages gizlilik politikası
```

## Servisler

### ReadTracker (`services/read_tracker.dart`)
```dart
ReadTracker.instance.markRead(id);           // Kart okundu işaretle
ReadTracker.instance.readIds                 // ValueNotifier<Set<String>>
```

### TimeTracker (`services/time_tracker.dart`)
```dart
TimeTracker.instance.startSession('delil');  // initState'de çağır
TimeTracker.instance.endSession('delil');    // dispose'da çağır (async, 3sn min)
TimeTracker.instance.timeMs                 // ValueNotifier<Map<String, int>>
```
Modül anahtarları: `'delil'`, `'mucize'`, `'cevap'`, `'soz'`

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
- Detail screen initState: `ReadTracker.instance.markRead(id)` + `TimeTracker.instance.startSession(module)`
- Detail screen dispose: `TimeTracker.instance.endSession(module)` (animCtrl.dispose'dan ÖNCE)
- AppBar arka planı her zaman `AppColors.surface` — kart rengi KULLANMA
- `withOpacity()` deprecation uyarıları var (info seviyesi, ignore edilebilir)
- NDK 26/27 uyumsuzluk uyarısı var (build başarılı, hata değil)

## Strength Badge Mantığı
| Veri değeri   | Nokta | Etiket  |
|--------------|-------|---------|
| `yüksek`     | ●●●   | Güçlü   |
| `orta-yüksek`| ●●○   | Orta    |
| `orta`       | ●○○   | Zayıf   |

Tüm renkler: `AppColors.gold` (#D4A017)

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

### 2026-05-13
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
- **GitHub Pages**: `docs/privacy_policy.html` oluşturuldu
