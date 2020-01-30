import 'package:dating_app/constants/size.dart';
import 'package:dating_app/widgets/chat_card.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(common_l_gap),
      child: ListView(
        children: List.generate(15, (index) => ChatCard()),
      ),
    );
  }
}
