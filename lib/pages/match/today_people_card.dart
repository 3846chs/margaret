import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/utils/base_height.dart';
import 'package:provider/provider.dart';

class TodayPeopleCard extends StatefulWidget {
  final User you;

  TodayPeopleCard(this.you);

  @override
  _TodayPeopleCardState createState() => _TodayPeopleCardState();
}

class _TodayPeopleCardState extends State<TodayPeopleCard> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return InkWell(
      child: Container(
        width: screenAwareSize(300, context),
        child: Card(
            elevation: 3,
            color: Colors.purple[50],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: <Widget>[
                Container(
                  width: 270,
                  height: screenAwareSize(90, context),
                  child: Card(
                      color: Colors.blue[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          '   ' + widget.you.answer,
                          style: GoogleFonts.nanumPenScript(fontSize: 17),
                        ),
                      )),
                ),
                SizedBox(
                  height: screenAwareSize(20, context),
                ),
                Container(
                  width: double.infinity,
                    child: Text("   저는요...", style: GoogleFonts.jua(fontSize: 15))),
                BuildTodayAnswer(widget: widget),
                BuildTodayAnswer(widget: widget),
                BuildPersonality(
                  color: Colors.pink[100],
                ),
              ],
            )),
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
      width: 270,
      height: screenAwareSize(80, context),
      child: Card(
          color: Colors.pink[100],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Center(
              child: Text(
            '   ' + widget.you.answer,
            style: GoogleFonts.notoSans(
              fontSize: 13,
            ),
          ))),
    );
  }
}

class BuildPersonality extends StatelessWidget {
  final Color color;

  const BuildPersonality({
    @required this.color,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 90,
          height: screenAwareSize(35, context),
          child: Card(
            color: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Center(
                child: Text(
              '귀여운',
              style: GoogleFonts.notoSans(
                fontSize: 13,
              ),
            )),
          ),
        ),
        Container(
          width: 90,
          height: screenAwareSize(35, context),
          child: Card(
            color: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Center(
                child: Text(
              '끈기있는',
              style: GoogleFonts.notoSans(
                fontSize: 13,
              ),
            )),
          ),
        ),
        Container(
          width: 90,
          height: screenAwareSize(35, context),
          child: Card(
            color: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Center(
                child: Text(
              '유머있는',
              style: GoogleFonts.notoSans(
                fontSize: 13,
              ),
            )),
          ),
        ),
      ],
    );
  }
}
