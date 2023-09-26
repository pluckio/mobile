import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

import '/constants.dart';
import '/data/like.dart';
import '/data/photo.dart';
import 'auth.dart';

class Likes extends ChangeNotifier {
  final Databases _databases;
  final Auth auth;
  final Map<String, Map<String, Like>> _likesByPhoto = {};

  Likes({required Client client, required this.auth})
      : _databases = Databases(client);

  Future<void> getLikes(Photo photo) async {
    try {
      final documentList = await _databases.listDocuments(
        databaseId: Appwrite.database,
        collectionId: Appwrite.collectionLikes,
        queries: [
          Query.equal('photoId', photo.id),
        ],
      );

      for (final document in documentList.documents) {
        final like = Like.fromMap(document.data);

        if (_likesByPhoto[photo.id] == null) {
          _likesByPhoto[photo.id] = {};
        }

        _likesByPhoto[photo.id]?[like.id] = like;
      }

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> likePhoto(Photo photo) async {
    // create the document in likes collection
    final like = Like(
      id: ID.unique(),
      userId: auth.user!.$id,
      photoId: photo.id,
    );
    await _databases.createDocument(
      databaseId: Appwrite.database,
      collectionId: Appwrite.collectionLikes,
      documentId: like.id,
      data: like.toData(),
    );
    return getLikes(photo);
  }
}
