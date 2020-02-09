import 'package:datingapp/constants/size.dart';
import 'package:datingapp/pages/profile_input_page.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailConstroller = TextEditingController();
  TextEditingController _pwConstroller = TextEditingController();
  TextEditingController _cpwConstroller = TextEditingController();

  @override
  void dispose() {
    _emailConstroller.dispose();
    _pwConstroller.dispose();
    _cpwConstroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: common_s_gap,
              ),
              SizedBox(
                height: common_l_gap,
              ),
              TextFormField(
                controller: _emailConstroller,
                decoration: getTextFieldDecor('Email'),
                validator: (String value) {
                  if (value.isEmpty || !value.contains("@")) {
                    return 'Please enter your email address!';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: common_l_gap,
              ),
              TextFormField(
                obscureText: true,
                controller: _pwConstroller,
                decoration: getTextFieldDecor('Password'),
                validator: (String value) {
                  if (value.isEmpty) return 'Please enter any password!';
                  if (value.length < 6)
                    return 'Password should be at least 6 characters!';
                  return null;
                },
              ),
              SizedBox(
                height: common_l_gap,
              ),
              TextFormField(
                obscureText: true,
                controller: _cpwConstroller,
                decoration: getTextFieldDecor('Confirm Password'),
                validator: (String value) {
                  if (value.isEmpty || value != _pwConstroller.text) {
                    return 'Password does not match!';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: common_l_gap,
              ),
              FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileInputPage(
                                  email: _emailConstroller.text,
                                  password: _pwConstroller.text,
                                )));
                  }
                },
                child: Text('Next', style: TextStyle(color: Colors.white)),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                disabledColor: Colors.blue[100],
              ),
              SizedBox(
                height: common_l_gap,
              ),
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                      left: 0,
                      right: 0,
                      height: 1,
                      child: Container(
                        color: Colors.grey[300],
                        height: 1,
                      )),
                  Container(
                    height: 3,
                    width: 50,
                    color: Colors.grey[50],
                  ),
                  Text(
                    'OR',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: common_l_gap,
              ),
              SizedBox(
                height: common_l_gap,
              ),
              SizedBox(
                height: common_s_gap,
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
