import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/firestore/firestore_provider.dart';
import 'package:datingapp/home.dart';
import 'package:datingapp/pages/auth_page.dart';
import 'package:datingapp/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/auth_main.dart';

void main() => runApp(ChangeNotifierProvider<MyUserData>(
    create: (context) => MyUserData(), child: OurApp()));

class OurApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 우측상단에 debug 라는 빨간색 띠 없애기
      home: Consumer<MyUserData>(
        builder: (context, myUserData, child) {
          switch (myUserData.status) {
            case MyUserDataStatus.progress:
              FirebaseAuth.instance.currentUser().then((firebaseUser) {
                if (firebaseUser == null)
                  myUserData.setNewStatus(MyUserDataStatus.none);
                else {
                  print(firebaseUser.uid);
                  firestoreProvider
                      .connectMyUserData(firebaseUser.uid)
                      .listen((user) {
                    if (myUserData.data != null &&
                        myUserData.data.userKey != user.userKey) return;
                    print('listen called');
                    myUserData.setUserData(user);
                  });
                }
              });
              return LoadingPage();
            case MyUserDataStatus.exist:
              return Home();
            default:
              return AuthMain();
          }
        },
      ),
    );
  }
}
