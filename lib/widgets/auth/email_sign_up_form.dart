import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/pages/auth/profile_input_page.dart';
import 'package:margaret/utils/adjust_size.dart';
import 'package:flutter/material.dart';
import 'package:margaret/utils/simple_snack_bar.dart';

class EmailSignUpForm extends StatefulWidget {
  @override
  _EmailSignUpFormState createState() => _EmailSignUpFormState();
}

class _EmailSignUpFormState extends State<EmailSignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _cpwController = TextEditingController();
  bool _isButtonEnabled = true;

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    _cpwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
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
              TextFormField(
                controller: _emailController,
                decoration: getTextFieldDecor('이메일'),
                validator: (value) {
                  if (value.isEmpty || !value.contains("@"))
                    return '올바른 이메일 주소를 입력해주세요!';
                  return null;
                },
              ),
              SizedBox(height: screenAwareHeight(common_l_gap, context)),
              TextFormField(
                obscureText: true,
                controller: _pwController,
                decoration: getTextFieldDecor('비밀번호'),
                validator: (value) {
                  if (value.isEmpty) return '비밀번호를 입력해주세요!';
                  if (value.length < 6) return '비밀번호는 6자리 이상이어야 합니다!';
                  return null;
                },
              ),
              SizedBox(height: screenAwareHeight(common_l_gap, context)),
              TextFormField(
                obscureText: true,
                controller: _cpwController,
                decoration: getTextFieldDecor('비밀번호 확인'),
                validator: (value) {
                  if (value.isEmpty || value != _pwController.text)
                    return '비밀번호를 다시 확인해주세요!';
                  return null;
                },
              ),
              SizedBox(height: screenAwareHeight(common_l_gap, context)),
              FlatButton(
                onPressed: !_isButtonEnabled
                    ? null
                    : () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _isButtonEnabled = false;
                          });
                          _register();
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

  Future<void> _register() async {
    try {
      final authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _pwController.text);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileInputPage(authResult: authResult)));
    } on PlatformException catch (exception) {
      if (exception.code == "ERROR_EMAIL_ALREADY_IN_USE") {
        final snapShot = await Firestore.instance
            .collection(COLLECTION_USERS)
            .where(UserKeys.KEY_EMAIL, isEqualTo: _emailController.text)
            .getDocuments();

        if (snapShot == null || snapShot.documents?.length == 0) {
          final deleteUserCallable = CloudFunctions(region: "asia-northeast1")
              .getHttpsCallable(functionName: "deleteUser");
          await deleteUserCallable.call(<String, dynamic>{
            "email": _emailController.text,
          });
          final authResult = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _emailController.text, password: _pwController.text);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProfileInputPage(authResult: authResult)));
          return;
        }
      }
      print(exception.code);
      simpleSnackbar(context, exception.message);
      setState(() {
        _emailController.clear();
        _pwController.clear();
        _cpwController.clear();
        _isButtonEnabled = true;
      });
    }
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
