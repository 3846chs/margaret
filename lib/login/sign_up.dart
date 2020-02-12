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
                decoration: getTextFieldDecor('이메일'),
                validator: (String value) {
                  if (value.isEmpty || !value.contains("@")) {
                    return '올바른 이메일 주소를 입력해주세요!';
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
                decoration: getTextFieldDecor('비밀번호'),
                validator: (String value) {
                  if (value.isEmpty) return '비밀번호를 입력해주세요!';
                  if (value.length < 6) return '비밀번호는 6자리 이상이어야 합니다!';
                  return null;
                },
              ),
              SizedBox(
                height: common_l_gap,
              ),
              TextFormField(
                obscureText: true,
                controller: _cpwConstroller,
                decoration: getTextFieldDecor('비밀번호 확인'),
                validator: (String value) {
                  if (value.isEmpty || value != _pwConstroller.text) {
                    return '비밀번호를 다시 확인해주세요!';
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
