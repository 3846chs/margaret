import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageProvider {
  final FirebaseStorage _firebaseStorage = FirebaseStorage();

  Future<void> deleteFile(String path) async {
    final storageReference = _firebaseStorage.ref().child(path);
    return storageReference.delete();
  }

  Future<String> uploadFile(File file, String path) async {
    final storageReference = _firebaseStorage.ref().child(path);
    await storageReference.putFile(file).onComplete;
    return path;
  }

  Future<String> getFileURL(String path) async {
    return (await _firebaseStorage.ref().child(path).getDownloadURL())
        .toString();
  }
}

final StorageProvider storageProvider = StorageProvider();
