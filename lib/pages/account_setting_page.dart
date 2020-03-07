import 'package:flutter/material.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';

class AccountSetting extends StatelessWidget {
  AccountSetting({@required this.myUserData});

  final MyUserData myUserData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('계정 설정'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(common_l_gap),
            child: GestureDetector(
              onTap: () {
                print('로그아웃');
                this.myUserData.clearUser();
                Navigator.pop(context);
              },
              child: Text(
                '로그아웃',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(common_l_gap),
            child: GestureDetector(
              onTap: () {
                print('회원탈퇴');
              },
              child: Text(
                '회원 탈퇴',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
