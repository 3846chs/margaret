import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/auth/profile_input_page.dart';
import 'package:margaret/utils/base_height.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailSignUpForm extends StatefulWidget {
  @override
  _EmailSignUpFormState createState() => _EmailSignUpFormState();
}

class _EmailSignUpFormState extends State<EmailSignUpForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  TextEditingController _cpwController = TextEditingController();

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
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: screenAwareSize(150, context),
              ),
              Center(
                child: Text(
                  '마  가  렛',
                  style: GoogleFonts.jua(fontSize: 50, color: pastel_purple),
                ),
              ),
              TextFormField(
                controller: _emailController,
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
                controller: _pwController,
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
                controller: _cpwController,
                decoration: getTextFieldDecor('비밀번호 확인'),
                validator: (String value) {
                  if (value.isEmpty || value != _pwController.text) {
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileInputPage(
                                  email: _emailController.text,
                                  password: _pwController.text,
                                )));
                  }
                },
                child: Text('다음', style: TextStyle(color: Colors.white)),
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
