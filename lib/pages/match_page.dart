import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/widgets/match_widgets/today_finished.dart';

import 'package:datingapp/widgets/match_widgets/today_people.dart';
import 'package:datingapp/widgets/match_widgets/today_question.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchPage extends StatefulWidget {
  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: myStream(),
        builder: (context, snapshot) {
          var _recentMatchState =
              Provider.of<MyUserData>(context, listen: false)
                  .data
                  .recentMatchState;

          // 일단 날짜에 따른 질문 업데이트는 빼고 구현

          if (_recentMatchState[1] == true && _recentMatchState[2] == true)
            return TodayFinished();
          else if (_recentMatchState[1] == true &&
              _recentMatchState[2] == false)
            return TodayPeople();
          else // _recentMatchState[1] == false && _recentMatchState[2] == false
            return TodayQuestion();
        });
  }

  Stream<DocumentSnapshot> myStream() {
    return Firestore.instance
        .collection('Users')
        .document(Provider.of<MyUserData>(context, listen: false).data.userKey)
        .snapshots();
  }
}
