import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/pages/chat_detail_page.dart';
import 'package:datingapp/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final myUserData = Provider.of<MyUserData>(context);
    final chats = myUserData.userData.chats;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.separated(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: ChatCard(),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatDetailPage(
                            peerKey: chats[index],
                          )));
            },
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(height: 1);
        },
      ),
    );
  }
}
