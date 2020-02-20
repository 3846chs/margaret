import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String myKey;
  final Message message;
  final bool isSent;
  final DateTime dateTime;

  ChatBubble({@required this.myKey, @required this.message})
      : isSent = myKey == message.idFrom,
        dateTime =
            DateTime.fromMillisecondsSinceEpoch(int.parse(message.timestamp));

  @override
  Widget build(BuildContext context) {
    if (isSent) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const Spacer(),
          _buildTime(),
          _buildBubble(),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _buildBubble(),
        _buildTime(),
        const Spacer(),
      ],
    );
  }

  Widget _buildTime() {
    return Padding(
      padding: const EdgeInsets.only(bottom: common_gap),
      child: Text(
        DateFormat.jm().format(dateTime),
        style: const TextStyle(fontSize: 10.0),
      ),
    );
  }

  Widget _buildBubble() {
    return Container(
      padding: const EdgeInsets.all(common_gap),
      constraints: const BoxConstraints(maxWidth: 200.0),
      decoration: BoxDecoration(
        color: isSent ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(common_gap),
      child: Text(
        message.content,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
