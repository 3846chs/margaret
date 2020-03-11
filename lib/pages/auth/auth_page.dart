import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/pages/auth/email/email_auth.dart';
import 'package:margaret/pages/auth/phonenum_auth.dart';
import 'package:margaret/pages/auth/profile_input_page.dart';
import 'package:margaret/utils/adjust_size.dart';
import 'package:margaret/utils/simple_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:margaret/widgets/auth/login_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class AuthPage extends StatelessWidget {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  final _cloudFunctions = CloudFunctions(region: "asia-northeast1");

  final _googleSignIn = GoogleSignIn();
  final _kakaoSignIn = FlutterKakaoLogin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/temp9.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Builder(
          builder: (context) => _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: screenAwareHeight(100, context)),
            Text(
              'Margaret',
              style: const TextStyle(
                fontFamily: FontFamily.handlee,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '                         True Love ',
              style: const TextStyle(
                fontFamily: 'pacifico',
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.pinkAccent,
              ),
            ),
            SizedBox(height: screenAwareHeight(90, context)),
            LoginButton(
              text: "Google  로그인",
              icon: FontAwesomeIcons.google,
              color: Colors.red[600],
              onPressed: () => _signInGoogle(context),
            ),
            SizedBox(height: screenAwareHeight(5.0, context)),
            LoginButton(
              text: "Kakao  로그인",
              icon: IconData(75),
              color: Colors.yellow[700],
              onPressed: () => _signInKakao(context),
            ),
            SizedBox(height: screenAwareHeight(5.0, context)),
            LoginButton(
              text: "Naver  로그인",
              icon: FontAwesomeIcons.facebookF,
              color: Colors.green,
              onPressed: () => _signInNaver(context),
            ),
            SizedBox(height: screenAwareHeight(5.0, context)),
            LoginButton(
              text: "Apple  로그인",
              icon: FontAwesomeIcons.facebookF,
              color: Colors.black,
              onPressed: () => null,
            ),
            SizedBox(height: screenAwareHeight(5.0, context)),
            LoginButton(
              text: "전화번호  로그인",
              icon: FontAwesomeIcons.phone,
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PhonenumAuth()));
              },
            ),
            SizedBox(height: screenAwareHeight(5.0, context)),
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
    );
  }

  Future<void> _postAuthResult(
      BuildContext context, AuthResult authResult) async {
    final user = authResult.user;

    if (user == null) {
      simpleSnackbar(context, '존재하지 않는 계정입니다');
      return;
    }

    print("signed in " + user.displayName);

    final snapShot =
        await _firestore.collection(COLLECTION_USERS).document(user.uid).get();

    if (snapShot == null || !snapShot.exists) {
      // 해당 snapshot 이 존재하지 않을 때
      print('Not yet Registered - Profile Input Page');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileInputPage(authResult: authResult)));
    } else {
      Provider.of<MyUserData>(context, listen: false).update();
    }
  }

  Future<void> _signInGoogle(BuildContext context) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final authResult = await _auth.signInWithCredential(credential);

      _postAuthResult(context, authResult);

//    if (authResult.additionalUserInfo.isNewUser) {
//      print('new user');
//    } else {
//      print('old user');
//    }
    } on PlatformException catch (exception) {
      print(exception.code);
      simpleSnackbar(context, exception.message);
    }
  }

  Future<void> _signInKakao(BuildContext context) async {
    try {
      final result = await _kakaoSignIn.logIn();

      if (result.status == KakaoLoginStatus.error) {
        simpleSnackbar(context, result.errorMessage);
        return;
      }

      if (result.status == KakaoLoginStatus.loggedIn) {
        final createTokenCallable =
            _cloudFunctions.getHttpsCallable(functionName: "createToken");
        final response = await createTokenCallable.call(<String, dynamic>{
          "id": "kakao:${result.account.userID}",
          "email": result.account.userEmail,
        });

        final authResult = await _auth.signInWithCustomToken(
            token: response.data["firebaseToken"]);
        _postAuthResult(context, authResult);
      }
    } on PlatformException catch (exception) {
      print(exception.code);
      simpleSnackbar(context, exception.message);
    }
  }

  Future<void> _signInNaver(BuildContext context) async {
    try {
      final result = await FlutterNaverLogin.logIn();

      if (result.status == NaverLoginStatus.error) {
        simpleSnackbar(context, result.errorMessage);
        return;
      }

      if (result.status == NaverLoginStatus.loggedIn) {
        final createTokenCallable =
            _cloudFunctions.getHttpsCallable(functionName: "createToken");
        final response = await createTokenCallable.call(<String, dynamic>{
          "id": "naver:${result.account.id}",
          "email": result.account.email,
        });

        final authResult = await _auth.signInWithCustomToken(
            token: response.data["firebaseToken"]);
        _postAuthResult(context, authResult);
      }
    } on PlatformException catch (exception) {
      print(exception.code);
      simpleSnackbar(context, exception.message);
    }
  }
}
