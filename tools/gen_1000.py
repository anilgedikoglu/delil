# -*- coding: utf-8 -*-
"""
1000 kartlık JSON'u delil_data.dart'a dönüştürür.
Çalıştır: python tools/gen_1000.py
"""
import json, sys, os

JSON_PATH = r'C:\Users\AG\Documents\Downloads\urasokul\DELIL_1000_kart_detayli_aciklamali.json'
OUT_PATH  = r'C:\src\delil\lib\data\delil_data.dart'

# ── Kategori haritası ────────────────────────────────────────────────────────
CAT_MAP = {
    'Felsefi ve Kelâmî Deliller':                        'Felsefi ve Kelâmî Deliller',
    'Felsefi Deliller':                                  'Felsefi ve Kelâmî Deliller',
    'Felsefi ve Psikolojik Deliller':                    'Felsefi ve Kelâmî Deliller',
    'Modern Analitik Deliller':                          'Felsefi ve Kelâmî Deliller',
    'Modern Metafizik Deliller':                         'Felsefi ve Kelâmî Deliller',
    'Tarihî Filozoflar ve Klasik Savlar':                'Felsefi ve Kelâmî Deliller',

    'Bilimsel ve Doğa Üzerinden Deliller':               'Bilimsel ve Doğa Üzerinden Deliller',

    'İman Hakikatleri ve Risale-i Nur Tarzı Deliller':   'İman Hakikatleri ve Risale-i Nur Tarzı Deliller',
    'İslami İman Hakikatleri ve Esmâ Delilleri':         'İman Hakikatleri ve Risale-i Nur Tarzı Deliller',
    'İslamî İman Hakikatleri ve Esmâ Delilleri':         'İman Hakikatleri ve Risale-i Nur Tarzı Deliller',
    "İslami Kelâm, Kur'an ve Risale Delilleri":          'İman Hakikatleri ve Risale-i Nur Tarzı Deliller',
    'İslamî Kelâm, Kur’an ve Risale Delilleri':    'İman Hakikatleri ve Risale-i Nur Tarzı Deliller',
    'İslami, Rivayet ve Manevi Delil Kartları':          'İman Hakikatleri ve Risale-i Nur Tarzı Deliller',

    'Fıtrat, Ahlak ve İnsan Delilleri':                  'Fıtrat, Ahlak ve İnsan Delilleri',
    'Ahlak Delilleri':                                   'Fıtrat, Ahlak ve İnsan Delilleri',
    'Ahlak, Değer ve Fıtrat Delilleri':                  'Fıtrat, Ahlak ve İnsan Delilleri',
    'Fıtrat Delilleri':                                  'Fıtrat, Ahlak ve İnsan Delilleri',

    'İtirazlar ve Cevap Kartları':                       'İtirazlar ve Cevap Kartları',

    'Kâinat ve Günlük Hayat Delilleri':                  'Kâinat ve Günlük Hayat Delilleri',

    'Matematiksel ve Mantıksal Deliller':                'Matematiksel ve Mantıksal Deliller',
    'Matematiksel, İstatistiksel ve Bilgi Delilleri':    'Matematiksel ve Mantıksal Deliller',
    'Matematiksel, Mantıksal ve İstatistiksel Deliller': 'Matematiksel ve Mantıksal Deliller',
    'Bilişim ve Bilgi Teorisi':                          'Matematiksel ve Mantıksal Deliller',

    'Biyolojik Deliller':                                'Biyolojik Deliller',
    'Biyolojik ve Canlılık Delilleri':                   'Biyolojik Deliller',
    'Biyolojik ve Medikal Deliller':                     'Biyolojik Deliller',
    'Kimya ve Biyokimya Delilleri':                      'Biyolojik Deliller',

    'Fizik ve Kozmoloji Delilleri':                      'Fizik ve Kozmoloji Delilleri',
    'Fizik, Kozmoloji ve Kimya Delilleri':               'Fizik ve Kozmoloji Delilleri',

    'Astronomi Delilleri':                               'Astronomi Delilleri',

    'Estetik ve Anlam Delilleri':                        'Estetik ve Anlam Delilleri',
    'Estetik, Arzu ve Dinî Tecrübe Delilleri':           'Estetik ve Anlam Delilleri',

    'Tarihî Deliller':                                   'Tarihî Deliller',
    'Tarihî ve Entelektüel Şahitlik Delilleri':          'Tarihî Deliller',
    'Tarihî ve Felsefi Deliller':                        'Tarihî Deliller',

    'Zihin, Akıl ve Epistemoloji Delilleri':             'Zihin ve Bilinç Delilleri',
    'Zihin, Bilinç ve Akıl Delilleri':                   'Zihin ve Bilinç Delilleri',
    'Bilinç ve Zihin Delilleri':                         'Zihin ve Bilinç Delilleri',
    'Bilinç, Ahlak ve İnsan Delilleri':                  'Zihin ve Bilinç Delilleri',
}

