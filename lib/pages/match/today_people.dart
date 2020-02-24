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
    return SafeArea(
        child: StreamBuilder<List<User>>(
      stream: Firestore.instance
          .collection(COLLECTION_USERS)
          .orderBy(UserKeys.KEY_RECENTMATCHTIME, descending: true)
          //.where('gender', isEqualTo: '여성')
          .snapshots()
          .transform(toUsers),
      builder: (context, snapshot) {
        if (snapshot.data == null || !snapshot.hasData) return LoadingPage();
        User myUser = Provider.of<MyUserData>(context, listen: false).userData;
        return _buildTodayPeople(snapshot.data, myUser);
      },
    ));
  }

  Widget _buildTodayPeople(List<User> users, User myUser) {
    final now = DateTime.now();
    final recommendedPeople = users
        .where((user) {
          final recentMatchTime = user.recentMatchTime.toDate();
          return (user.gender != myUser.gender &&
                  user.recentMatchState == myUser.recentMatchState &&
                  recentMatchTime.year == now.year &&
                  recentMatchTime.month == now.month &&
                  recentMatchTime.day == now.day) &&
              myUser.recentMatchTime.toDate().isAfter(recentMatchTime);
        })
        .take(3)
        .toList();

    if (recommendedPeople.length < 3) {
      print('NotShowPeople');
      return NotShowPeople();
    } else {
      print('ShowPeople');
      return ShowPeople(recommendedPeople: recommendedPeople);
    }
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

  final List<User> recommendedPeople;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: myStream(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return LoadingPage();
          else if (!snapshot.hasData)
            return LoadingPage();
          else
            return Column(
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
            );
        });
  }

  Stream<DocumentSnapshot> myStream() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return Firestore.instance
        .collection(COLLECTION_USERS)
        .document(recommendedPeople[0].userKey) // 같은 선택지를 고른 사람끼리 모았음
        .collection(TODAYQUESTIONS)
        .document(formattedDate)
        .snapshots();
  }
}
