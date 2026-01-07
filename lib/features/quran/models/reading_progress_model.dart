class ReadingProgress {
  final String userId;
  final int pageNumber;
  final int surahNumber;
  final int ayahNumber;
  final int juzNumber;
  final DateTime lastReadAt;

  ReadingProgress({
    required this.userId,
    required this.pageNumber,
    required this.surahNumber,
    required this.ayahNumber,
    required this.juzNumber,
    required this.lastReadAt,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'pageNumber': pageNumber,
    'surahNumber': surahNumber,
    'ayahNumber': ayahNumber,
    'juzNumber': juzNumber,
    'lastReadAt': lastReadAt.toIso8601String(),
  };

  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    return ReadingProgress(
      userId: json['userId'] ?? '',
      pageNumber: json['pageNumber'] ?? 1,
      surahNumber: json['surahNumber'] ?? 1,
      ayahNumber: json['ayahNumber'] ?? 1,
      juzNumber: json['juzNumber'] ?? 1,
      lastReadAt: DateTime.parse(
        json['lastReadAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
