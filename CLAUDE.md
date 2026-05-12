# DELİL Flutter Uygulaması — CLAUDE.md

## Proje Özeti
Allah'ın varlığının 117 delilini kart tabanlı UI ile sunan Flutter mobil uygulaması.

## Teknik Yapı
- **Flutter SDK**: `C:\flutter`
- **Proje dizini**: `C:\src\delil`
- **Paketler**: `google_fonts: ^6.2.1` (Noto Serif + Noto Sans)
- **Veri**: 117 kart, `const` Dart listesi — JSON yok, runtime parse yok
- **Tema**: Koyu lacivert `#0D0B2B` + altın `#D4A017`
- **Emülatör**: `emulator-5554` (Medium_Phone_API_36)

## Dosya Yapısı
```
lib/
  main.dart               # DelilApp → MainShell (IndexedStack, 3 tab)
  models/delil_model.dart # Delil, DelilSource sınıfları
  data/
    delil_data.dart       # 117 kart const verisi + helper fonksiyonlar
    sources_data.dart     # 13 kaynak
  theme/app_theme.dart    # AppColors, AppIcons, buildAppTheme()
  screens/
    home_screen.dart      # Sabit header + önerilen 12 kart + 6 kategori grid
    category_screen.dart  # Kategori listesi (alt kategori gruplu)
    detail_screen.dart    # Kart detayı (alıntı, açıklama, itiraz-cevap)
    search_screen.dart    # Canlı arama
    sources_screen.dart   # Kaynaklar listesi
  widgets/
    delil_card_widget.dart  # DelilCardWidget (liste) + DelilCardFeatured (yatay)
    strength_badge.dart     # Güç göstergesi (oval, sarı, nokta + etiket)
    app_logo.dart           # AppLogoHeader (artık kullanılmıyor)
assets/
  images/
    logo.png              # Yuvarlak logo
    logo_round.png        # Alternatif yuvarlak logo
    logo_horizontal.png   # Şeffaf zemin yatay logo (header'da kullanılan)
```

## Önemli Kurallar
- Yeni özellik eklerken `AppColors` ve `GoogleFonts` stilini koru
- Veri değişikliği için `lib/data/delil_data.dart` güncelle
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

## Yapılan Değişiklikler (2026-05-12)
- Sabit header band: scroll ile kaymaması sağlandı
- Logo: `ikonseffaf.png` şeffaf PNG header'a yerleştirildi (60px, 4px padding)
- Strength badge: oval çerçeve + sarı nokta + sarı etiket (compact mod da dahil)
- Badge etiketleri düzeltildi: Zayıf / Orta / Güçlü
