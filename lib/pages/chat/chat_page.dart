import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/pages/chat/chat_detail_page.dart';
import 'package:margaret/profiles/your_profile.dart';
import 'package:flutter/material.dart';
import 'package:margaret/widgets/chat/chat_card.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  final _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyUserData>(
      builder: (context, myUserData, _) {
        final myUser = myUserData.userData;

        return StreamBuilder<QuerySnapshot>(
          stream: myUser.reference
              .collection("Chats")
              .orderBy("lastDateTime", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: const CircularProgressIndicator(),
              );
            }

            final chats = snapshot.data.documents;

            return ListView.separated(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];

                return StreamBuilder<User>(
                  stream: firestoreProvider.connectUser(chat.documentID),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const CircularProgressIndicator();

                    final peer = snapshot.data;
                    final chatKey =
                        myUser.userKey.hashCode <= peer.userKey.hashCode
                            ? '${myUser.userKey}-${peer.userKey}'
                            : '${peer.userKey}-${myUser.userKey}';

                    return StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection(COLLECTION_CHATS)
                          .document(chatKey)
                          .collection(chatKey)
                          .where(MessageKeys.KEY_ISREAD, isEqualTo: false)
                          .where(MessageKeys.KEY_IDTO,
                              isEqualTo: myUser.userKey)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const CircularProgressIndicator();

                        String lastMessage = chat.data["lastMessage"];
                        Timestamp lastDateTime = chat.data["lastDateTime"];

                        return ChatCard(
                          peer: peer,
                          lastMessage: lastMessage,
                          lastDateTime: lastDateTime.toDate(),
                          newCount: snapshot.data.documents.length,
                          onProfileTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => YourProfile(peer)));
                          },
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatDetailPage(
                                          chatKey: chatKey,
                                          myKey: myUser.userKey,
                                          peer: peer,
                                        )));
                          },
                        );
                      },
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 1),
            );
          },
        );
      },
    );
  }
}
