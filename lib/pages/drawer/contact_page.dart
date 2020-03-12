import 'package:flutter/material.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/utils/adjust_size.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '고객센터/신고하기',
          style: TextStyle(fontFamily: FontFamily.jua),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(20),
              child: Text(
                '마가렛팀에게 연락하고 싶으시거나 악성 유저를 신고하고 싶으시다면, 아래의 이메일 주소로 관련 내용을 보내주세요!',
                style: TextStyle(
                    fontFamily: FontFamily.jua,
                    color: pastel_purple,
                    fontSize: 20),
              )),
          SizedBox(
            height: screenAwareHeight(100, context),
          ),
          Text(
            'margaret.information@gmail.com',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
