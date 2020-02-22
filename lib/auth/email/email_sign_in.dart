import 'package:datingapp/constants/colors.dart';
import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/utils/base_height.dart';
import 'package:datingapp/utils/simple_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EmailSignInForm extends StatefulWidget {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  TextEditingController _emailPwResetController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
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
                    if (value.isEmpty) {
                      return '비밀번호를 입력해주세요!';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: common_l_gap,
                ),
                SizedBox(
                  height: common_l_gap,
                ),
                FlatButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _login;
                    }
                  },
                  child: Text(
                    "로그인",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: pastel_purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                SizedBox(
                  height: common_s_gap,
                ),
                InkWell(
                  onTap: () {
                    return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                '비밀번호 재설정 이메일을 보내드립니다',
                                style: TextStyle(fontSize: 14),
                              ),
                              content: TextFormField(
                                controller: _emailPwResetController,
                              ),
                              actions: <Widget>[
                                MaterialButton(
                                  child: Text('보내기'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _emailPwResetController.text = '';
                                    });
                                  },
                                ),
                                MaterialButton(
                                  child: Text('취소'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _emailPwResetController.text = '';
                                    });
                                  },
                                ),
                              ],
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                            ));
                  },
                  child: Center(
                      child: Text(
                    "비밀번호 찾기",
                  )),
                ),
              ],
            )),
      ),
    );
  }

  get _login async {
    try {
      final AuthResult result =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _pwController.text,
      );
      final FirebaseUser user = result.user;

      if (user == null) {
        simpleSnackbar(context, '존재하지 않는 계정입니다');
      } else {
        Navigator.pop(context);
        Provider.of<MyUserData>(context, listen: false)
            .setNewStatus(MyUserDataStatus.progress);
      }
    } catch (e) {
      print(e.toString());
      simpleSnackbar(context, '이메일 또는 비밀번호가 올바르지 않습니다');
      setState(() {
        _emailController.text = '';
        _pwController.text = '';
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
        filled: true);
  }
}
