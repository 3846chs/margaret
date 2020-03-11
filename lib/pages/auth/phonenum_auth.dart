import 'package:flutter/material.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/utils/adjust_size.dart';

class PhonenumAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          SizedBox(height: screenAwareHeight(150, context)),
          Center(
            child: Text(
              '마  가  렛',
              style: const TextStyle(
                fontFamily: FontFamily.jua,
                fontSize: 50,
                color: pastel_purple,
              ),
            ),
          ),
          SizedBox(
            height: screenAwareHeight(100, context),
          ),
          Container(
            height: screenAwareHeight(50, context),
            width: screenAwareWidth(300, context),
            child: TextFormField(
              decoration: getTextFieldDecor('전화번호 11자리'),
              validator: (value) {
                if (value.isEmpty) return '올바른 전화번호를 입력해주세요!';
                return null;
              },
            ),
          ),
          const SizedBox(height: common_gap),
          Container(
            height: screenAwareHeight(50, context),
            width: screenAwareWidth(300, context),
            child: TextFormField(
              obscureText: true,
              decoration: getTextFieldDecor('인증코드'),
              validator: (value) {
                if (value.isEmpty) return '인증코드를 입력해주세요!';
                return null;
              },
            ),
          ),
          Container(
            width: screenAwareWidth(300, context),
            child: FlatButton(
              onPressed: () {
                // profile_input_page 로 이동해야 함
              },
              child: Text(
                '다음',
                style: const TextStyle(color: Colors.white),
              ),
              color: pastel_purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
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
