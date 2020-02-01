import 'package:flutter/material.dart';

class ProfileBasicInfo extends StatelessWidget {
  final String title;

  final String content;

  ProfileBasicInfo(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            content,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
