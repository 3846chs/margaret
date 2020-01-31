import 'package:dating_app/login.dart';
import 'package:dating_app/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('root_page created');
    return _handleCurrentScreen();
  }

  Widget _handleCurrentScreen() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return LoadingPage();
        } else {
          // 연결되었고, 데이터가 있다면
          if(snapshot.hasData){
            return DatingHome();
          }
          return LoginPage();
        }
      },
    );
  }
}
