import 'package:datingapp/auth/email/email_auth.dart';
import 'package:datingapp/auth/login_button.dart';
import 'package:datingapp/utils/base_height.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              LoginButton(
                text: "구글로 로그인",
                icon: FontAwesomeIcons.google,
                color: Colors.red[600],
                onPressed: () => null,
              ),
              SizedBox(height: screenAwareSize(5.0, context)),
              LoginButton(
                text: "페이스북으로 로그인",
                icon: FontAwesomeIcons.facebookF,
                color: Color(0xff3a5c93),
                onPressed: () => null,
              ),
              SizedBox(height: screenAwareSize(5.0, context)),
              LoginButton(
                text: "이메일로 로그인",
                icon: FontAwesomeIcons.solidEnvelope,
                color: Colors.grey[300],
                onPressed: () => null,
              ),
              SizedBox(height: screenAwareSize(5.0, context)),
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
