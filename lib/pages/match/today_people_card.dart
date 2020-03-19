import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/storage_provider.dart';
import 'package:margaret/utils/adjust_size.dart';
import 'package:provider/provider.dart';

class TodayPeopleCard extends StatefulWidget {
  final User you;
  final int itemIndex;

  TodayPeopleCard(this.you, this.itemIndex);

  @override
  _TodayPeopleCardState createState() => _TodayPeopleCardState();
}

class _TodayPeopleCardState extends State<TodayPeopleCard> {
  @override
  Widget build(BuildContext context) {
    MaterialColor color;
    switch (widget.itemIndex) {
      case 0:
        color = Colors.pink;
        break;
      case 1:
        color = Colors.purple;
        break;
      default:
        color = Colors.blue;
        break;
    }
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    return GestureDetector(
      child: Container(
        width: screenAwareWidth(300, context),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              child: ClipOval(
                child: Stack(
                  children: <Widget>[
                    FutureBuilder<String>(
                      future: storageProvider
                          .getFileURL("profiles/${widget.you.profiles.first}"),
                      builder: (context, snapshot) {
                        if (snapshot.hasError || !snapshot.hasData)
                          return const Icon(Icons.account_circle);
                        return Image.network(
                          snapshot.data,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: new Container(
                        decoration: new BoxDecoration(
                            color: Colors.white.withOpacity(0.5)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenAwareHeight(10, context),
            ),
            Text(
              widget.you.nickname,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Container(
                alignment: Alignment(-0.8, 0),
                child: Icon(
                  FontAwesomeIcons.quoteLeft,
                  size: 15,
                  color: Colors.purple[100],
                )),
            BuildIntroduction(widget: widget),
            Container(
                alignment: Alignment(0.8, 0),
                child: Icon(
                  FontAwesomeIcons.quoteRight,
                  size: 15,
                  color: Colors.purple[100],
                )),
            SizedBox(
              height: screenAwareHeight(10, context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.dove,
                  color: color,
                  size: 15,
                ),
                Text(
                  " " + widget.you.nickname + "님의 답변",
                  style: TextStyle(
                    fontFamily: 'BMJUA',
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenAwareHeight(10, context),
            ),
            BuildTodayAnswer(
              widget: widget,
              cardColor: color,
            ),
            SizedBox(
              height: screenAwareHeight(5, context),
            ),
          ],
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Consumer<MyUserData>(builder: (context, value, child) {
                return AlertDialog(
                  content: Text('이 답변을 선택하시겠습니까?'),
                  actions: <Widget>[
                    MaterialButton(
                      elevation: 5,
                      child: Text('선택'),
                      onPressed: () {
                        Navigator.pop(context);

                        Firestore.instance
                            .collection(COLLECTION_USERS)
                            .document(value.userData.userKey)
                            .updateData({
                          'recentMatchState':
                              -value.userData.recentMatchState.value
                          // 음수로 변환
                        });

                        Firestore.instance
                            .collection(COLLECTION_USERS)
                            .document(value.userData.userKey)
                            .collection(TODAYQUESTIONS)
                            .document(formattedDate)
                            .updateData({'selectedPerson': widget.you.userKey});
                      },
                    ),
                    MaterialButton(
                      elevation: 5,
                      child: Text('취소'),
                      onPressed: () {
                        Navigator.pop(context);
                        print('취소함');
                      },
                    ),
                  ],
                );
              });
            });
      },
    );
  }
}

class BuildIntroduction extends StatelessWidget {
  const BuildIntroduction({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final TodayPeopleCard widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenAwareWidth(222, context),
      height: screenAwareHeight(110, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Text(
          '   ' + widget.you.introduction,
          style: TextStyle(fontFamily: FontFamily.miSaeng, fontSize: 20),
        ),
      ),
    );
  }
}

class BuildTodayAnswer extends StatelessWidget {
  final MaterialColor cardColor;
  final TodayPeopleCard widget;

  const BuildTodayAnswer({
    this.widget,
    this.cardColor,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenAwareWidth(270, context),
      height: screenAwareHeight(100, context),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            cardColor[100],
            Colors.white,
          ],
        ),
      ),
      child: Center(
        child: Text(
          widget.you.answer,
          style: TextStyle(fontFamily: FontFamily.miSaeng, fontSize: 20),
        ),
      ),
    );
  }
}
