import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

import '/data/photo.dart';
import '/constants.dart';
import 'auth.dart';

class Photos extends ChangeNotifier {
  final Databases _databases;
  List<Photo> _photos = [];
  final Auth auth;

  Photos({required Client client, required this.auth})
      : _databases = Databases(client);

  List<Photo> get photos => _photos;

  Future<void> init() async {
    try {
      final documentList = await _databases.listDocuments(
        databaseId: Appwrite.database,
        collectionId: Appwrite.collectionPhotos,
        queries: [
          Query.equal('userId', auth.user!.$id),
        ],
      );

      _photos = documentList.documents
          .map<Photo>((document) => Photo.fromMap(document.data))
          .toList();

      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
