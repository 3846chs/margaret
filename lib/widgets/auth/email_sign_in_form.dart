import 'package:flutter/services.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/pages/auth/email/email_pw_reset.dart';
import 'package:margaret/utils/adjust_size.dart';
import 'package:margaret/utils/simple_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailSignInForm extends StatefulWidget {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _emailPwResetController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
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
              const SizedBox(height: common_l_gap),
              TextFormField(
                obscureText: true,
                controller: _pwController,
                decoration: getTextFieldDecor('비밀번호'),
                validator: (value) {
                  if (value.isEmpty) return '비밀번호를 입력해주세요!';
                  return null;
                },
              ),
              const SizedBox(height: common_l_gap),
              const SizedBox(height: common_l_gap),
              FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) _login();
                },
                child: Text(
                  "로그인",
                  style: TextStyle(color: Colors.white),
                ),
                color: pastel_purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EmailPwReset()));
                },
                child: Container(
                  height: 30,
                  child: Center(
                    child: Text("비밀번호 재설정"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _pwController.text,
      );

      if (result.user == null) {
        simpleSnackbar(context, '존재하지 않는 계정입니다');
      } else {
        Navigator.pop(context);
        Provider.of<MyUserData>(context, listen: false).update();
      }
    } on PlatformException catch (exception) {
      print(exception.code);
      simpleSnackbar(context, exception.message);
      setState(() {
        _emailController.clear();
        _pwController.clear();
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
