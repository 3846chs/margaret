import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/firebase_keys.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/firebase/transformer.dart';
import 'package:datingapp/widgets/loading_page.dart';
import 'package:datingapp/pages/match/today_people_card.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodayPeople extends StatelessWidget with Transformer {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    User myUserData = Provider.of<MyUserData>(context, listen: false).userData;
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection(COLLECTION_USERS)
          .document(myUserData.userKey)
          .collection(TODAYQUESTIONS)
          .document(formattedDate)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null)
          return LoadingPage();
        else if (!snapshot.hasData)
          return LoadingPage();
        else {
          if (snapshot.data.data['recommendedPeople'] == null)
            return NotShowPeople();
          else {
            return ShowPeople(
              recommendedPeople:
                  snapshot.data.data['recommendedPeople'].cast<String>(),
            );
          }
        }
      },
    );
  }
}

class NotShowPeople extends StatelessWidget {
  const NotShowPeople({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('아직 해당 선택지를 고른 사람이 없습니다. 기다려주세요.');
  }
}

class ShowPeople extends StatelessWidget {
  const ShowPeople({
    Key key,
    @required this.recommendedPeople,
  }) : super(key: key);


  final List<String> recommendedPeople;


  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    User myUserData = Provider.of<MyUserData>(context, listen: false).userData;
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection(COLLECTION_USERS)
            .document(myUserData.userKey)
            .collection(TODAYQUESTIONS)
            .document(formattedDate)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return LoadingPage();
          else if (!snapshot.hasData)
            return LoadingPage();
          else
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    snapshot.data.data['question'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    snapshot.data.data['choice'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TodayPeopleCard(recommendedPeople[0]),
                  TodayPeopleCard(recommendedPeople[1]),
                  TodayPeopleCard(recommendedPeople[2]),
                ],
              ),
            );
        });
  }
}
