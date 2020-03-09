import 'package:bubble/bubble.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class ReceiveCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(common_gap),
            child: UserAvatar(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(common_gap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(common_s_gap),
                    child: const Text(
                      '닉네임뭐로하지',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(common_s_gap),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: const Text(
                          '26',
                          style: TextStyle(color: Colors.black),
                        )),
                        Expanded(
                          child: const Text(
                            '대전',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(common_gap),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          content: Container(
                            width: 100,
                            height: 350,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.featherAlt,
                                  color: Colors.purple,
                                  size: 30,
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Bubble(
                                  margin: BubbleEdges.only(top: 10),
                                  alignment: Alignment.topLeft,
                                  nip: BubbleNip.leftBottom,
                                  child: Text(
                                    '부모님이 연애를 반대한다면 헤어지는 것이 가능할까요?',
                                    style: TextStyle(
                                        fontFamily: FontFamily.miSaeng,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  color: Colors.purple[50],
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Bubble(
                                  elevation: 3,
                                  nip: BubbleNip.rightBottom,
                                  child: Text(
                                    '그 이유로 헤어질 수는 없다고 생각해요.',
                                    style: TextStyle(
                                        fontFamily: FontFamily.miSaeng,
                                        fontSize: 20),
                                  ),
                                  color: Colors.pink[50], // 상대가 여자일 때는 pink[50], 남자일 때는 blue[50]
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Bubble(
                                  elevation: 3,
                                  nip: BubbleNip.rightBottom,
                                  child: Text(
                                    '연애는 둘이 하는 것이지 부모님이랑 하는게 아니잖아요.',
                                    style: TextStyle(
                                        fontFamily: FontFamily.miSaeng,
                                        fontSize: 20),
                                  ),
                                  color: Colors.pink[50], // 상대가 여자일 때는 pink[50], 남자일 때는 blue[50]
                                ),
                              ],
                            ),
                          ),
                        ));
              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(128)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Color(0xff7ad7f0),
                      Color(0xffb7e9f7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(3.0, 3.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    "오늘의 답변",
                    style: TextStyle(
                      fontFamily: FontFamily.jua,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 32,
              height: 32,
              child: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.blueAccent,
                iconSize: 16,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                          title: Text('카드를 삭제하겠습니까?'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                // receives 에서 삭제
                              },
                              child: Text(
                                '삭제만 하고 싶어요',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                // receives 에서 삭제
                                // blocks 에 추가 (서로 blocks 에 추가)
                              },
                              child: Text(
                                '더 이상 추천받고 싶지 않아요(차단하기)',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          )));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
