class Mucize {
  final String id;
  final String title;
  final String category;
  final String subcategory;
  final String sourceRef;
  final String sourceTextShort;
  final String claim;
  final String miracleType;
  final String explanation;
  final String verificationNote;
  final List<String> tags;
  final List<String> sources;

  const Mucize({
    required this.id,
    required this.title,
    required this.category,
    required this.subcategory,
    this.sourceRef = '',
    this.sourceTextShort = '',
    required this.claim,
    this.miracleType = '',
    required this.explanation,
    this.verificationNote = '',
    this.tags = const [],
    this.sources = const [],
  });
}
