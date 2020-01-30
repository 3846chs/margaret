import 'package:dating_app/widgets/chat_card.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          '채팅하기',
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.lightBlue[300],
      ),
      body: ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) {
          return InkWell(
            child: ChatCard(),
            onTap: () {},
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(height: 1);
        },
      ),
    );
  }
}
