import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/utils/adjust_size.dart';

class YourProfileBasicInfo extends StatefulWidget {
  final String title;
  final String content;

  YourProfileBasicInfo(this.title, this.content);

  @override
  _YourProfileBasicInfoState createState() => _YourProfileBasicInfoState();
}

class _YourProfileBasicInfoState extends State<YourProfileBasicInfo> {
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
            width: screenAwareWidth(60, context),
          ),
          Icon(
            icon,
            color: pastel_purple,
            size: 15,
          ),
          SizedBox(
            width: screenAwareWidth(15, context),
          ),
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                  fontSize: screenAwareTextSize(11, context),
                  fontFamily: FontFamily.nanumBarunpen,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: screenAwareWidth(40, context),
          ),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                  fontSize: screenAwareTextSize(11, context),
                  fontFamily: FontFamily.nanumBarunpen,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
