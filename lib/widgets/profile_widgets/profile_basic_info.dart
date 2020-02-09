import 'package:datingapp/constants/size.dart';
import 'package:flutter/material.dart';

class ProfileBasicInfo extends StatelessWidget {
  final String title;

  final String content;

  ProfileBasicInfo(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
