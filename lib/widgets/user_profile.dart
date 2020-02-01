import 'package:dating_app/constants/size.dart';
import 'package:dating_app/widgets/profile_basic_info.dart';
import 'package:dating_app/widgets/receive_card.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(common_l_gap),
                  child: Image.network(
                    "https://cdn.pixabay.com/photo/2017/01/03/09/18/woman-1948939_1280.jpg",
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  '닉네임',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                ProfileBasicInfo('나이', '28'), // 사전엔 int 값일지라도 여기서는 string 으로 변환해서 넣어줘야 한다.
                ProfileBasicInfo('지역', '대전'),
                ProfileBasicInfo('직업', '회사원'),
                ProfileBasicInfo('키', '163'), // // 사전엔 int 값일지라도 여기서는 string 으로 변환해서 넣어줘야 한다.
                ProfileBasicInfo('체형', '보통'),
                ProfileBasicInfo('체형', '보통'),
                ProfileBasicInfo('체형', '보통'),
                ProfileBasicInfo('체형', '보통'),
                ProfileBasicInfo('체형', '보통'),
                ProfileBasicInfo('체형', '보통'),
                ProfileBasicInfo('체형', '보통'),
                ProfileBasicInfo('체형', '보통'),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
