import 'package:dating_app/constants/size.dart';
import 'package:flutter/material.dart';

class SendCard extends StatelessWidget {
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
            Expanded(
              child: Padding(
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
                      child: Row(
                        children: <Widget>[
                          Expanded(child: const Text('나이')),
                          Expanded(
                            child: const Text(
                              '지역',
                              textAlign: TextAlign.right,
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
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
