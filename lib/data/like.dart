import 'dart:convert';

import '/constants.dart';

class Like {
  final String photoId;
  final String userId;
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? permissions;
  final String collectionId;
  final String databaseId;

  Like({
    required this.photoId,
    required this.userId,
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.permissions,
    this.collectionId = Appwrite.collectionLikes,
    this.databaseId = Appwrite.database,
  });

  Like copyWith({
    String? photoId,
    String? userId,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? permissions,
    String? collectionId,
    String? databaseId,
  }) =>
      Like(
        photoId: photoId ?? this.photoId,
        userId: userId ?? this.userId,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        permissions: permissions ?? this.permissions,
        collectionId: collectionId ?? this.collectionId,
        databaseId: databaseId ?? this.databaseId,
      );

  factory Like.fromJson(String str) => Like.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Like.fromMap(Map<String, dynamic> json) => Like(
        photoId: json['photoId'],
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
      'photoId': photoId,
      'userId': userId,
    };

    return data;
  }
}
