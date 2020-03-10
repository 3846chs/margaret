import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/widgets/receive_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceivePage extends StatefulWidget {
  @override
  _ReceivePageState createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyUserData>(
      builder: (context, myUserData, _) {
        return StreamBuilder<QuerySnapshot>(
          stream:
              myUserData.userData.reference.collection("Receives").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: const CircularProgressIndicator(),
              );
            }

            final documents = snapshot.data.documents;

            return ListView.separated(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return StreamBuilder<User>(
                  stream: firestoreProvider
                      .connectUser(documents[index].documentID),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const CircularProgressIndicator();
                    Timestamp dateTime = documents[index].data["dateTime"];
                    return ReceiveCard(
                      user: snapshot.data,
                      dateTime: dateTime.toDate(),
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
