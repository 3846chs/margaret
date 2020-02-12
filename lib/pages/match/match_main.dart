import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/firebase_keys.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/widgets/loading.dart';
import 'package:datingapp/pages/match/today_finished.dart';

import 'package:datingapp/pages/match/today_people.dart';
import 'package:datingapp/pages/match/today_question.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchMain extends StatefulWidget {
  @override
  _MatchMainState createState() => _MatchMainState();
}

class _MatchMainState extends State<MatchMain> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: myStream(),
        builder: (context, snapshot) {
          // Send/Receive/Chat에 속하거나 차단한 이성은 다시 매칭하지 않기 => 나중에

          if (snapshot.data == null)
            return LoadingPage();
          else if (!snapshot.hasData)
            return LoadingPage();
          else {
            var now = DateTime.now();
            if (snapshot.data.data['recentMatchTime'].toDate().year ==
                    now.year &&
                snapshot.data.data['recentMatchTime'].toDate().month ==
                    now.month &&
                snapshot.data.data['recentMatchTime'].toDate().day == now.day) {
              if (snapshot.data.data['recentMatchState'] == 0)
                return TodayQuestion();
              else if (snapshot.data.data['recentMatchState'] == -1)
                return TodayFinished();
              else // snapshot.data.data['recentMatchState'] == 1 or 2
                return TodayPeople();
            } else {
              Firestore.instance
                  .collection(COLLECTION_USERS)
                  .document(snapshot.data.documentID)
                  .updateData({'recentMatchState': 0});
              Firestore.instance
                  .collection(COLLECTION_USERS)
                  .document(snapshot.data.documentID)
                  .updateData({'recentMatchTime': DateTime.now()});

              return LoadingPage();
            }
          }
        });
  }

  Stream<DocumentSnapshot> myStream() {
    return Firestore.instance
        .collection('Users')
        .document(Provider.of<MyUserData>(context, listen: false).data.userKey)
        .snapshots();
  }
}
