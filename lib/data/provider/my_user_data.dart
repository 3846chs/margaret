import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:flutter/foundation.dart';

class MyUserData extends ChangeNotifier {
  StreamSubscription<User> _userStreamsubscription;

  User _userData;
  User get userData => _userData;

  MyUserDataStatus _status = MyUserDataStatus.progress;
  MyUserDataStatus get status => _status;

  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  MyUserData() {
    update();
  }

  Future<void> update() async {
    if (_status != MyUserDataStatus.progress) {
      _status = MyUserDataStatus.progress;
      notifyListeners();
    }

    final firebaseUser = await _auth.currentUser();

    if (firebaseUser == null) {
      _status = MyUserDataStatus.none;
    } else {
      print(firebaseUser.uid);
      final snapShot = await _firestore
          .collection(COLLECTION_USERS)
          .document(firebaseUser.uid)
          .get();
      if (snapShot == null || !snapShot.exists) {
        // 해당 snapshot 이 존재하지 않을 때
        print('Not yet Registered - Auth Page');
        _status = MyUserDataStatus.none;
      } else {
        setUserData(firebaseUser.uid);
      }
    }

    notifyListeners();
  }

  void setPushToken(String token) {
    firestoreProvider.updateUser(_userData.userKey, {
      UserKeys.KEY_PUSHTOKEN: token,
    });
  }

  void setUserData(String uid) {
    _userStreamsubscription?.cancel();
    _userStreamsubscription = firestoreProvider.connectUser(uid).listen((user) {
      print('listen called');
      _userData = user;
      _status = MyUserDataStatus.exist;
      print('setUserData completed.');
      notifyListeners();
    });
  }

  void clearUser() {
    _userData = null;
    _status = MyUserDataStatus.none;
    _userStreamsubscription?.cancel();
    notifyListeners();
  }
}

enum MyUserDataStatus { progress, none, exist }
