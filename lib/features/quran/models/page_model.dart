// Add Page model to represent Quran pages (604 total)
import 'package:sukun/features/quran/models/surahs_model.dart';

class AyahData {
  final int ayahNumber; // Global ayah number (1-6236)
  final int ayahNumberInSurah; // Ayah number within the surah
  final String text; // Arabic text
  final int surahNumber;
  final String surahName;
  final int pageNumber;
  final int juzNumber;

  AyahData({
    required this.ayahNumber,
    required this.ayahNumberInSurah,
    required this.text,
    required this.surahNumber,
    required this.surahName,
    required this.pageNumber,
    required this.juzNumber,
  });

  factory AyahData.fromJson(Map<String, dynamic> json) {
    return AyahData(
      ayahNumber: json['number'] ?? 0,
      ayahNumberInSurah: json['numberInSurah'] ?? 0,
      text: json['text'] ?? '',
      surahNumber: json['surah']['number'] ?? 0,
      surahName: json['surah']['name'] ?? '',
      pageNumber: json['page'] ?? 0,
      juzNumber: json['juz'] ?? 0,
    );
  }
}

class QuranPage {
  final int pageNumber;
  final List<AyahData> ayahs;
  final int juzNumber;
  final String surahRange; // "Surah 2-3" format
  final bool shouldShowBismillah;

  QuranPage({
    required this.pageNumber,
    required this.ayahs,
    required this.juzNumber,
    required this.surahRange,
    required this.shouldShowBismillah,
  });

  factory QuranPage.fromAyahs({
    required int pageNumber,
    required List<Ayah> ayahs,
    required int juzNumber,
    required List<Chapter> allSurahs,
  }) {
    // Convert Ayah to AyahData
    final ayahDataList = ayahs.map((ayah) {
      final surah = allSurahs.firstWhere(
        (s) => s.id == ayah.chapterId,
        orElse: () => Chapter(
          id: ayah.chapterId,
          revelationPlace: RevelationPlace.makkah,
          revelationOrder: 0,
          bismillahPre: false,
          nameSimple: 'Unknown',
          nameComplex: 'Unknown',
          nameArabic: 'Unknown',
          versesCount: 0,
          pages: [],
          translatedName: TranslatedName(
            languageName: LanguageName.english,
            name: 'Unknown',
          ),
          verses: [],
        ),
      );

      return AyahData(
        ayahNumber: ayah.id,
        ayahNumberInSurah: ayah.verseNumber,
        text: ayah.text,
        surahNumber: ayah.chapterId,
        surahName: surah.nameSimple,
        pageNumber: pageNumber,
        juzNumber: juzNumber,
      );
    }).toList();

    // Determine surah range
    String surahRange = '';
    if (ayahDataList.isNotEmpty) {
      final firstSurah = ayahDataList.first.surahName;
      final lastSurah = ayahDataList.last.surahName;
      surahRange = firstSurah == lastSurah
          ? 'Surah $firstSurah'
          : 'Surah $firstSurah - $lastSurah';
    }

    // Check if should show Bismillah
    bool shouldShowBismillah = false;
    if (ayahDataList.isNotEmpty) {
      final firstAyah = ayahDataList.first;
      shouldShowBismillah =
          firstAyah.ayahNumberInSurah == 1 && firstAyah.surahNumber != 9;
    }

    return QuranPage(
      pageNumber: pageNumber,
      juzNumber: juzNumber,
      surahRange: surahRange,
      ayahs: ayahDataList,
      shouldShowBismillah: shouldShowBismillah,
    );
  }
}
