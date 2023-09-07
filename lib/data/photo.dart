import 'dart:convert';

class Photo {
  final String name;
  final String description;
  final bool isPrivate;
  final String username;
  final String slug;
  final String fileId;
  final String userId;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> permissions;
  final String collectionId;
  final String databaseId;

  Photo({
    required this.name,
    required this.description,
    required this.isPrivate,
    required this.username,
    required this.slug,
    required this.fileId,
    required this.userId,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.permissions,
    required this.collectionId,
    required this.databaseId,
  });

  Photo copyWith({
    String? name,
    String? description,
    bool? isPrivate,
    String? username,
    String? slug,
    String? fileId,
    String? userId,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? permissions,
    String? collectionId,
    String? databaseId,
  }) =>
      Photo(
        name: name ?? this.name,
        description: description ?? this.description,
        isPrivate: isPrivate ?? this.isPrivate,
        username: username ?? this.username,
        slug: slug ?? this.slug,
        fileId: fileId ?? this.fileId,
        userId: userId ?? this.userId,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        permissions: permissions ?? this.permissions,
        collectionId: collectionId ?? this.collectionId,
        databaseId: databaseId ?? this.databaseId,
      );

  factory Photo.fromJson(String str) => Photo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Photo.fromMap(Map<String, dynamic> json) => Photo(
        name: json['name'],
        description: json['description'],
        isPrivate: json['isPrivate'],
        username: json['username'],
        slug: json['slug'],
        fileId: json['fileId'],
        userId: json['userId'],
        id: json['\u0024id'],
        createdAt: DateTime.parse(json['\u0024createdAt']),
        updatedAt: DateTime.parse(json['\u0024updatedAt']),
        permissions: List<String>.from(json['\u0024permissions'].map((x) => x)),
        collectionId: json['\u0024collectionId'],
        databaseId: json['\u0024databaseId'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'isPrivate': isPrivate,
        'username': username,
        'slug': slug,
        'fileId': fileId,
        'userId': userId,
        '\u0024id': id,
        '\u0024createdAt': createdAt.toIso8601String(),
        '\u0024updatedAt': updatedAt.toIso8601String(),
        '\u0024permissions': List<dynamic>.from(permissions.map((x) => x)),
        '\u0024collectionId': collectionId,
        '\u0024databaseId': databaseId,
      };
}
