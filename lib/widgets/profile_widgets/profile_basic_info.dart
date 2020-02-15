import 'package:datingapp/constants/size.dart';
import 'package:flutter/material.dart';

class ProfileBasicInfo extends StatelessWidget {
  final String title;
  final String content;
  var icon = Icons.done;

  ProfileBasicInfo(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    if (title == '나이') icon = Icons.cake;
    // ...

    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.black45,
            size: 15,
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
              child: Text(
                content,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
