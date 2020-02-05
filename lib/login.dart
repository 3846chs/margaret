
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


class LoginPage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // 구글 로그인을 위한 객체
  final FirebaseAuth _auth = FirebaseAuth.instance; // 파이어베이스 인증 정보를 가지는 객체

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(50.0),
            ),
            SignInButton(
              Buttons.Google,
              onPressed: () async {
                final FirebaseUser user = await _handleSignIn(context);
                print(user);
                print(user.uid);
                print(user.email);
                print(user.displayName);




//                await firestoreProvider.attemptCreateUser(userKey: user.uid);
//                Provider.of<MyUserData>(context).setNewStatus(MyUserDataStatus.progress);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> _handleSignIn(BuildContext context) async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    FirebaseUser user = (await _auth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken)))
        .user;

    print("signed in " + user.displayName);
//    Provider.of<MyUserData>(context, listen: false)
//        .setNewStatus(MyUserDataStatus.progress); // 코딩파파는 MyUserDataStatus.progess 로 했음.

    return user;
  }
}
