import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
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
        width: screenAwareHeight(300, context),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              child: ClipOval(
                child: Consumer<MyUserData>(
                  builder: (context, value, child) {
                    return Stack(
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: "profiles/${widget.you.profiles[0]}",
                          cacheManager: StorageCacheManager(),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.account_circle),
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: new Container(
                            decoration: new BoxDecoration(
                                color: Colors.white.withOpacity(0.5)),
                          ),
                        )
                      ],
                    );
                  },
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
            BuildTodayAnswer(widget: widget),
            Container(
                alignment: Alignment(0.8, 0),
                child: Icon(
                  FontAwesomeIcons.quoteRight,
                  size: 15,
                  color: Colors.purple[100],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.dove,
                  color: color,
                  size: 15,
                ),
                Text(
                  "  전하고 싶은 말",
                  style: TextStyle(
                    fontFamily: 'BMJUA',
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            BuildIntroduction(
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

class BuildTodayAnswer extends StatelessWidget {
  const BuildTodayAnswer({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final TodayPeopleCard widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 222,
      height: screenAwareHeight(130, context),
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
            Color(0xFFCCDDFF),
            Color(0xFFFFEEFF),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            '   ' + widget.you.answer,
            style: TextStyle(fontFamily: FontFamily.miSaeng, fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class BuildIntroduction extends StatelessWidget {
  final MaterialColor cardColor;

  const BuildIntroduction({
    this.cardColor,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
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
//            Colors.blue[100],
//            Colors.white,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            '   저의 모습을 그대로 보여줄 수 있는 사람과 연애를 하고 싶습니다. 저 자체만으로 사랑해주는 사람을 만나고 싶어요.',
            style: TextStyle(fontFamily: FontFamily.miSaeng, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
