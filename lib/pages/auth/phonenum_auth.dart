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
import 'package:flutter/services.dart';

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
  bool _isButtonEnabled = true;

  Future<void> _sendCodeToPhoneNumber() async {
    final phone = "+82${_phoneNumberController.text.substring(1)}";

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      setState(() {
        print('Code sent to $phone');
        status = "$phone로 인증코드를 보냈습니다! 본인 휴대폰일 경우, 기다리시면 자동으로 코드를 입력해드릴게요!";
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      setState(() {
        status = "시간이 초과되었습니다. 다시 전화번호를 요청해주세요.";
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        status = '${authException.message}';
        print("Error message: " + status);
        if (authException.message.contains('not authorized'))
          status = '뭔가 문제가 생긴 것 같아요...앱을 종료하고 다시 시도해주세요';
        else if (authException.message.contains('network')) {
          status = '인터넷 연결상태를 다시 한번 확인하고 시도해주세요!';
        } else if (authException.message.contains('blocked')) {
          status =
              '차단된 계정입니다. 자세한 사항은 margaret.information@gmail.com 에 문의해주세요.';
        } else if (authException.message.contains('TOO_SHORT') ||
            authException.message.contains('TOO_LONG') ||
            authException.message.contains('Invalid format')) {
          status = '올바른 형식의 전화번호를 입력해주세요!';
        } else
          status = '예기치 못한 오류입니다! margaret.information@gmail.com 에 문의해주세요.';
      });
    };

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential auth) {
      setState(() {
        status = '보낸 인증코드를 자동 확인 중입니다...';
      });

      _auth.signInWithCredential(auth).then((AuthResult value) async {
        if (value.user != null) {
          setState(() {
            status = '로그인 성공!';
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
          status = '뭔가 문제가 생긴 것 같아요...앱을 종료하고 다시 시도해주세요';
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
      appBar: AppBar(
        title: Text(
          '전화번호 가입',
          style: TextStyle(fontFamily: FontFamily.jua),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Padding(
          padding: const EdgeInsets.all(common_gap),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: screenAwareHeight(100, context)),
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
              SizedBox(height: screenAwareHeight(20, context)),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black54,
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
              Text(
                status,
                style: TextStyle(color: pastel_purple),
              ),
              SizedBox(height: screenAwareHeight(common_gap, context)),
              TextField(
                controller: _smsCodeController,
                keyboardType: TextInputType.number,
                cursorColor: Colors.black54,
                decoration: getTextFieldDecor('인증코드'),
              ),
              FlatButton(
                onPressed: !_isButtonEnabled
                    ? null
                    : () async {
                        try {
                          setState(() {
                            _isButtonEnabled = false;
                          });

                          final authResult = await _signInWithPhoneNumber(
                              _smsCodeController.text);

                          final snapShot = await Firestore.instance
                              .collection(COLLECTION_USERS)
                              .document(authResult.user.uid)
                              .get();

                          if (snapShot == null || !snapShot.exists) {
                            // 해당 snapshot 이 존재하지 않을 때
                            // profile_input_page 로 이동해야 함
                            print('Not yet Registered - Profile Input Page');
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileInputPage(
                                        authResult: authResult)));
                          } else {
                            Provider.of<MyUserData>(context, listen: false)
                                .update();
                            Navigator.pop(context);
                          }
                        } on PlatformException catch (exception) {
                          print(exception.code);
                          setState(() {
                            status = '인증코드가 올바르지 않습니다!';
                            _isButtonEnabled = true;
                          });
                        }
                      },
                child: _isButtonEnabled
                    ? Text(
                        '다음',
                        style: const TextStyle(color: Colors.white),
                      )
                    : const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.black87),
                      ),
                color: pastel_purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
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
