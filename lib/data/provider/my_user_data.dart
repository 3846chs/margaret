import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:margaret/firebase/storage_provider.dart';
import 'package:margaret/utils/simple_snack_bar.dart';

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

  Future<void> setPushToken(String token) async {
    await _userData.reference.updateData({
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

  Future<void> signOutUser() async {
    _status = MyUserDataStatus.none;
    _userStreamsubscription?.cancel();
    await setPushToken("");
    await _auth.signOut();
    _userData = null;
    notifyListeners();
  }

  Future<void> withdrawUser() async {
    _status = MyUserDataStatus.none;
    _userStreamsubscription?.cancel();
    _userData.profiles.forEach((profile) async {
      if (profile != "deleted")
        await storageProvider.deleteFile("profiles/$profile");
    });

    String _userGender = _userData.gender == '남성' ? 'boy' : 'girl';
    _firestore
        .collection(COLLECTION_STATISTICS)
        .document('statistics')
        .updateData({_userGender: FieldValue.increment(-1)});

    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');

    _firestore
        .collection(TODAYQUESTIONS)
        .document(formatter.format(now))
        .updateData({
      'unmatchedList': FieldValue.arrayRemove([_userData.userKey]),
    });
    final deleteUserCallable = CloudFunctions(region: "asia-northeast1")
        .getHttpsCallable(functionName: "deleteUser");
    await deleteUserCallable.call(<String, dynamic>{
      "id": _userData.userKey,
    });
    await _userData.reference.delete();
    _userData = null;
    notifyListeners();

  }
}

enum MyUserDataStatus { progress, none, exist }
