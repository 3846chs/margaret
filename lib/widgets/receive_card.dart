import 'package:dating_app/constants/size.dart';
import 'package:flutter/material.dart';

class ReceiveCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: const Text(
                    '연애할 때 상대방을 위해 얼마나 포기할 수 있나요? 전부를 희생할 수 있나요?',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: const Text(
                    '어쩌고 저쩌고 Blah Blah',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 32,
              height: 32,
              child: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.white70,
                iconSize: 16,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
