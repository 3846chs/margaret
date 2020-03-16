import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/pages/auth/profile_input_page.dart';
import 'package:margaret/utils/adjust_size.dart';
import 'package:provider/provider.dart';

class PhonenumAuth extends StatefulWidget {
  @override
  _PhonenumAuthState createState() => _PhonenumAuthState();
}

class _PhonenumAuthState extends State<PhonenumAuth> {
  final _auth = FirebaseAuth.instance;
  final _smsCodeController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  String verificationId;
  String status = "";

  Future<void> _sendCodeToPhoneNumber() async {
    final phone = "+82${_phoneNumberController.text.substring(1)}";

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      setState(() {
        print('Code sent to $phone');
        status = "Enter the code sent to $phone";
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      setState(() {
        status = "Auto retrieval time out";
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        status = '${authException.message}';

        print("Error message: " + status);
        if (authException.message.contains('not authorized'))
          status = 'Something has gone wrong, please try later';
        else if (authException.message.contains('Network'))
          status = 'Please check your internet connection and try again';
        else
          status = 'Something has gone wrong, please try later';
      });
    };

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential auth) {
      setState(() {
        status = 'Auto retrieving verification code';
      });

      _auth.signInWithCredential(auth).then((AuthResult value) async {
        if (value.user != null) {
          setState(() {
            status = 'Authentication successful';
          });
          final snapShot = await Firestore.instance
              .collection(COLLECTION_USERS)
              .document(value.user.uid)
              .get();

          if (snapShot == null || !snapShot.exists) {
            // 해당 snapshot 이 존재하지 않을 때
            print('Not yet Registered - Profile Input Page');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileInputPage(authResult: value)));
          } else {
            Provider.of<MyUserData>(context, listen: false).update();
            Navigator.pop(context);
          }
        } else {
          setState(() {
            status = 'Invalid code/invalid authentication';
          });
        }
      }).catchError((error) {
        setState(() {
          status = 'Something has gone wrong, please try later';
        });
      });
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<AuthResult> _signInWithPhoneNumber(String smsCode) async {
    final authCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    return await _auth.signInWithCredential(authCredential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: screenAwareHeight(150, context)),
            Center(
              child: Text(
                '마  가  렛',
                style: const TextStyle(
                  fontFamily: FontFamily.jua,
                  fontSize: 50,
                  color: pastel_purple,
                ),
              ),
            ),
            SizedBox(height: screenAwareHeight(100, context)),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _phoneNumberController,
                    decoration: getTextFieldDecor('전화번호 11자리'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendCodeToPhoneNumber,
                ),
              ],
            ),
            SizedBox(height: screenAwareHeight(common_gap, context)),
            Text(status),
            SizedBox(height: screenAwareHeight(common_gap, context)),
            TextField(
              controller: _smsCodeController,
              obscureText: true,
              decoration: getTextFieldDecor('인증코드'),
            ),
            FlatButton(
              onPressed: () async {
                final authResult =
                    await _signInWithPhoneNumber(_smsCodeController.text);
                // profile_input_page 로 이동해야 함
                final snapShot = await Firestore.instance
                    .collection(COLLECTION_USERS)
                    .document(authResult.user.uid)
                    .get();

                if (snapShot == null || !snapShot.exists) {
                  // 해당 snapshot 이 존재하지 않을 때
                  print('Not yet Registered - Profile Input Page');
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfileInputPage(authResult: authResult)));
                } else {
                  Provider.of<MyUserData>(context, listen: false).update();
                  Navigator.pop(context);
                }
              },
              child: Text(
                '다음',
                style: const TextStyle(color: Colors.white),
              ),
              color: pastel_purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration getTextFieldDecor(String hint) {
    return InputDecoration(
      hintText: hint,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey[300],
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey[300],
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      fillColor: Colors.grey[100],
      filled: true,
    );
  }
}
