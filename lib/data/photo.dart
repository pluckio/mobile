import 'dart:convert';

import '/constants.dart';

class Photo {
  final String name;
  final String? description;
  final bool? isPrivate;
  final String username;
  final String slug;
  final String fileId;
  final String userId;
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? permissions;
  final String collectionId;
  final String databaseId;

  Photo({
    required this.name,
    this.description,
    this.isPrivate,
    required this.username,
    required this.slug,
    required this.fileId,
    required this.userId,
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.permissions,
    this.collectionId = Appwrite.collectionPhotos,
    this.databaseId = Appwrite.database,
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

  Map<String, dynamic> toMap() {
    final data = toData();

    data['\$id'] = id;
    if (createdAt != null) {
      data['\$createdAt'] = createdAt?.toIso8601String();
    }
    if (updatedAt != null) {
      data['\$updatedAt'] = updatedAt?.toIso8601String();
    }
    if (permissions != null) {
      data['\$permissions'] = List<String>.from(permissions!.map((x) => x));
    }
    data['\$databaseId'] = databaseId;
    data['\$collectionId'] = collectionId;

    return data;
  }

  Map<String, dynamic> toData() {
    final data = <String, dynamic>{
      'name': name,
      'username': username,
      'slug': slug,
      'fileId': fileId,
      'userId': userId,
    };

    if (description != null) {
      data['description'] = description;
    }
    if (isPrivate != null) {
      data['isPrivate'] = isPrivate;
    }
    return data;
  }
}
