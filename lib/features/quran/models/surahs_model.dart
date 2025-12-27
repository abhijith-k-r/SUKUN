import 'dart:convert';

import 'package:flutter/widgets.dart';

class Surahs {
  final List<Chapter> chapters;

  Surahs({required this.chapters});

  Surahs copyWith({List<Chapter>? chapters}) =>
      Surahs(chapters: chapters ?? this.chapters);

  factory Surahs.fromRawJson(String str) => Surahs.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Surahs.fromJson(Map<String, dynamic> json) => Surahs(
    chapters: List<Chapter>.from(
      json["chapters"].map((x) => Chapter.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "chapters": List<dynamic>.from(chapters.map((x) => x.toJson())),
  };
}

class Chapter {
  final int id;
  final RevelationPlace revelationPlace;
  final int revelationOrder;
  final bool bismillahPre;
  final String nameSimple;
  final String nameComplex;
  final String nameArabic;
  final int versesCount;
  final List<int> pages;
  final TranslatedName translatedName;
  final List<Ayah> verses;

  Chapter({
    required this.id,
    required this.revelationPlace,
    required this.revelationOrder,
    required this.bismillahPre,
    required this.nameSimple,
    required this.nameComplex,
    required this.nameArabic,
    required this.versesCount,
    required this.pages,
    required this.translatedName,
    this.verses = const [],
  });

  Chapter copyWith({
    int? id,
    RevelationPlace? revelationPlace,
    int? revelationOrder,
    bool? bismillahPre,
    String? nameSimple,
    String? nameComplex,
    String? nameArabic,
    int? versesCount,
    List<int>? pages,
    TranslatedName? translatedName,
    List<Ayah>? verses,
  }) => Chapter(
    id: id ?? this.id,
    revelationPlace: revelationPlace ?? this.revelationPlace,
    revelationOrder: revelationOrder ?? this.revelationOrder,
    bismillahPre: bismillahPre ?? this.bismillahPre,
    nameSimple: nameSimple ?? this.nameSimple,
    nameComplex: nameComplex ?? this.nameComplex,
    nameArabic: nameArabic ?? this.nameArabic,
    versesCount: versesCount ?? this.versesCount,
    pages: pages ?? this.pages,
    translatedName: translatedName ?? this.translatedName,
    verses: verses ?? this.verses,
  );

  factory Chapter.fromRawJson(String str) => Chapter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    id: json["id"],
    revelationPlace: revelationPlaceValues.map[json["revelation_place"]]!,
    revelationOrder: json["revelation_order"],
    bismillahPre: json["bismillah_pre"],
    nameSimple: json["name_simple"],
    nameComplex: json["name_complex"],
    nameArabic: json["name_arabic"],
    versesCount: json["verses_count"],
    pages: List<int>.from(json["pages"].map((x) => x)),
    translatedName: TranslatedName.fromJson(json["translated_name"]),
    verses: [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "revelation_place": revelationPlaceValues.reverse[revelationPlace],
    "revelation_order": revelationOrder,
    "bismillah_pre": bismillahPre,
    "name_simple": nameSimple,
    "name_complex": nameComplex,
    "name_arabic": nameArabic,
    "verses_count": versesCount,
    "pages": List<dynamic>.from(pages.map((x) => x)),
    "translated_name": translatedName.toJson(),
  };
}

enum RevelationPlace { madinah, makkah }

final revelationPlaceValues = EnumValues({
  "madinah": RevelationPlace.madinah,
  "makkah": RevelationPlace.makkah,
});

class TranslatedName {
  final LanguageName languageName;
  final String name;

  TranslatedName({required this.languageName, required this.name});

  TranslatedName copyWith({LanguageName? languageName, String? name}) =>
      TranslatedName(
        languageName: languageName ?? this.languageName,
        name: name ?? this.name,
      );

  factory TranslatedName.fromRawJson(String str) =>
      TranslatedName.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TranslatedName.fromJson(Map<String, dynamic> json) => TranslatedName(
    languageName: languageNameValues.map[json["language_name"]]!,
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "language_name": languageNameValues.reverse[languageName],
    "name": name,
  };
}

enum LanguageName { english }

final languageNameValues = EnumValues({"english": LanguageName.english});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class Ayah {
  final int id;
  final int verseNumber;
  final int chapterId;
  final String text;
  final String translation;

  Ayah({
    required this.id,
    required this.verseNumber,
    required this.chapterId,
    required this.text,
    required this.translation,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    // Get Arabic text - prefer text_uthmani if available, otherwise use words array
    String arabicText = "";

    // First try to get text_uthmani (proper Uthmani script)
    if (json["text_uthmani"] != null &&
        json["text_uthmani"].toString().isNotEmpty) {
      arabicText = json["text_uthmani"].toString();
    }
    // Fallback to words array if text_uthmani not available
    else if (json["words"] != null && (json["words"] as List).isNotEmpty) {
      // Join all word texts with spaces for proper rendering
      arabicText = (json["words"] as List)
          .map((word) => word["text"]?.toString().trim() ?? "")
          .where((text) => text.isNotEmpty)
          .join(" ");
    }

    // 🔥 FIXED: Get English from WORDS translations
    String englishTranslation = "";
    if (json["words"] != null && (json["words"] as List).isNotEmpty) {
      englishTranslation = (json["words"] as List)
          .map((word) => word["translation"]?["text"] ?? "")
          .join(" ");
    }

    debugPrint(
      '🔥 Ayah ${parseInt(json["verse_key"]?.toString().split(':').last)}: '
      'Arabic="${arabicText.length} chars", English="${englishTranslation.length} chars"',
    );

    return Ayah(
      id: parseInt(json["id"]),
      verseNumber: parseInt(
        json["verse_key"]?.toString().split(':').last ?? "1",
      ),
      chapterId: parseInt(json["chapter_id"] ?? 1),
      text: arabicText,
      translation: englishTranslation,
    );
  }
}
