import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFF0D0B2B);
  static const surface = Color(0xFF16133A);
  static const cardBg = Color(0xFF1E1A4A);
  static const cardBorder = Color(0xFF2E2860);

  static const gold = Color(0xFFD4A017);
  static const goldLight = Color(0xFFF0C050);
  static const goldDim = Color(0xFF8A6A10);

  static const textPrimary = Color(0xFFEEEAFF);
  static const textSecondary = Color(0xFF9B94C8);
  static const textMuted = Color(0xFF5A5480);

  static const purple = Color(0xFF7C5FD4);
  static const purpleLight = Color(0xFFAA90FF);
  static const teal = Color(0xFF3A9B8C);
  static const green = Color(0xFF4E9A60);
  static const red = Color(0xFFB05050);
  static const blue = Color(0xFF3A6EB0);
  static const amber = Color(0xFFD4851A);

  static const rose    = Color(0xFFA0406A);
  static const indigo  = Color(0xFF3A4AAA);
  static const copper  = Color(0xFFA0603A);
  static const lime    = Color(0xFF4A9A3A);
  static const cyan    = Color(0xFF2A8A9A);
  static const orange  = Color(0xFFB07020);

  static const Map<String, Color> categoryColors = {
    'Felsefi ve Kelâmî Deliller':                      purple,
    'Bilimsel ve Doğa Üzerinden Deliller':             teal,
    'İman Hakikatleri ve Risale-i Nur Tarzı Deliller': amber,
    'Fıtrat, Ahlak ve İnsan Delilleri':                green,
    'İtirazlar ve Cevap Kartları':                     red,
    'Kâinat ve Günlük Hayat Delilleri':                blue,
    // Yeni kategoriler
    'Matematiksel ve Mantıksal Deliller':              orange,
    'Biyolojik Deliller':                              lime,
    'Fizik ve Kozmoloji Delilleri':                    cyan,
    'Astronomi Delilleri':                             indigo,
    'Estetik ve Anlam Delilleri':                      rose,
    'Tarihî Deliller':                                 copper,
  };

  static const Map<String, Color> categoryColorsDim = {
    'Felsefi ve Kelâmî Deliller':                      Color(0xFF3D2F6A),
    'Bilimsel ve Doğa Üzerinden Deliller':             Color(0xFF1D4D46),
    'İman Hakikatleri ve Risale-i Nur Tarzı Deliller': Color(0xFF6A420D),
    'Fıtrat, Ahlak ve İnsan Delilleri':                Color(0xFF234D30),
    'İtirazlar ve Cevap Kartları':                     Color(0xFF582828),
    'Kâinat ve Günlük Hayat Delilleri':                Color(0xFF1D3758),
    // Yeni kategoriler
    'Matematiksel ve Mantıksal Deliller':              Color(0xFF583810),
    'Biyolojik Deliller':                              Color(0xFF234D1D),
    'Fizik ve Kozmoloji Delilleri':                    Color(0xFF15454D),
    'Astronomi Delilleri':                             Color(0xFF1D2558),
    'Estetik ve Anlam Delilleri':                      Color(0xFF502035),
    'Tarihî Deliller':                                 Color(0xFF50301D),
  };

  static Color forCategory(String cat) =>
      categoryColors[cat] ?? purple;
  static Color dimForCategory(String cat) =>
      categoryColorsDim[cat] ?? const Color(0xFF3D2F6A);
}

class AppIcons {
  static const Map<String, IconData> categoryIcons = {
    'Felsefi ve Kelâmî Deliller': Icons.auto_stories_outlined,
    'Bilimsel ve Doğa Üzerinden Deliller': Icons.science_outlined,
    'İman Hakikatleri ve Risale-i Nur Tarzı Deliller': Icons.menu_book_outlined,
    'Fıtrat, Ahlak ve İnsan Delilleri': Icons.favorite_border,
    'İtirazlar ve Cevap Kartları': Icons.balance_outlined,
    'Kâinat ve Günlük Hayat Delilleri': Icons.nature_outlined,
    'Matematiksel ve Mantıksal Deliller': Icons.calculate_outlined,
    'Biyolojik Deliller': Icons.biotech_outlined,
    'Fizik ve Kozmoloji Delilleri': Icons.bolt_outlined,
    'Astronomi Delilleri': Icons.nights_stay_outlined,
    'Estetik ve Anlam Delilleri': Icons.palette_outlined,
    'Tarihî Deliller': Icons.history_edu_outlined,
  };

  static IconData forCategory(String cat) =>
      categoryIcons[cat] ?? Icons.lightbulb_outline;
}

ThemeData buildAppTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.gold,
      secondary: AppColors.purple,
      surface: AppColors.surface,
      onPrimary: AppColors.background,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
    ),
    textTheme: GoogleFonts.notoSerifTextTheme(base.textTheme).copyWith(
      headlineLarge: GoogleFonts.notoSerif(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.goldLight,
        letterSpacing: 0.5,
      ),
      headlineMedium: GoogleFonts.notoSerif(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.notoSerif(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.notoSerif(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.notoSerif(
        fontSize: 15,
        height: 1.65,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.notoSerif(
        fontSize: 13,
        height: 1.55,
        color: AppColors.textSecondary,
      ),
      labelSmall: GoogleFonts.notoSans(
        fontSize: 11,
        color: AppColors.textMuted,
        letterSpacing: 0.5,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      titleTextStyle: GoogleFonts.notoSerif(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.goldLight,
        letterSpacing: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.gold),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.gold,
      unselectedItemColor: AppColors.textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    dividerColor: AppColors.cardBorder,
    cardColor: AppColors.cardBg,
  );
}