CAT_CONST = {
    'Felsefi ve Kelâmî Deliller':                        '_felsefi',
    'Bilimsel ve Doğa Üzerinden Deliller':               '_bilimsel',
    'İman Hakikatleri ve Risale-i Nur Tarzı Deliller':   '_iman',
    'Fıtrat, Ahlak ve İnsan Delilleri':                  '_fitrat',
    'İtirazlar ve Cevap Kartları':                       '_itiraz',
    'Kâinat ve Günlük Hayat Delilleri':                  '_kainat',
    'Matematiksel ve Mantıksal Deliller':                '_matematik',
    'Biyolojik Deliller':                                '_biyoloji',
    'Fizik ve Kozmoloji Delilleri':                      '_fizik',
    'Astronomi Delilleri':                               '_astronomi',
    'Estetik ve Anlam Delilleri':                        '_estetik',
    'Tarihî Deliller':                                   '_tarih',
    'Zihin ve Bilinç Delilleri':                         '_zihin',
}

# ── Dart string escape ───────────────────────────────────────────────────────
def ds(s):
    """Verilen Python string'i tek-tırnaklı Dart literal'e çevirir."""
    if s is None:
        return "''"
    s = str(s)
    s = s.replace('\\', '\\\\')
    s = s.replace("'", "\\'")
    s = s.replace('\r', '')
    s = s.replace('\n', ' ')
    s = s.replace('\t', ' ')
    s = s.replace('$', '\\$')
    return f"'{s}'"

# ── JSON oku ─────────────────────────────────────────────────────────────────
print(f'Reading {JSON_PATH} …')
with open(JSON_PATH, 'r', encoding='utf-8') as f:
    data = json.load(f)

cards    = data['cards']
rec_ids  = [str(r) for r in data.get('recommendedHomeCards', [])]

# JSON id → yeni DELIL-XXXX id
id_map = {str(c['id']): f'DELIL-{i+1:04d}' for i, c in enumerate(cards)}
recommended = [id_map[r] for r in rec_ids if r in id_map]

print(f'Total cards: {len(cards)}')
print(f'Recommended: {recommended}')

# ── Dart kodu oluştur ────────────────────────────────────────────────────────
lines = []
lines += [
    '// ignore_for_file: lines_longer_than_80_chars, prefer_single_quotes',
    "import '../models/delil_model.dart';",
    '',
    '// ── Kategori sabitleri ────────────────────────────────────────────────',
    "const String _felsefi   = 'Felsefi ve Kelâmî Deliller';",
    "const String _bilimsel  = 'Bilimsel ve Doğa Üzerinden Deliller';",
    "const String _iman      = 'İman Hakikatleri ve Risale-i Nur Tarzı Deliller';",
    "const String _fitrat    = 'Fıtrat, Ahlak ve İnsan Delilleri';",
    "const String _itiraz    = 'İtirazlar ve Cevap Kartları';",
    "const String _kainat    = 'Kâinat ve Günlük Hayat Delilleri';",
    "const String _matematik = 'Matematiksel ve Mantıksal Deliller';",
    "const String _biyoloji  = 'Biyolojik Deliller';",
    "const String _fizik     = 'Fizik ve Kozmoloji Delilleri';",
    "const String _astronomi = 'Astronomi Delilleri';",
    "const String _estetik   = 'Estetik ve Anlam Delilleri';",
    "const String _tarih     = 'Tarihî Deliller';",
    "const String _zihin     = 'Zihin ve Bilinç Delilleri';",
    '',
    'const List<String> allCategories = [',
    '  _felsefi, _bilimsel, _iman, _fitrat, _itiraz, _kainat,',
    '  _matematik, _biyoloji, _fizik, _astronomi, _estetik, _tarih, _zihin,',
    '];',
    '',
    'const List<Delil> allDeliller = [',
]

