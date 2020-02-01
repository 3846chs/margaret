import 'package:dating_app/home.dart';
import 'package:dating_app/login.dart';
import 'package:dating_app/widgets/loading.dart';
import 'package:dating_app/widgets/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

void main() => runApp(OurApp());

class OurApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 우측상단에 debug 라는 빨간색 띠 없애기
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return LoadingPage();
          } else {
            if(snapshot.hasData){
              return Home();
            }
            return UserProfile();
            // test
          }
        },
      ),
    );
  }
}
