import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '/constants.dart';
import '/data/photo.dart';
import 'auth.dart';

class Photos extends ChangeNotifier {
  final Databases _databases;
  final Storage _storage;
  List<Photo> _photos = [];
  final Auth auth;
  XFile? newPhoto;

  Photos({required Client client, required this.auth})
      : _databases = Databases(client),
        _storage = Storage(client);

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
      debugPrint(e.toString());
      rethrow;
    }
  }

  void setNewPhoto(XFile photo) {
    newPhoto = photo;
    notifyListeners();
  }

  Future<void> upload(String name, String description) async {
    if (newPhoto == null) {
      throw Exception('Please select a photo');
    }

    // create the file in the storage bucket
    final file = await _storage.createFile(
      bucketId: Appwrite.bucket,
      fileId: ID.unique(),
      file: InputFile.fromPath(path: newPhoto!.path),
    );

    // create the document in photos collection
    final photo = Photo(
      id: ID.unique(),
      name: name,
      fileId: file.$id,
      description: description,
      isPrivate: false,
      slug: name.toLowerCase().replaceAll(' ', '_'),
      userId: auth.user!.$id,
      username: auth.user!.name,
    );
    await _databases.createDocument(
      databaseId: Appwrite.database,
      collectionId: Appwrite.collectionPhotos,
      documentId: photo.id,
      data: photo.toData(),
    );
    return init();
  }

  Future<void> delete(Photo photo) async {
    final futures = <Future>[];
    futures.add(_storage.deleteFile(
      bucketId: Appwrite.bucket,
      fileId: photo.fileId,
    ));
    futures.add(_databases.deleteDocument(
      databaseId: Appwrite.database,
      collectionId: Appwrite.collectionPhotos,
      documentId: photo.id,
    ));

    await Future.wait(futures);
    return init();
  }
}
