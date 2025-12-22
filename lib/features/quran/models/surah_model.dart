class Surah {
  final int number;
  final String arabicName;
  final String englishName;
  final String meaning;
  final int ayahCount;

  Surah({
    required this.number,
    required this.arabicName,
    required this.englishName,
    required this.ayahCount,
     required this.meaning
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'],
      arabicName: json['name'],
      englishName: json['englishName'],
      meaning: json['englishNameTranslation'],
      ayahCount: json['numberOfAyahs'],
    );
  }
}
