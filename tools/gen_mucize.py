# -*- coding: utf-8 -*-
"""
1000 mucize kartını mucize_data.dart'a çevirir.
Çalıştır: python tools/gen_mucize.py
"""
import json, os

JSON_PATH = r'C:\Users\AG\Documents\Downloads\urasokul\DELIL_1000_mucize_karti.json'
OUT_PATH  = r'C:\src\delil\lib\data\mucize_data.dart'

def ds(s):
    if s is None: return "''"
    s = str(s)
    s = s.replace('\\', '\\\\')
    s = s.replace("'", "\\'")
    s = s.replace('\r', '').replace('\n', ' ').replace('\t', ' ')
    s = s.replace('$', '\\$')
    return f"'{s}'"

print(f'Reading {JSON_PATH} …')
with open(JSON_PATH, 'r', encoding='utf-8') as f:
    data = json.load(f)

cards = data['cards']
print(f'Total cards: {len(cards)}')

# Önerilen ilk 12 kart (kategori temsilcileri)
RECOMMENDED_IDS = [
    'MUCIZE-0001', 'MUCIZE-0101', 'MUCIZE-0151', 'MUCIZE-0201',
    'MUCIZE-0301', 'MUCIZE-0351', 'MUCIZE-0401', 'MUCIZE-0501',
    'MUCIZE-0601', 'MUCIZE-0701', 'MUCIZE-0901', 'MUCIZE-0951',
]

lines = [
    '// ignore_for_file: lines_longer_than_80_chars, prefer_single_quotes',
    "import '../models/mucize_model.dart';",
    '',
    '// ── Kategori sabitleri ────────────────────────────────────────────────',
    "const String _mKuran    = 'Kur\\'an Mucizeleri';",
    "const String _mPeygamber = 'Hz. Muhammed\\'in Mucizeleri';",
    "const String _mKissa    = 'Peygamberler ve Kur\\'an Kıssaları';",
    "const String _mHikmet   = 'İslam\\'ın Hikmet ve Medeniyet Mucizeleri';",
    '',
    'const List<String> allMucizeCategories = [',
    '  _mKuran, _mPeygamber, _mKissa, _mHikmet,',
    '];',
    '',
    'const List<Mucize> allMucizeler = [',
]

CAT_CONST = {
    'Kur\'an Mucizeleri':                           '_mKuran',
    'Hz. Muhammed\'in Mucizeleri':                  '_mPeygamber',
    'Peygamberler ve Kur\'an Kıssaları':            '_mKissa',
    'İslam\'ın Hikmet ve Medeniyet Mucizeleri':     '_mHikmet',
}

for i, card in enumerate(cards):
    new_id  = f'MUCIZE-{i+1:04d}'
    raw_cat = card.get('category', '')
    cat_c   = CAT_CONST.get(raw_cat, '_mKuran')

    lines.append('  Mucize(')
    lines.append(f"    id: '{new_id}',")
    lines.append(f'    title: {ds(card.get("title",""))},')
    lines.append(f'    category: {cat_c},')
    lines.append(f'    subcategory: {ds(card.get("subcategory",""))},')
    sr = card.get('sourceRef','')
    st = card.get('sourceTextShort','')
    if sr: lines.append(f'    sourceRef: {ds(sr)},')
    if st: lines.append(f'    sourceTextShort: {ds(st)},')
    lines.append(f'    claim: {ds(card.get("claim",""))},')
    mt = card.get('miracleType','')
    if mt: lines.append(f'    miracleType: {ds(mt)},')
    lines.append(f'    explanation: {ds(card.get("explanation",""))},')
    vn = card.get('verificationNote','')
    if vn: lines.append(f'    verificationNote: {ds(vn)},')
    tags = card.get('tags', [])
    if tags:
        lines.append(f'    tags: [{", ".join(ds(t) for t in tags)}],')
    srcs = card.get('sources', [])
    if srcs:
        lines.append(f'    sources: [{", ".join(ds(s) for s in srcs)}],')
    lines.append('  ),')

lines += [
    '];',
    '',
    '// ── Yardımcı fonksiyonlar ─────────────────────────────────────────────',
    'List<Mucize> getMucizeByCategory(String cat) =>',
    '    allMucizeler.where((m) => m.category == cat).toList();',
    '',
    'List<Mucize> searchMucize(String q) {',
    '  final lower = q.toLowerCase();',
    '  return allMucizeler.where((m) =>',
    '    m.title.toLowerCase().contains(lower) ||',
    '    m.claim.toLowerCase().contains(lower) ||',
    '    m.tags.any((t) => t.toLowerCase().contains(lower)),',
    '  ).toList();',
    '}',
    '',
    'List<Mucize> getRecommendedMucize() {',
]
rec_str = ', '.join(f"'{r}'" for r in RECOMMENDED_IDS)
lines.append(f'  const ids = [{rec_str}];')
lines += [
    '  return ids',
    '      .map((id) => allMucizeler.firstWhere(',
    "        (m) => m.id == id,",
    '        orElse: () => allMucizeler.first,',
    '      ))',
    '      .toList();',
    '}',
]

output = '\n'.join(lines) + '\n'
print(f'Writing {OUT_PATH} …')
with open(OUT_PATH, 'w', encoding='utf-8') as f:
    f.write(output)
size_kb = os.path.getsize(OUT_PATH) // 1024
print(f'Done — {len(cards)} mucize, {size_kb} KB')
