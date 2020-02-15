import 'dart:async';

import 'package:datingapp/data/user.dart';
import 'package:datingapp/firebase/firestore_provider.dart';
import 'package:flutter/foundation.dart';

class MyUserData extends ChangeNotifier {
  StreamSubscription<User> _userStreamsubscription;

  User _userData;

  User get userData => _userData;

  MyUserDataStatus _myUserDataStatus = MyUserDataStatus.progress;

  MyUserDataStatus get status => _myUserDataStatus;

  void setNewStatus(MyUserDataStatus status) {
    _myUserDataStatus = status;
    notifyListeners();
  }

  void setUserData(String uid) {
    _userStreamsubscription?.cancel();
    _userStreamsubscription =
        firestoreProvider.connectMyUserData(uid).listen((user) {
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
