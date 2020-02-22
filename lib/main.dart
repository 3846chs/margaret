import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/material_white_color.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/home.dart';
import 'package:datingapp/widgets/loading_page.dart';
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
              FirebaseAuth.instance.currentUser().then((firebaseUser) async {
                if (firebaseUser == null)
                  myUserData.setNewStatus(MyUserDataStatus.none);
                else {
                  print(firebaseUser.uid);
                  final snapShot = await Firestore.instance
                      .collection('Users')
                      .document(firebaseUser.uid)
                      .get();
                  if (snapShot == null || !snapShot.exists) {
                    // 해당 snapshot 이 존재하지 않을 때
                    print('Not yet Registered - Auth Page');
                    myUserData.setNewStatus(MyUserDataStatus.none);
                  } else {
                    myUserData.setUserData(firebaseUser.uid);
                  }
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
      theme: ThemeData(primarySwatch: white),
    );
  }
}
