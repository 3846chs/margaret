import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/firebase/transformer.dart';
import 'package:margaret/utils/base_height.dart';
import 'package:margaret/widgets/loading_page.dart';
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
        if (snapshot.data == null)
          return LoadingPage();
        else if (!snapshot.hasData)
          return LoadingPage();
        else {
          if (snapshot.data.data['recommendedPeople'] == null)
            return NotShowPeople();
          else {
            return ShowPeople(
              recommendedPeople: snapshot.data.data['recommendedPeople']
                  .cast<String>()
                  .toList(),
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
    return Scaffold(
      body: Center(
        child: SpinKitCircle(
          color: Colors.greenAccent,
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
            return SingleChildScrollView(
                child: Column(children: <Widget>[
              SizedBox(
                height: screenAwareSize(40, context),
              ),
              Text(
                snapshot.data.data['question'],
                textAlign: TextAlign.center,
                style: GoogleFonts.jua(fontSize: 20),
              ),
              SizedBox(
                height: screenAwareSize(20, context),
              ),
              Text(
                snapshot.data.data['choice'],
                textAlign: TextAlign.center,
                style: GoogleFonts.jua(fontSize: 15, color: Colors.blueAccent),
              ),
              SizedBox(
                height: screenAwareSize(20, context),
              ),
              CarouselSlider.builder(
                height: screenAwareSize(370, context),
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                itemCount: 3,
                itemBuilder: (BuildContext context, int itemIndex) {
                  return StreamBuilder(
                    stream: recommendedPeople
                        .map(
                            (userKey) => firestoreProvider.connectUser(userKey))
                        .toList()[itemIndex],
                    builder: (context, snapshot) {
                      if (snapshot.data == null || !snapshot.hasData)
                        return CircularProgressIndicator();
                      else
                        return TodayPeopleCard(snapshot.data);
                    },
                  );
                },
              )
            ]));
        });
  }
}
