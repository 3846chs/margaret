import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:margaret/auth/email/email_auth.dart';
import 'package:margaret/auth/profile_input_page.dart';
import 'package:margaret/auth/login_button.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/utils/base_height.dart';
import 'package:margaret/utils/simple_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class AuthMain extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // 구글 로그인을 위한 객체
  final FirebaseAuth _auth = FirebaseAuth.instance; // 파이어베이스 인증 정보를 가지는 객체

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/temp9.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: screenAwareSize(100, context),
                ),
                Text(
                  'Margaret',
                  style: GoogleFonts.handlee(
                      fontWeight: FontWeight.bold, fontSize: 50),
                ),
                Text(
                  '                         True Love ',
                  style: GoogleFonts.pacifico(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.pinkAccent),
                ),
                SizedBox(height: screenAwareSize(130, context)),
                LoginButton(
                  text: "Google  로그인",
                  icon: FontAwesomeIcons.google,
                  color: Colors.red[600],
                  onPressed: () {
                    _handleGoogleSignIn(context);
                  },
                ),
                SizedBox(height: screenAwareSize(5.0, context)),
                LoginButton(
                  text: "Kakao  로그인",
                  icon: IconData(75),
                  color: Colors.yellow[700],
                  onPressed: () => null,
                ),
                SizedBox(height: screenAwareSize(5.0, context)),
                LoginButton(
                  text: "Naver  로그인",
                  icon: FontAwesomeIcons.facebookF,
                  color: Colors.green,
                  onPressed: () => null,
                ),
                SizedBox(height: screenAwareSize(5.0, context)),
                LoginButton(
                  text: "Apple  로그인",
                  icon: FontAwesomeIcons.facebookF,
                  color: Colors.black,
                  onPressed: () => null,
                ),
                SizedBox(height: screenAwareSize(5.0, context)),
                LoginButton(
                  text: "E-mail  로그인",
                  icon: FontAwesomeIcons.solidEnvelope,
                  color: Colors.grey[300],
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EmailAuth()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      AuthResult authResult = (await _auth.signInWithCredential(
          GoogleAuthProvider.getCredential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken)));

//    if (authResult.additionalUserInfo.isNewUser) {
//      print('new user');
//    } else {
//      print('old user');
//    }
      FirebaseUser user = authResult.user;
      print("signed in " + user.displayName);
      final snapShot =
          await Firestore.instance.collection('Users').document(user.uid).get();

      if (snapShot == null || !snapShot.exists) {
        // 해당 snapshot 이 존재하지 않을 때
        print('Not yet Registered - Profile Input Page');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileInputPage(
                      authResult: authResult,
                    )));
      } else {
        if (user == null) {
          simpleSnackbar(context, '존재하지 않는 계정입니다');
        } else {
          Provider.of<MyUserData>(context, listen: false)
              .setNewStatus(MyUserDataStatus.progress);
        }
      }

      return user;
    } on PlatformException catch (exception) {
      print(exception.code);
      simpleSnackbar(context, exception.message);
    }
  }
}
