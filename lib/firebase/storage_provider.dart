import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageProvider {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> deleteFile(String path) async {
    final storageReference = _firebaseStorage.ref();
    return storageReference.child(path).delete();
  }

  Future<String> uploadFile(File file, String path) async {
    final storageReference = _firebaseStorage.ref();
    await storageReference.child(path).putFile(file).onComplete;
    return path;
  }

  Future<String> getFileURL(String path) async {
    final storageReference = _firebaseStorage.ref();
    try {
      String url = await storageReference.child(path).getDownloadURL();
      return url;
    } catch (exception) {
      return null;
    }
  }
}

final StorageProvider storageProvider = StorageProvider();
