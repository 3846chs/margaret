
import 'package:datingapp/auth/email/sign_in.dart';
import 'package:datingapp/auth/email/sign_up.dart';
import 'package:datingapp/constants/colors.dart';
import 'package:flutter/material.dart';

class EmailAuth extends StatefulWidget {
  @override
  _EmailAuthState createState() => _EmailAuthState();
}

class _EmailAuthState extends State<EmailAuth> {
  Widget currentWidget = SignInForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          AnimatedSwitcher(
              duration: Duration(milliseconds: 300), child: currentWidget),
          _goToSignUpPageBtn(context),
        ],
      )),
    );
  }

  Positioned _goToSignUpPageBtn(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 40,
      child: FlatButton(
        shape: Border(top: BorderSide(color: Colors.grey[300])),
        onPressed: () {
          setState(() {
            if (currentWidget is SignInForm) {
              currentWidget = SignUpForm();
            } else {
              currentWidget = SignInForm();
            }
          });
        },
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: (currentWidget is SignInForm) ? "계정 만들기" : "로그인 하기",
              ),
              TextSpan(
                  text:
                      (currentWidget is SignInForm) ? '  Sign Up' : '  Sign In',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: pastel_purple)),
            ],
          ),
        ),
      ),
    );
  }
}
