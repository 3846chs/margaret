import 'package:dating_app/constants/size.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: avatar_radius,
      backgroundColor: Colors.primaries[0],
    );
  }
}
