import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Icon(
                FontAwesomeIcons.quoteLeft,
                color: pastel_purple,
                size: 15,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AutoSizeText(
                "건전한 온라인 소개팅 시장을 만들겠습니다",
                style:
                    TextStyle(fontFamily: FontFamily.mapleStory, fontSize: 20),
                maxLines: 1,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Icon(
                FontAwesomeIcons.quoteRight,
                color: pastel_purple,
                size: 15,
              ),
            ),
            SizedBox(
              height: screenAwareHeight(100, context),
            ),
            Text(
              '마가렛팀에게 연락하고 싶으시거나 악성 유저를 신고하고 싶으시다면, 아래의 이메일 주소로 관련 내용을 보내주세요!',
              style: TextStyle(
                  fontFamily: FontFamily.jua,
                  color: pastel_purple,
                  fontSize: 20),
            ),
            SizedBox(
              height: screenAwareHeight(100, context),
            ),
            AutoSizeText(
              'margaret.information@gmail.com',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
