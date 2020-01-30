import 'package:dating_app/constants/size.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(common_gap),
              child: CircleAvatar(
                radius: avatar_radius,
                backgroundColor: Colors.primaries[0],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(common_gap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(common_s_gap),
                    child: const Text('닉네임'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(common_s_gap),
                    child: const Text('그럼 8시에 만나는 거 어때요?'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
