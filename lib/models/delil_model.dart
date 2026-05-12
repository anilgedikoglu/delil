class Delil {
  final String id;
  final String category;
  final String subcategory;
  final String title;
  final String short;
  final String expanded;
  final List<String> tags;
  final String strength;
  final List<String> sources;
  final String objection;
  final String reply;

  const Delil({
    required this.id,
    required this.category,
    required this.subcategory,
    required this.title,
    required this.short,
    required this.expanded,
    required this.tags,
    required this.strength,
    required this.sources,
    this.objection = '',
    this.reply = '',
  });

  bool get hasObjectionReply => objection.isNotEmpty && reply.isNotEmpty;

  int get strengthLevel {
    switch (strength) {
      case 'yüksek':
        return 3;
      case 'orta-yüksek':
        return 2;
      case 'orta':
        return 1;
      default:
        return 0;
    }
  }
}

class DelilSource {
  final String code;
  final String title;
  final String url;

  const DelilSource({
    required this.code,
    required this.title,
    required this.url,
  });
}
