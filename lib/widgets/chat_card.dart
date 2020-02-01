import 'package:dating_app/constants/size.dart';
import 'package:dating_app/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(common_gap),
            child: UserAvatar(),
          ),
          Padding(
            padding: const EdgeInsets.all(common_gap),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(common_s_gap),
                  child: const Text(
                    '닉네임',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(common_s_gap),
                  child: const Text(
                    '그럼 8시에 만나는 거 어때요?',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
