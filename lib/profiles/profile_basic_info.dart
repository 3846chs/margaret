import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileBasicInfo extends StatelessWidget {
  final String title;
  final String content;
  var icon;

  ProfileBasicInfo(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    switch (title) {
      case "성별":
        icon = FontAwesomeIcons.venusMars;
        break;
      case "나이":
        icon = Icons.cake;
        break;
      case "지역":
        icon = Icons.location_on;
        break;
      case "직업":
        icon = FontAwesomeIcons.suitcase;
        break;
      case "키":
        icon = FontAwesomeIcons.key;
        break;
      default:
        icon = Icons.check;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 40,
          ),
          Icon(
            icon,
            color: Color.fromRGBO(222, 222, 255, 1),
            size: 15,
          ),
          SizedBox(
            width: 10,
          ),
          Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Spacer(),
          Expanded(
            child: Center(
              child: GestureDetector(
                child: Text(
                  content,
                  style: TextStyle(fontSize: 15),
                ),
                onTap: () {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: TextFormField(),
                        actions: <Widget>[
                          MaterialButton(
                            elevation: 5,
                            child: Text('수정'),
                            onPressed: () {
                              Navigator.pop(context);
                              // recentMatchState 변경
                            },
                          ),
                          MaterialButton(
                            elevation: 5,
                            child: Text('취소'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              // 클릭하면 팝업창 띄워서 수정하는 디자인으로 갈 예정
            ),
          ),
          SizedBox(
            width: 40,
          ),
        ],
      ),
    );
  }
}