unmapped = set()

for i, card in enumerate(cards):
    new_id   = f'DELIL-{i+1:04d}'
    raw_cat  = card.get('category', '')
    cat      = CAT_MAP.get(raw_cat)
    if cat is None:
        unmapped.add(raw_cat)
        cat = 'Felsefi ve Kelâmî Deliller'
    cat_c    = CAT_CONST[cat]

    subcat   = card.get('subcategory', '')
    title    = card.get('title', '')
    short    = card.get('short', '')
    expanded = card.get('expanded', '')
    tags     = card.get('tags', [])
    strength = card.get('strength', 'orta')
    sources  = card.get('sources', [])
    obj      = card.get('objection', '')
    reply    = card.get('reply', '')
    de       = card.get('detailedExplanation') or {}

    tags_dart    = ', '.join(ds(t) for t in tags)
    sources_dart = ', '.join(ds(s) for s in sources)

    lines.append(f'  Delil(')
    lines.append(f"    id: 'DELIL-{i+1:04d}',")
    lines.append(f'    category: {cat_c},')
    lines.append(f'    subcategory: {ds(subcat)},')
    lines.append(f'    title: {ds(title)},')
    lines.append(f'    short: {ds(short)},')
    lines.append(f'    expanded: {ds(expanded)},')
    lines.append(f'    tags: [{tags_dart}],')
    lines.append(f'    strength: {ds(strength)},')
    if sources:
        lines.append(f'    sources: [{sources_dart}],')
    if obj:
        lines.append(f'    objection: {ds(obj)},')
    if reply:
        lines.append(f'    reply: {ds(reply)},')

    ky  = de.get('kaynakYeri', '')
    km  = de.get('kaynakMetniVeyaCekirdekFormulasyon', '')
    nd  = de.get('nedenDelildir', '')
    un  = de.get('uygulamaNotu', '')
    if ky or km or nd or un:
        lines.append('    detailedExplanation: DetailedExplanation(')
        if ky: lines.append(f'      kaynakYeri: {ds(ky)},')
        if km: lines.append(f'      kaynakMetniVeyaCekirdekFormulasyon: {ds(km)},')
        if nd: lines.append(f'      nedenDelildir: {ds(nd)},')
        if un: lines.append(f'      uygulamaNotu: {ds(un)},')
        lines.append('    ),')

    lines.append('  ),')

lines += [
    '];',
    '',
    '// ── Yardımcı fonksiyonlar ─────────────────────────────────────────────',
    'List<Delil> getByCategory(String cat) =>',
    '    allDeliller.where((d) => d.category == cat).toList();',
    '',
    'List<Delil> search(String q) {',
    '  final lower = q.toLowerCase();',
    '  return allDeliller.where((d) =>',
    '    d.title.toLowerCase().contains(lower) ||',
    '    d.short.toLowerCase().contains(lower) ||',
    '    d.tags.any((t) => t.toLowerCase().contains(lower)),',
    '  ).toList();',
    '}',
    '',
    'List<Delil> getRecommended() {',
]
rec_str = ', '.join(f"'{r}'" for r in recommended)
lines.append(f'  const ids = [{rec_str}];')
lines += [
    '  return ids',
    '      .map((id) => allDeliller.firstWhere(',
    "        (d) => d.id == id,",
    '        orElse: () => allDeliller.first,',
    '      ))',
    '      .toList();',
    '}',
]

output = '\n'.join(lines) + '\n'

print(f'Writing {OUT_PATH} …')
with open(OUT_PATH, 'w', encoding='utf-8') as f:
    f.write(output)

size_kb = os.path.getsize(OUT_PATH) // 1024
print(f'Done — {len(cards)} cards, {size_kb} KB')
if unmapped:
    print(f'WARNING — unmapped categories: {unmapped}')
