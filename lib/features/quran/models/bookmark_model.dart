class Bookmark {
  final String id;
  final String userId;
  final int ayahNumber;
  final int ayahNumberInSurah;
  final int surahNumber;
  final String surahName;
  final int pageNumber;
  final int juzNumber;
  final String ayahText;
  final DateTime createdAt;

  Bookmark({
    required this.id,
    required this.userId,
    required this.ayahNumber,
    required this.ayahNumberInSurah,
    required this.surahNumber,
    required this.surahName,
    required this.pageNumber,
    required this.juzNumber,
    required this.ayahText,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'ayahNumber': ayahNumber,
    'ayahNumberInSurah': ayahNumberInSurah,
    'surahNumber': surahNumber,
    'surahName': surahName,
    'pageNumber': pageNumber,
    'juzNumber': juzNumber,
    'ayahText': ayahText,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      ayahNumber: json['ayahNumber'] ?? 0,
      ayahNumberInSurah: json['ayahNumberInSurah'] ?? 0,
      surahNumber: json['surahNumber'] ?? 0,
      surahName: json['surahName'] ?? '',
      pageNumber: json['pageNumber'] ?? 0,
      juzNumber: json['juzNumber'] ?? 0,
      ayahText: json['ayahText'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
