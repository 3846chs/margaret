import 'dart:async';

import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:flutter/foundation.dart';

class MyUserData extends ChangeNotifier {
  StreamSubscription<User> _userStreamsubscription;

  User _userData;

  User get userData => _userData;

  MyUserDataStatus _myUserDataStatus = MyUserDataStatus.progress;

  MyUserDataStatus get status => _myUserDataStatus;

  void setPushToken(String token) {
    firestoreProvider.updateUser(_userData.userKey, {
      UserKeys.KEY_PUSHTOKEN: token,
    });
  }

  void setNewStatus(MyUserDataStatus status) {
    _myUserDataStatus = status;
    notifyListeners();
  }

  void setUserData(String uid) {
    _userStreamsubscription?.cancel();
    _userStreamsubscription = firestoreProvider.connectUser(uid).listen((user) {
      print('listen called');
      _userData = user;
      _myUserDataStatus = MyUserDataStatus.exist;
      print('setUserData completed.');
      notifyListeners();
    });
  }

  void clearUser() {
    _userData = null;
    _myUserDataStatus = MyUserDataStatus.none;
    _userStreamsubscription?.cancel();
    notifyListeners();
  }
}

enum MyUserDataStatus { progress, none, exist }
