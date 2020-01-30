import 'package:dating_app/constants/size.dart';
import 'package:dating_app/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class SendCard extends StatelessWidget {
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(common_gap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(common_s_gap),
                    child: const Text(
                      '닉네임',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(common_s_gap),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: const Text(
                          '나이',
                          style: TextStyle(color: Colors.white70),
                        )),
                        Expanded(
                          child: const Text(
                            '지역',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(common_gap),
            child: IconButton(
              icon: const Icon(Icons.check),
              color: Colors.white70,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
