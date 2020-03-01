import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
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
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  child: ClipOval(
                    child: Consumer<MyUserData>(
                      builder: (context, value, child) {
                        return CachedNetworkImage(
                          imageUrl: "profiles/${widget.you.profiles[0]}",
                          cacheManager: StorageCacheManager(),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.account_circle),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  widget.you.nickname,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
                alignment: Alignment(-1, 0),
                child: Icon(
                  FontAwesomeIcons.quoteLeft,
                  size: 15,
                  color:  Colors.purple[100],
                )),
            Container(
              width: 270,
              height: screenAwareSize(90, context),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],
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
                  style: GoogleFonts.nanumPenScript(fontSize: 18),
                ),
              ),
            ),
            Container(
                alignment: Alignment(1, 0),
                child: Icon(
                  FontAwesomeIcons.quoteRight,
                  size: 15 ,
                  color:  Colors.purple[100],
                )),
            Center(child: Text("가치관 소개", style: GoogleFonts.jua(fontSize: 15))),
            BuildValue1(),
            SizedBox(
              height: screenAwareSize(5, context),
            ),
            NewWidget(),
//            BuildPersonality(
//              color: Colors.blue[100],
//            ),
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

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key key,
  }) : super(key: key);

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
      child: Text(
        'Q. 휴일에 주로 무엇을 하나요? \n\nA. 요리하기 청소하기 쇼핑하기',
        style: GoogleFonts.jua(fontSize: 13),
      ),
    );
  }
}

class BuildValue1 extends StatelessWidget {
  const BuildValue1({
    Key key,
  }) : super(key: key);

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
      child: Text(
        ' Q. 인생에서 가장 중요한 세가지는 무엇인가요?\n\n A. 돈과 사랑과 건강입니다,',
        style: GoogleFonts.jua(fontSize: 13),
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
