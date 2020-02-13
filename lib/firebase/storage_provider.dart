import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageProvider {
  final FirebaseStorage _firebaseStorage = FirebaseStorage();

  Future<String> uploadImg(File image, String path) async {
    final StorageReference storageReference =
        _firebaseStorage.ref().child(path);
    final StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    return path;
  }

  Future<String> getImageUri(String path) async {
    return (await _firebaseStorage.ref().child(path).getDownloadURL())
        .toString();
  }
}

final StorageProvider storageProvider = StorageProvider();
