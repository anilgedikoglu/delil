import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/sources_data.dart';
import '../models/delil_model.dart';
import '../theme/app_theme.dart';

class SourcesScreen extends StatelessWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kaynaklar',
                      style: GoogleFonts.notoSerif(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.goldLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Kartlarda kullanılan akademik ve dinî kaynaklar',
                      style: GoogleFonts.notoSerif(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _SourceTile(source: allSources[i]),
                childCount: allSources.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.gold.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.gold, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Editoryal Not',
                            style: GoogleFonts.notoSerif(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Bu içerik, uygulama kartları için hazırlanmış özet ve telif açısından özgünleştirilmiş açıklamalardır. Deliller kesin matematik ispat gibi değil; felsefi, kelâmî, bilimsel ve fıtrî gerekçeler olarak sunulmalıdır.',
                        style: GoogleFonts.notoSerif(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  final DelilSource source;
  const _SourceTile({required this.source});

  @override
  Widget build(BuildContext context) {
    final src = source;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    src.code,
                    style: GoogleFonts.notoSans(
                      fontSize: 10,
                      color: AppColors.gold,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    src.title,
                    style: GoogleFonts.notoSerif(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link, color: AppColors.textMuted, size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      src.url,
                      style: GoogleFonts.notoSans(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
