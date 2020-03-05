import 'package:margaret/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:margaret/widgets/auth/email_sign_in_form.dart';
import 'package:margaret/widgets/auth/email_sign_up_form.dart';

class EmailAuth extends StatefulWidget {
  @override
  _EmailAuthState createState() => _EmailAuthState();
}

class _EmailAuthState extends State<EmailAuth> {
  Widget currentWidget = EmailSignInForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: currentWidget,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 40,
              child: _buildSignUpButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return FlatButton(
      shape: Border(
        top: BorderSide(
          color: Colors.grey[300],
        ),
      ),
      onPressed: () {
        setState(() {
          currentWidget = (currentWidget is EmailSignInForm)
              ? EmailSignUpForm()
              : EmailSignInForm();
        });
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: <TextSpan>[
            TextSpan(
              text: (currentWidget is EmailSignInForm) ? "계정 만들기" : "로그인 하기",
            ),
            TextSpan(
              text: (currentWidget is EmailSignInForm)
                  ? '  Sign Up'
                  : '  Sign In',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: pastel_purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
