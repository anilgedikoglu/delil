import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/delil_data.dart';
import '../theme/app_theme.dart';
import '../widgets/delil_card_widget.dart';
import 'detail_screen.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<dynamic> _recommended;

  @override
  void initState() {
    super.initState();
    _recommended = getRecommended();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── SABİT BAŞLIK ──────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(color: AppColors.cardBorder, width: 0.5),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Row(
                  children: [
                    // Logo %50 büyük — Transform.scale layout'u etkilemez
                    Transform.scale(
                      scale: 1.5,
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/images/logo_horizontal.png',
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gold.withOpacity(0.35)),
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.gold.withOpacity(0.08),
                      ),
                      child: Text(
                        '${allDeliller.length} Delil',
                        style: GoogleFonts.notoSans(
                          fontSize: 11,
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── KAYDIRILAN İÇERİK ─────────────────────────────────────
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.gold, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'En Güçlü 12 Delil',
                          style: GoogleFonts.notoSerif(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Önerilen Rota',
                          style: GoogleFonts.notoSans(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 210,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      itemCount: _recommended.length,
                      itemBuilder: (context, i) => DelilCardFeatured(
                        delil: _recommended[i],
                        index: i,
                        onTap: () async {
                          await Navigator.push(context, MaterialPageRoute(
                            builder: (_) => DetailScreen(delil: _recommended[i]),
                          ));
                          if (mounted) setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                    child: Row(
                      children: [
                        const Icon(Icons.grid_view_rounded, color: AppColors.gold, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Kategoriler',
                          style: GoogleFonts.notoSerif(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.55,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final cat = allCategories[i];
                        final count = getByCategory(cat).length;
                        final color = AppColors.forCategory(cat);
                        final dimColor = AppColors.dimForCategory(cat);
                        final icon = AppIcons.forCategory(cat);
                        return GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (_) => CategoryScreen(category: cat),
                          )),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: color.withOpacity(0.2)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: -10,
                                    bottom: -10,
                                    child: Icon(icon, size: 60, color: color.withOpacity(0.06)),
                                  ),
                                  Container(
                                    height: 3,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [color.withOpacity(0.8), color.withOpacity(0.2)],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: dimColor,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(icon, color: color, size: 16),
                                        ),
                                        const Spacer(),
                                        Text(
                                          _shortCatName(cat),
                                          style: GoogleFonts.notoSerif(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                            height: 1.3,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '$count delil',
                                          style: GoogleFonts.notoSans(
                                            fontSize: 11,
                                            color: color.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: allCategories.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _shortCatName(String cat) {
    switch (cat) {
      case 'Felsefi ve Kelâmî Deliller': return 'Felsefe & Kelâm';
      case 'Bilimsel ve Doğa Üzerinden Deliller': return 'Bilim & Kâinat';
      case 'İman Hakikatleri ve Risale-i Nur Tarzı Deliller': return 'Risale Tarzı';
      case 'Fıtrat, Ahlak ve İnsan Delilleri': return 'Fıtrat & Ahlak';
      case 'İtirazlar ve Cevap Kartları': return 'İtiraz-Cevap';
      case 'Kâinat ve Günlük Hayat Delilleri': return 'Günlük Hayat';
      default: return cat;
    }
  }
}
