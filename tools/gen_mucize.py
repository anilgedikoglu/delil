# -*- coding: utf-8 -*-
"""
1000 mucize kartını (yeni yapı) mucize_data.dart'a çevirir.
Çalıştır: python tools/gen_mucize.py
"""
import json, os, re

JSON_PATH = r'C:\Users\AG\Documents\Downloads\urasokul\DELIL_1000_mucize_final_wow_detayli.json'
OUT_PATH  = r'C:\src\delil\lib\data\mucize_data.dart'

PYTHON = r'C:\Users\AG\AppData\Local\Android\Sdk\ndk\27.0.12077973\toolchains\llvm\prebuilt\windows-x86_64\python3\python.exe'

def ds(s):
    """Dart string literal (single-quoted, escaped)."""
    if s is None: return "''"
    s = str(s).strip()
    s = s.replace('\\', '\\\\')
    s = s.replace("'", "\\'")
    s = s.replace('\r', '').replace('\n', ' ').replace('\t', ' ')
    s = s.replace('$', '\\$')
    return f"'{s}'"

def strip_perspective(title):
    """Remove ' — Perspective Suffix' from title for cleaner display."""
    # Titles like 'Ana Konu — Perspektif Açısından' → 'Ana Konu'
    idx = title.find(' — ')  # em dash with spaces
    if idx == -1:
        idx = title.find(' - ')  # fallback: plain dash
    if idx > 0:
        return title[:idx]
    return title

print(f'Reading {JSON_PATH} …')
with open(JSON_PATH, 'r', encoding='utf-8') as f:
    data = json.load(f)

cards = data['cards']
print(f'Total cards: {len(cards)}')

# ── Kategori sabitleri ──────────────────────────────────────────────────────
CAT_CONST = {
    "Kur'an'ın metin, belagat ve korunma mucizeleri":           '_mMetin',
    "Astronomi ve kozmoloji mucizeleri":                         '_mAstro',
    "Fizik, kimya ve element mucizeleri":                        '_mFizik',
    "Yerbilim, atmosfer, meteoroloji ve okyanus mucizeleri":     '_mYer',
    "Biyoloji, embriyoloji, tıp ve insan bedeni mucizeleri":     '_mBiyo',
    "Hayvanlar, bitkiler ve ekoloji mucizeleri":                 '_mCanli',
    "Matematiksel, istatistiksel ve şifre mucizeleri":           '_mMat',
    "Tarihsel, arkeolojik ve haber mucizeleri":                  '_mTarih',
    "Hadislerde gelecek haberleri ve sosyal-teknolojik işaretler": '_mHadis',
    "İbadet, hüküm, ahlak ve yaşam hikmetleri":                 '_mIbadet',
}

# Önerilen 12 kart — her kategoriden 1-2 tane, ilk benzersiz konu
RECOMMENDED_IDS = [
    'MUCIZE-0001', 'MUCIZE-0008', 'MUCIZE-0081',
    'MUCIZE-0111', 'MUCIZE-0191', 'MUCIZE-0241',
    'MUCIZE-0301', 'MUCIZE-0451', 'MUCIZE-0601',
    'MUCIZE-0681', 'MUCIZE-0771', 'MUCIZE-0941',
]

lines = [
    '// ignore_for_file: lines_longer_than_80_chars, prefer_single_quotes',
    "import '../models/mucize_model.dart';",
    '',
    '// ── Kategori sabitleri ───────────────────────────────────────────────────',
    "const String _mMetin   = 'Kur\\'an\\'ın metin, belagat ve korunma mucizeleri';",
    "const String _mAstro   = 'Astronomi ve kozmoloji mucizeleri';",
    "const String _mFizik   = 'Fizik, kimya ve element mucizeleri';",
    "const String _mYer     = 'Yerbilim, atmosfer, meteoroloji ve okyanus mucizeleri';",
    "const String _mBiyo    = 'Biyoloji, embriyoloji, tıp ve insan bedeni mucizeleri';",
    "const String _mCanli   = 'Hayvanlar, bitkiler ve ekoloji mucizeleri';",
    "const String _mMat     = 'Matematiksel, istatistiksel ve şifre mucizeleri';",
    "const String _mTarih   = 'Tarihsel, arkeolojik ve haber mucizeleri';",
    "const String _mHadis   = 'Hadislerde gelecek haberleri ve sosyal-teknolojik işaretler';",
    "const String _mIbadet  = 'İbadet, hüküm, ahlak ve yaşam hikmetleri';",
    '',
    'const List<String> allMucizeCategories = [',
    '  _mMetin, _mAstro, _mFizik, _mYer, _mBiyo,',
    '  _mCanli, _mMat, _mTarih, _mHadis, _mIbadet,',
    '];',
    '',
    'const List<Mucize> allMucizeler = [',
]

for i, card in enumerate(cards):
    new_id  = f'MUCIZE-{i+1:04d}'
    raw_cat = card.get('mainCategory', '')
    cat_c   = CAT_CONST.get(raw_cat, '_mMetin')

    # Strip ' — perspective' from title for clean display
    raw_title = card.get('title', '')
    clean_title = strip_perspective(raw_title)

    lines.append('  Mucize(')
    lines.append(f"    id: '{new_id}',")
    lines.append(f'    title: {ds(clean_title)},')
    lines.append(f'    mainCategory: {cat_c},')

    sc = card.get('subcategory', '')
    if sc: lines.append(f'    subcategory: {ds(sc)},')

    sr = card.get('sourceRef', '')
    if sr: lines.append(f'    sourceRef: {ds(sr)},')

    oe = card.get('originalExpression', '')
    if oe: lines.append(f'    originalExpression: {ds(oe)},')

    lines.append(f'    claim: {ds(card.get("claim",""))},')

    mt = card.get('miracleType', '')
    if mt: lines.append(f'    miracleType: {ds(mt)},')

    sc2 = card.get('strengthOrCaution', '')
    if sc2: lines.append(f'    strengthOrCaution: {ds(sc2)},')

    lines.append(f'    shortExplanation: {ds(card.get("shortExplanation",""))},')

    # Detailed explanation sub-object
    de = card.get('detailedExplanation', {})
    if de:
        da  = de.get('detayliAciklama', '')
        nvb = de.get('nedenVayBeDedirtiyor', '')
        kn  = de.get('kaynakNotu', '')
        ihn = de.get('ihtiyatNotu', '')
        if any([da, nvb, kn, ihn]):
            lines.append('    detailedExplanation: const MucizeDetailedExplanation(')
            if da:  lines.append(f'      detayliAciklama: {ds(da)},')
            if nvb: lines.append(f'      nedenVayBeDedirtiyor: {ds(nvb)},')
            if kn:  lines.append(f'      kaynakNotu: {ds(kn)},')
            if ihn: lines.append(f'      ihtiyatNotu: {ds(ihn)},')
            lines.append('    ),')

    tags = card.get('tags', [])
    if isinstance(tags, str):
        tags = [t.strip() for t in tags.split() if t.strip()]
    if tags:
        lines.append(f'    tags: [{", ".join(ds(t) for t in tags[:6])}],')

    srcs = card.get('sources', [])
    if isinstance(srcs, str):
        srcs = srcs.split()
    if srcs:
        lines.append(f'    sources: [{", ".join(ds(s) for s in srcs[:4])}],')

    lines.append('  ),')

lines += [
    '];',
    '',
    '// ── Yardımcı fonksiyonlar ────────────────────────────────────────────────',
    'List<Mucize> getMucizeByCategory(String cat) =>',
    '    allMucizeler.where((m) => m.mainCategory == cat).toList();',
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
