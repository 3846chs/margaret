import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/firebase/transformer.dart';
import 'package:margaret/pages/loading_page.dart';
import 'package:margaret/pages/match/invalid_user.dart';
import 'package:margaret/utils/adjust_size.dart';
import 'package:margaret/pages/match/today_people_card.dart';
import 'package:flutter/material.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
        if (snapshot.data == null || !snapshot.hasData) return LoadingPage();

        if (snapshot.data.data['recommendedPeople'] == null)
          return NotShowPeople();
        return ShowPeople(
          recommendedPeople:
              snapshot.data.data['recommendedPeople'].cast<String>().toList(),
        );
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '매 칭 중 . . .',
              style: TextStyle(
                  fontFamily: 'BMJUA', fontSize: 30, color: pastel_purple),
            ),
            SizedBox(
              height: screenAwareHeight(100, context),
            ),
            SpinKitRipple(
              color: Colors.pinkAccent,
              size: 100,
            ),
            SizedBox(
              height: screenAwareHeight(100, context),
            ),
            Text(
              '같은 선택지를 고른 이성 3명이 모이면 알림을 보내드릴게요!',
            ),
          ],
        ),
      ),
    );
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
          if (snapshot.data == null || !snapshot.hasData)
            return LoadingPage();
          else
            return Column(children: <Widget>[
              SizedBox(
                height: screenAwareHeight(25, context),
              ),
              Text(
                snapshot.data.data['question'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'BMJUA',
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: screenAwareHeight(20, context),
              ),
              Text(
                snapshot.data.data['choice'],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'BMJUA',
                    fontSize: 15,
                    color: Colors.blueAccent),
              ),
              SizedBox(
                height: screenAwareHeight(20, context),
              ),
              CarouselSlider.builder(
                height: screenAwareHeight(420, context),
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                itemCount: recommendedPeople.length,
                itemBuilder: (BuildContext context, int itemIndex) {
                  return StreamBuilder(
                    stream: recommendedPeople
                        .map(
                            (userKey) => firestoreProvider.connectUser(userKey))
                        .toList()[itemIndex],
                    builder: (context, snapshot) {
                      if (snapshot.data == null)
                        return LoadingPage();
                      else if (!snapshot.hasData)
                        return InvalidUser();
                      else
                        return TodayPeopleCard(snapshot.data, itemIndex);
                    },
                  );
                },
              )
            ]);
        });
  }
}
