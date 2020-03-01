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
        width: screenAwareSize(290, context),
        child: Column(
          children: <Widget>[
            Container(
              width: 270,
              height: screenAwareSize(90, context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFFCCDDFF),
                    Color(0xFFFFEEFF),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  '   ' + widget.you.answer,
                  style: GoogleFonts.nanumPenScript(fontSize: 17),
                ),
              ),
            ),
            SizedBox(
              height: screenAwareSize(20, context),
            ),
            Container(
                width: double.infinity,
                child: Text("   저는요...", style: GoogleFonts.jua(fontSize: 15))),
            BuildTodayAnswer(widget: widget),
            SizedBox(
              height: screenAwareSize(10, context),
            ),
            BuildTodayAnswer(widget: widget),
            BuildPersonality(
              color: Colors.pink[100],
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
      width: 270,
      height: screenAwareSize(70, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFCCEEEE),
            Color(0xFFFFEEDD),
          ],
        ),
      ),
      child: Center(
        child: Text(
          '   ' + widget.you.answer,
//          style: GoogleFonts.nanumPenScript(fontSize: 17),
        ),
      ),
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
