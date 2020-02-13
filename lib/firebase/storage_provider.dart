import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageProvider {
  final FirebaseStorage _firebaseStorage = FirebaseStorage();

  Future<dynamic> uploadImg(File image, String path) async {
    final StorageReference storageReference =
        _firebaseStorage.ref().child(path);
    final StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    return storageReference.getDownloadURL();
  }

  Future<dynamic> getImageUri(String path) {
    return _firebaseStorage.ref().child(path).getDownloadURL();
  }
}

final StorageProvider storageProvider = StorageProvider();
