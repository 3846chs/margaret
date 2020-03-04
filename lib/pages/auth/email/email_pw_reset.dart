import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/utils/base_height.dart';
import 'package:margaret/utils/simple_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:rich_alert/rich_alert.dart';

class EmailPwReset extends StatefulWidget {
  @override
  _EmailPwResetState createState() => _EmailPwResetState();
}

class _EmailPwResetState extends State<EmailPwReset> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

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
                  height: screenAwareSize(200, context),
                ),
                Center(
                  child: Text(
                    '비밀번호 변경하기',
                    style: GoogleFonts.jua(fontSize: 30, color: pastel_purple),
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
                  height: 32,
                ),
                FlatButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: _emailController.text);
                        print('정상적으로 보냄');
                        successRichAlert(context);
                      } catch (exception) {
                        if (exception.code == 'ERROR_TOO_MANY_REQUESTS')
                          tooManyRichAlert(context);
                        else
                          invalidRichAlert(context);
                      }
                    }
                  },
                  child: Text(
                    "제출",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: pastel_purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
              ],
            )),
      ),
    );
  }

  Future invalidRichAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          var _email = _emailController.text;
          return RichAlertDialog(
            //uses the custom alert dialog
            alertTitle: richTitle("이메일 전송 실패"),
            alertSubtitle: richSubtitle("가입되지 않았거나 유효하지 않은 이메일 주소입니다."),
            alertType: RichAlertType.ERROR,
            actions: <Widget>[
              Container(
                alignment: Alignment.center,
                child: RaisedButton(
                  elevation: 2.0,
                  color: pastel_purple,
                  child: Text(
                    "확인",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        });
  }

  Future tooManyRichAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          var _email = _emailController.text;
          return RichAlertDialog(
            //uses the custom alert dialog
            alertTitle: richTitle("비정상적인 행동 감지"),
            alertSubtitle: richSubtitle(
                "해당 이메일 주소로 이미 여러 번 이메일 전송 요청을 너무 많이 했습니다. 1시간 뒤에 다시 시도해주세요."),
            alertType: RichAlertType.WARNING,
            actions: <Widget>[
              Container(
                alignment: Alignment.center,
                child: RaisedButton(
                  elevation: 2.0,
                  color: pastel_purple,
                  child: Text(
                    "확인",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        });
  }

  Future successRichAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          var _email = _emailController.text;
          return RichAlertDialog(
            //uses the custom alert dialog
            alertTitle: richTitle("이메일 전송 완료"),
            alertSubtitle: richSubtitle("$_email 로 전송했습니다."),
            alertType: RichAlertType.SUCCESS,
            actions: <Widget>[
              Container(
                alignment: Alignment.center,
                child: RaisedButton(
                  color: pastel_purple,
                  elevation: 2.0,
                  child: Text(
                    "확인",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        });
  }

  Future sendPasswordResetEmail(String email) async {}

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
