import 'package:datingapp/auth/email/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SignInButton(
                Buttons.Facebook, // 페이스북 로그인
                onPressed: () {},
              ),
              SizedBox(
                height: 10,
              ),
              SignInButton(
                Buttons.Email, // 이메일 로그인
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EmailAuth()));
                },
              ),
              SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
