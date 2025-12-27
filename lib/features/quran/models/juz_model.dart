import 'dart:convert';

class Juz {
  final List<JuzElement> juzs;

  Juz({required this.juzs});

  Juz copyWith({List<JuzElement>? juzs}) => Juz(juzs: juzs ?? this.juzs);

  factory Juz.fromRawJson(String str) => Juz.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Juz.fromJson(Map<String, dynamic> json) => Juz(
    juzs: List<JuzElement>.from(
      json["juzs"].map((x) => JuzElement.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "juzs": List<dynamic>.from(juzs.map((x) => x.toJson())),
  };
}

class JuzElement {
  final int id;
  final int juzNumber;
  final Map<String, String> verseMapping;
  final int firstVerseId;
  final int lastVerseId;
  final int versesCount;

  JuzElement({
    required this.id,
    required this.juzNumber,
    required this.verseMapping,
    required this.firstVerseId,
    required this.lastVerseId,
    required this.versesCount,
  });

  JuzElement copyWith({
    int? id,
    int? juzNumber,
    Map<String, String>? verseMapping,
    int? firstVerseId,
    int? lastVerseId,
    int? versesCount,
  }) => JuzElement(
    id: id ?? this.id,
    juzNumber: juzNumber ?? this.juzNumber,
    verseMapping: verseMapping ?? this.verseMapping,
    firstVerseId: firstVerseId ?? this.firstVerseId,
    lastVerseId: lastVerseId ?? this.lastVerseId,
    versesCount: versesCount ?? this.versesCount,
  );

  factory JuzElement.fromRawJson(String str) =>
      JuzElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JuzElement.fromJson(Map<String, dynamic> json) => JuzElement(
    id: json["id"],
    juzNumber: json["juz_number"],
    verseMapping: Map.from(
      json["verse_mapping"],
    ).map((k, v) => MapEntry<String, String>(k, v)),
    firstVerseId: json["first_verse_id"],
    lastVerseId: json["last_verse_id"],
    versesCount: json["verses_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "juz_number": juzNumber,
    "verse_mapping": Map.from(
      verseMapping,
    ).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "first_verse_id": firstVerseId,
    "last_verse_id": lastVerseId,
    "verses_count": versesCount,
  };
}
