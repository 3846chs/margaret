import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceiveCard extends StatelessWidget {
  final User user;
  final DateTime dateTime;

  ReceiveCard({@required this.user, @required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(common_gap),
            child: UserAvatar(user: user),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(common_gap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(common_s_gap),
                    child: Text(
                      user.nickname,
                      style: const TextStyle(
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
                          child: Text((DateTime.now().year - user.birthYear + 1)
                              .toString()),
                        ),
                        Expanded(
                          child: Text(user.region),
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
            child: _buildAnswerButton(context),
          ),
          Padding(
            padding: const EdgeInsets.all(common_gap),
            child: IconButton(
              icon: const Icon(Icons.close),
              color: Colors.blueAccent,
              iconSize: 16.0,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _buildDeleteDialog(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AlertDialog _buildDeleteDialog(BuildContext context) {
    final myUser = Provider.of<MyUserData>(context, listen: false).userData;

    return AlertDialog(
      title: Text('카드를 삭제하겠습니까?'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            // receives 에서 삭제
            myUser.reference
                .collection("Receives")
                .document(user.userKey)
                .delete();
            Navigator.pop(context);
          },
          child: Text(
            '삭제만 하고 싶어요',
            style: const TextStyle(color: Colors.blue),
          ),
        ),
        FlatButton(
          onPressed: () async {
            // receives 에서 삭제
            // blocks 에 추가 (서로 blocks 에 추가)
            await myUser.reference
                .collection("Receives")
                .document(user.userKey)
                .delete();
            await myUser.reference.updateData({
              "blocks": FieldValue.arrayUnion([user.userKey]),
            });
            user.reference.updateData({
              "blocks": FieldValue.arrayUnion([myUser.userKey]),
            });
            Navigator.pop(context);
          },
          child: Text(
            '더 이상 추천받고 싶지 않아요(차단하기)',
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Widget _buildAnswerButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(128.0),
      onTap: () => showDialog(
          context: context, builder: (context) => _buildAnswerDialog()),
      child: Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(128.0),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xff03c04a),
              Color(0xff3ded97),
            ],
          ),
          boxShadow: [
            const BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(3.0, 3.0), // shadow direction: bottom right
            ),
          ],
        ),
        child: Center(
          child: Text(
            "오늘의 답변",
            style: const TextStyle(
              fontFamily: FontFamily.jua,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  AlertDialog _buildAnswerDialog() {
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedDate = formatter.format(dateTime);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      content: SizedBox(
        width: 100,
        height: 350,
        child: StreamBuilder<DocumentSnapshot>(
            stream: user.reference
                .collection("TodayQuestions")
                .document(formattedDate)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();

              final question = snapshot.data.data;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.featherAlt,
                    color: Colors.purple,
                    size: 30,
                  ),
                  SizedBox(height: 40),
                  Bubble(
                    margin: BubbleEdges.only(top: 10),
                    alignment: Alignment.topLeft,
                    nip: BubbleNip.leftBottom,
                    child: Text(
                      question["question"],
                      style: const TextStyle(
                        fontFamily: FontFamily.miSaeng,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.purple[50],
                  ),
                  SizedBox(height: 40),
                  Bubble(
                    elevation: 3,
                    nip: BubbleNip.rightBottom,
                    child: Text(
                      question["choice"],
                      style: const TextStyle(
                        fontFamily: FontFamily.miSaeng,
                        fontSize: 20,
                      ),
                    ),
                    color:
                        user.gender == "남성" ? Colors.blue[50] : Colors.pink[50],
                  ),
                  SizedBox(height: 20),
                  Bubble(
                    elevation: 3,
                    nip: BubbleNip.rightBottom,
                    child: Text(
                      question["answer"],
                      style: const TextStyle(
                        fontFamily: FontFamily.miSaeng,
                        fontSize: 20,
                      ),
                    ),
                    color:
                        user.gender == "남성" ? Colors.blue[50] : Colors.pink[50],
                  ),
                ],
              );
            }),
      ),
    );
  }
}
