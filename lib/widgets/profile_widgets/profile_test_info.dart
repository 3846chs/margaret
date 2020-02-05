
import 'package:flutter/material.dart';

class ProfileTestInfo extends StatelessWidget {
  final String question;
  final String option1;
  final String option2;

  ProfileTestInfo(this.question, this.option1, this.option2);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          question,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          option1,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          option2,
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
