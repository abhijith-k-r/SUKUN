import 'dart:convert';

class SukunNews {
    final bool success;
    final int count;
    final List<Datum> data;

    SukunNews({
        required this.success,
        required this.count,
        required this.data,
    });

    SukunNews copyWith({
        bool? success,
        int? count,
        List<Datum>? data,
    }) => 
        SukunNews(
            success: success ?? this.success,
            count: count ?? this.count,
            data: data ?? this.data,
        );

    factory SukunNews.fromRawJson(String str) => SukunNews.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SukunNews.fromJson(Map<String, dynamic> json) => SukunNews(
        success: json["success"],
        count: json["count"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    final String id;
    final String title;
    final String description;
    final Image image;
    final String readMoreUrl;
    final DateTime createdAt;
    final DateTime updatedAt;
    final Category category;
    final Source source;

    Datum({
        required this.id,
        required this.title,
        required this.description,
        required this.image,
        required this.readMoreUrl,
        required this.createdAt,
        required this.updatedAt,
        required this.category,
        required this.source,
    });

    Datum copyWith({
        String? id,
        String? title,
        String? description,
        Image? image,
        String? readMoreUrl,
        DateTime? createdAt,
        DateTime? updatedAt,
        Category? category,
        Source? source,
    }) => 
        Datum(
            id: id ?? this.id,
            title: title ?? this.title,
            description: description ?? this.description,
            image: image ?? this.image,
            readMoreUrl: readMoreUrl ?? this.readMoreUrl,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            category: category ?? this.category,
            source: source ?? this.source,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        image: Image.fromJson(json["image"]),
        readMoreUrl: json["readMoreUrl"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        category: Category.fromJson(json["category"]),
        source: Source.fromJson(json["source"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "image": image.toJson(),
        "readMoreUrl": readMoreUrl,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "category": category.toJson(),
        "source": source.toJson(),
    };
}

class Category {
    final String categoryId;
    final String name;

    Category({
        required this.categoryId,
        required this.name,
    });

    Category copyWith({
        String? categoryId,
        String? name,
    }) => 
        Category(
            categoryId: categoryId ?? this.categoryId,
            name: name ?? this.name,
        );

    factory Category.fromRawJson(String str) => Category.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["categoryId"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "name": name,
    };
}

class Image {
    final String publicId;
    final String url;

    Image({
        required this.publicId,
        required this.url,
    });

    Image copyWith({
        String? publicId,
        String? url,
    }) => 
        Image(
            publicId: publicId ?? this.publicId,
            url: url ?? this.url,
        );

    factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Image.fromJson(Map<String, dynamic> json) => Image(
        publicId: json["public_id"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "public_id": publicId,
        "url": url,
    };
}

class Source {
    final String sourceId;
    final String name;

    Source({
        required this.sourceId,
        required this.name,
    });

    Source copyWith({
        String? sourceId,
        String? name,
    }) => 
        Source(
            sourceId: sourceId ?? this.sourceId,
            name: name ?? this.name,
        );

    factory Source.fromRawJson(String str) => Source.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Source.fromJson(Map<String, dynamic> json) => Source(
        sourceId: json["sourceId"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "sourceId": sourceId,
        "name": name,
    };
}
