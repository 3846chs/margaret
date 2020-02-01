import 'package:dating_app/constants/size.dart';
import 'package:dating_app/widgets/profile_widgets/profile_basic_info.dart';
import 'package:dating_app/widgets/profile_widgets/profile_test_info.dart';
import 'package:dating_app/widgets/receive_card.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  List<List<String>> testList = [
    ["연애와 결혼은 별개라고 생각하나요?", "별개라고 생각한다.", "별개일 수 없다고 생각한다."],
    ["힘든 일이 있을 때 나는?", "애인에게 의지한다.", "혼자 이겨낸다."]
  ]; // 유저 DB 를 확인하여 테스트 리스트를 확인한다

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.redAccent,
                  size: 40,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(common_l_gap),
                child: Image.network(
                  "https://cdn.pixabay.com/photo/2017/01/03/09/18/woman-1948939_1280.jpg",
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(common_gap),
                child: Text(
                  '닉네임',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              ProfileBasicInfo('나이', '28'),
              // 사전엔 int 값일지라도 여기서는 string 으로 변환해서 넣어줘야 한다.
              ProfileBasicInfo('지역', '대전'),
              ProfileBasicInfo('직업', '회사원'),
              ProfileBasicInfo('키', '163'),
              // // 사전엔 int 값일지라도 여기서는 string 으로 변환해서 넣어줘야 한다.
              ProfileBasicInfo('체형', '보통'),
              Padding(
                padding: const EdgeInsets.all(common_gap),
                child: Text(
                  '문제 list',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
              ),
              _builTest(),
              Center(
                child: FlatButton(
                  child: const Text(
                    '대화 신청',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: null,
                  color: Colors.blue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  disabledColor: Colors.blue[100],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _builTest() {
    if (testList.length == 2) {
      return Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileTestInfo('문제 1. ' + testList[0][0], '(1) ' + testList[0][1],
                '(2) ' + testList[0][2]),
            SizedBox(
              height: 25,
            ),
            ProfileTestInfo('문제 2. ' + testList[1][0], '(1) ' + testList[1][1],
                '(2) ' + testList[1][2]),
          ],
        ),
      );
    } else if (testList.length == 1) {
      return Padding(
        padding: const EdgeInsets.all(common_gap),
        child: ProfileTestInfo('문제 1. ' + testList[0][0],
            '(1) ' + testList[0][1], '(2) ' + testList[0][2]),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Text("문제지 정보가 등록되어있지 않습니다!"),
      );
    }
  }
}
