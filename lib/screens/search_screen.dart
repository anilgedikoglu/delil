import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/delil_data.dart';
import '../models/delil_model.dart';
import '../theme/app_theme.dart';
import '../widgets/delil_card_widget.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<Delil> _results = [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final q = _controller.text.trim();
      setState(() {
        _query = q;
        _results = q.isEmpty ? [] : search(q);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ara',
                    style: GoogleFonts.notoSerif(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.goldLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: GoogleFonts.notoSerif(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Delil adı, etiket veya açıklama...',
                        hintStyle: GoogleFonts.notoSerif(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(Icons.search, color: AppColors.gold, size: 20),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: AppColors.textMuted, size: 18),
                                onPressed: () => _controller.clear(),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _query.isEmpty
                  ? _EmptySearch()
                  : _results.isEmpty
                      ? _NoResults(query: _query)
                      : _ResultsList(results: _results),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final suggestions = ['hudus', 'Big Bang', 'vicdan', 'ince ayar', 'bilinç', 'rahmet'];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Önerilen aramalar',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((s) => Builder(
              builder: (context) => GestureDetector(
                onTap: () {
                  final state = context.findAncestorStateOfType<_SearchScreenState>();
                  state?._controller.text = s;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Text(
                    s,
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 40),
          Center(
            child: Icon(Icons.search, size: 64, color: AppColors.textMuted.withOpacity(0.3)),
          ),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  final String query;
  const _NoResults({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 56, color: AppColors.textMuted.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            '"$query" için sonuç bulunamadı',
            style: GoogleFonts.notoSerif(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsList extends StatefulWidget {
  final List<Delil> results;
  const _ResultsList({required this.results});

  @override
  State<_ResultsList> createState() => _ResultsListState();
}

class _ResultsListState extends State<_ResultsList> {
  @override
  Widget build(BuildContext context) {
    final results = widget.results;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${results.length} sonuç',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, i) => DelilCardWidget(
              delil: results[i],
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(
                  builder: (_) => DetailScreen(delil: results[i]),
                ));
                if (mounted) setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }
}
