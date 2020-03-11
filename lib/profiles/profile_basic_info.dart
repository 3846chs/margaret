import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/utils/adjust_size.dart';

class ProfileBasicInfo extends StatefulWidget {
  final String title;
  final String content;

  ProfileBasicInfo(this.title, this.content);

  @override
  _ProfileBasicInfoState createState() => _ProfileBasicInfoState();
}

class _ProfileBasicInfoState extends State<ProfileBasicInfo> {
  final _textEditingController = TextEditingController();
  String content;

  IconData icon;

  @override
  void initState() {
    super.initState();
    content = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.title) {
      case "성별":
        icon = FontAwesomeIcons.venusMars;
        break;
      case "나이":
        icon = FontAwesomeIcons.birthdayCake;
        break;
      case "지역":
        icon = Icons.location_on;
        break;
      case "직업":
        icon = FontAwesomeIcons.suitcase;
        break;
      case "키":
        icon = FontAwesomeIcons.child;
        break;
      case "흡연 여부":
        icon = FontAwesomeIcons.smoking;
        break;
      case "음주 여부":
        icon = FontAwesomeIcons.beer;
        break;
      case "종교":
        icon = FontAwesomeIcons.pray;
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
            width: screenAwareWidth(40, context),
          ),
          Icon(
            icon,
            color: pastel_purple,
            size: 15,
          ),
          SizedBox(
            width: screenAwareWidth(10, context),
          ),
          Center(
            child: Text(
              widget.title,
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
                  // SimpleDialog 사용해야 함
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: TextFormField(
                          controller: _textEditingController,
                        ),
                        actions: <Widget>[
                          MaterialButton(
                            elevation: 5,
                            child: Text('수정'),
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                content = _textEditingController.text;
                                _textEditingController.text = '';
                              });
                            },
                          ),
                          MaterialButton(
                            elevation: 5,
                            child: Text('취소'),
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                _textEditingController.text = '';
                              });
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
            width: screenAwareWidth(40, context),
          ),
        ],
      ),
    );
  }
}
