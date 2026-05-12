import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/mucize_model.dart';
import '../theme/app_theme.dart';

class MucizeDetailScreen extends StatelessWidget {
  final Mucize mucize;
  const MucizeDetailScreen({super.key, required this.mucize});

  @override
  Widget build(BuildContext context) {
    final catColor = MucizeColors.forCategory(mucize.category);
    final catIcon  = MucizeColors.iconForCategory(mucize.category);
    final typeColor = MucizeColors.forMiracleType(mucize.miracleType);
    final typeLabel = MucizeColors.labelForMiracleType(mucize.miracleType);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── SABİT HEADER ──────────────────────────────────────────────
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
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: AppColors.gold, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: catColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(catIcon, color: catColor, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            mucize.id,
                            style: GoogleFonts.notoSans(
                              fontSize: 10,
                              color: catColor.withOpacity(0.8),
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            mucize.title,
                            style: GoogleFonts.notoSerif(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Tür badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: typeColor.withOpacity(0.30)),
                      ),
                      child: Text(
                        typeLabel,
                        style: GoogleFonts.notoSans(
                          fontSize: 9,
                          color: typeColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── KAYDIRILAN İÇERİK ─────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kaynak referansı kutusu
                  if (mucize.sourceRef.isNotEmpty)
                    _SourceRefBox(
                      ref: mucize.sourceRef,
                      text: mucize.sourceTextShort,
                      color: catColor,
                    ),
                  if (mucize.sourceRef.isNotEmpty) const SizedBox(height: 20),

                  // Mucize iddiası (öne çıkan)
                  _SectionTitle('Mucize / İşaret'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: catColor.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                      border: Border(left: BorderSide(color: catColor, width: 3)),
                    ),
                    child: Text(
                      mucize.claim,
                      style: GoogleFonts.notoSerif(
                        fontSize: 15.5,
                        height: 1.65,
                        color: AppColors.textPrimary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  _SectionTitle('Açıklama'),
                  const SizedBox(height: 10),
                  Text(
                    mucize.explanation,
                    style: GoogleFonts.notoSerif(
                      fontSize: 15,
                      height: 1.75,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  // Doğrulama notu
                  if (mucize.verificationNote.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _VerificationNoteBox(note: mucize.verificationNote),
                  ],

                  // Etiketler
                  if (mucize.tags.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _SectionTitle('Etiketler'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: mucize.tags.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: catColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: catColor.withOpacity(0.3)),
                        ),
                        child: Text(tag,
                            style: GoogleFonts.notoSans(fontSize: 12, color: catColor)),
                      )).toList(),
                    ),
                  ],

                  // Kategori satırı
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(catIcon, color: catColor, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mucize.category,
                                style: GoogleFonts.notoSans(
                                    fontSize: 11, color: catColor,
                                    fontWeight: FontWeight.w600)),
                              Text(mucize.subcategory,
                                style: GoogleFonts.notoSans(
                                    fontSize: 11, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 16, color: AppColors.gold,
            margin: const EdgeInsets.only(right: 8)),
        Text(title, style: GoogleFonts.notoSerif(
          fontSize: 13, fontWeight: FontWeight.w700,
          color: AppColors.gold, letterSpacing: 1,
        )),
      ],
    );
  }
}

class _SourceRefBox extends StatelessWidget {
  final String ref;
  final String text;
  final Color color;
  const _SourceRefBox({required this.ref, required this.text, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book_outlined, size: 14, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(ref, style: GoogleFonts.notoSans(
                  fontSize: 12, fontWeight: FontWeight.w700,
                  color: color, letterSpacing: 0.3,
                )),
              ),
            ],
          ),
          if (text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(text, style: GoogleFonts.notoSerif(
              fontSize: 13.5, fontStyle: FontStyle.italic,
              color: AppColors.textSecondary, height: 1.55,
            )),
          ],
        ],
      ),
    );
  }
}

class _VerificationNoteBox extends StatelessWidget {
  final String note;
  const _VerificationNoteBox({required this.note});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.amber.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.amber.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 15, color: AppColors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(note, style: GoogleFonts.notoSans(
              fontSize: 11.5, color: AppColors.textSecondary, height: 1.55,
            )),
          ),
        ],
      ),
    );
  }
}
