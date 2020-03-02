import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:margaret/constants/material_white_color.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/home.dart';
import 'package:margaret/pages/auth/auth_main.dart';
import 'package:margaret/pages/loading_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider<MyUserData>(
    create: (context) => MyUserData(), child: OurApp()));

class OurApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            PermissionHandler().requestPermissions([PermissionGroup.storage]),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return Material(
              child: Center(
                child: const CircularProgressIndicator(),
              ),
            );
          return MaterialApp(
            debugShowCheckedModeBanner: false, // 우측상단에 debug 라는 빨간색 띠 없애기
            title: "마가렛",
            home: Consumer<MyUserData>(
              builder: (context, myUserData, child) {
                switch (myUserData.status) {
                  case MyUserDataStatus.progress:
                    FirebaseAuth.instance
                        .currentUser()
                        .then((firebaseUser) async {
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
        });
  }
}
