import 'package:datingapp/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class AuthMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SignInButton(
                Buttons.Facebook,
                onPressed: () {},
              ),

              SizedBox(
                height: 10,
              ),
              SignInButton(
                Buttons.Email,
                onPressed: () {
                  Navigator.push(
                              context, MaterialPageRoute(builder: (context) => AuthPage()));
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
