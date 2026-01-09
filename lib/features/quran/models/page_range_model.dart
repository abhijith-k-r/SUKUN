class PageRange {
  final int start;
  final int end;

  PageRange({required this.start, required this.end});
}


// Get page range for a Surah
PageRange getSurahPageRange(int surahId) {
  const surahPageStarts = [
    1,
    2,
    50,
    77,
    106,
    128,
    151,
    177,
    187,
    208,
    221,
    235,
    249,
    255,
    262,
    267,
    282,
    293,
    305,
    312,
    322,
    332,
    342,
    350,
    359,
    367,
    377,
    385,
    396,
    404,
    411,
    415,
    418,
    428,
    434,
    440,
    446,
    453,
    458,
    467,
    477,
    483,
    489,
    496,
    499,
    502,
    507,
    511,
    515,
    518,
    520,
    523,
    526,
    528,
    531,
    534,
    537,
    542,
    545,
    549,
    551,
    553,
    554,
    560,
    562,
    564,
    566,
    568,
    570,
    572,
    574,
    577,
    578,
    580,
    582,
    583,
    585,
    586,
    587,
    587,
    589,
    590,
    591,
    591,
    592,
    593,
    594,
    595,
    595,
    596,
    596,
    597,
    597,
    598,
    598,
    599,
    599,
    600,
    600,
    601,
    601,
    601,
    602,
    602,
    602,
    603,
    603,
    603,
    604,
    604,
    604,
  ];

  final start = surahPageStarts[surahId - 1];
  final end = surahId < 114 ? surahPageStarts[surahId] - 1 : 604;

  return PageRange(start: start, end: end);
}


// Get page range for a Juz
PageRange getJuzPageRange(int juzNumber) {
  const juzPageStarts = [
    1,
    22,
    42,
    60,
    82,
    102,
    121,
    142,
    162,
    182,
    201,
    222,
    242,
    262,
    282,
    302,
    322,
    342,
    362,
    382,
    402,
    422,
    442,
    462,
    482,
    502,
    522,
    542,
    562,
    582,
  ];

  final start = juzPageStarts[juzNumber - 1];
  final end = juzNumber < 30 ? juzPageStarts[juzNumber] - 1 : 604;

  return PageRange(start: start, end: end);
}


int getJuzFromPage(int pageNumber) {
  const juzPageStarts = [
    1,
    22,
    42,
    60,
    82,
    102,
    121,
    142,
    162,
    182,
    201,
    222,
    242,
    262,
    282,
    302,
    322,
    342,
    362,
    382,
    402,
    422,
    442,
    462,
    482,
    502,
    522,
    542,
    562,
    582,
  ];

  // Find which Juz contains this page
  for (int i = 0; i < juzPageStarts.length; i++) {
    final startPage = juzPageStarts[i];
    final endPage = (i < juzPageStarts.length - 1)
        ? juzPageStarts[i + 1] - 1
        : 604;

    if (pageNumber >= startPage && pageNumber <= endPage) {
      return i + 1; // Juz numbers are 1-indexed
    }
  }

  // Fallback to Juz 1 if not found
  return 1;
}
