import 'package:datingapp/data/message.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/firebase/firestore_provider.dart';
import 'package:datingapp/pages/chat_detail_page.dart';
import 'package:datingapp/profiles/your_profile.dart';
import 'package:datingapp/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<MyUserData>(
        builder: (context, value, child) {
          final chats = value.userData.chats
              .map((userKey) => firestoreProvider.connectUser(userKey))
              .toList();

          return ListView.separated(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return StreamBuilder<User>(
                stream: chats[index],
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const CircularProgressIndicator();

                  final peer = snapshot.data;
                  final myKey = value.userData.userKey;
                  final chatKey = myKey.hashCode <= peer.userKey.hashCode
                      ? '$myKey-${peer.userKey}'
                      : '${peer.userKey}-$myKey';

                  return InkWell(
                    child: StreamBuilder<Message>(
                        stream: firestoreProvider.connectMessage(chatKey),
                        builder: (context, snapshot) {
                          return ChatCard(
                            peer: peer,
                            onProfileTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => YourProfile(peer)));
                            },
                            lastMessage: snapshot.hasData
                                ? (snapshot.data.type == MessageType.text
                                    ? snapshot.data.content
                                    : '사진을 보냈습니다.')
                                : '',
                          );
                        }),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatDetailPage(
                                    chatKey: chatKey,
                                    myKey: myKey,
                                    peer: peer,
                                  )));
                    },
                  );
                },
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 1);
            },
          );
        },
      ),
    );
  }
}
