import '../models/delil_model.dart';

const List<DelilSource> allSources = [
  DelilSource(
    code: 'SEP-KOZMOLOJIK',
    title: 'Stanford Encyclopedia of Philosophy: Cosmological Argument',
    url: 'https://plato.stanford.edu/entries/cosmological-argument/',
  ),
  DelilSource(
    code: 'SEP-TELEOLOJIK',
    title: 'Stanford Encyclopedia of Philosophy: Teleological Arguments for God\'s Existence',
    url: 'https://plato.stanford.edu/entries/teleological-arguments/',
  ),
  DelilSource(
    code: 'SEP-FINE-TUNING',
    title: 'Stanford Encyclopedia of Philosophy: Fine-Tuning',
    url: 'https://plato.stanford.edu/entries/fine-tuning/',
  ),
  DelilSource(
    code: 'SEP-AHLAK',
    title: 'Stanford Encyclopedia of Philosophy: Moral Arguments for God\'s Existence',
    url: 'https://plato.stanford.edu/entries/moral-arguments-god/',
  ),
  DelilSource(
    code: 'IEP-ONTOLOJIK',
    title: 'Internet Encyclopedia of Philosophy: Anselm\'s Ontological Argument',
    url: 'https://iep.utm.edu/anselm-ontological-argument/',
  ),
  DelilSource(
    code: 'ROUTLEDGE',
    title: 'Routledge Encyclopedia of Philosophy: God, Arguments for the Existence of',
    url: 'https://www.rep.routledge.com/articles/thematic/god-arguments-for-the-existence-of/v-1',
  ),
  DelilSource(
    code: 'TASLAMAN-12',
    title: 'Caner Taslaman: Allah\'ın Varlığının 12 Delili',
    url: 'https://www.canertaslaman.com/wp-content/uploads/2019/09/allahın-varlığının-12-delili.pdf',
  ),
  DelilSource(
    code: 'RIS-AKAID',
    title: 'Risale-i Nur\'da Allah\'ın Varlığı Bahisleri',
    url: 'https://www.yeniasya.com.tr/enstitu/allah-in-varligi-hakkinda-risale-i-nur-da-gecen-bahisler_127410',
  ),
  DelilSource(
    code: 'ISLAM-HUDUS',
    title: 'İhtira ve Hudus Delili Açıklaması',
    url: 'https://sorularlaislamiyet.com/allahin-varliginin-delili-icin-soylenen-ihtira-ve-hudus-delili-arasinda-fark-var-mi',
  ),
  DelilSource(
    code: 'YARAN-ISLAM',
    title: 'Cafer Sadık Yaran: Islamic Thought on the Existence of God',
    url: 'https://www.crvp.org/publications/Series-IIA/IIA-16-Contents.pdf',
  ),
  DelilSource(
    code: 'NASA-WMAP',
    title: 'NASA WMAP Overview',
    url: 'https://science.nasa.gov/mission/wmap/wmap-overview/',
  ),
  DelilSource(
    code: 'PLANCK-2018',
    title: 'Planck 2018 Results: Cosmological Parameters',
    url: 'https://arxiv.org/abs/1807.06209',
  ),
  DelilSource(
    code: 'BGV-2003',
    title: 'Borde, Guth, Vilenkin: Inflationary Spacetimes Are Incomplete in Past Directions',
    url: 'https://link.aps.org/doi/10.1103/PhysRevLett.90.151301',
  ),
];

DelilSource? findSource(String code) {
  try {
    return allSources.firstWhere((s) => s.code == code);
  } catch (_) {
    return null;
  }
}
