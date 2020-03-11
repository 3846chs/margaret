import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/message.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/pages/chat/chat_detail_page.dart';
import 'package:margaret/profiles/your_profile.dart';
import 'package:margaret/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceiveCard extends StatelessWidget {
  final User user;
  final String formattedDate;

  ReceiveCard({@required this.user, DateTime dateTime})
      : formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

  @override
  Widget build(BuildContext context) {
    final myUser = Provider.of<MyUserData>(context, listen: false).userData;

    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(common_gap),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => YourProfile(user)));
              },
              child: UserAvatar(user: user),
            ),
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
          _buildButton(
              "오늘의 답변",
              () => showDialog(
                  context: context,
                  builder: (context) => _buildAnswerDialog(myUser))),
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.blueAccent,
            iconSize: 16.0,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => _buildDeleteDialog(context, myUser),
              );
            },
          ),
        ],
      ),
    );
  }

  AlertDialog _buildDeleteDialog(BuildContext context, User myUser) {
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
            myUser.reference
                .collection("Receives")
                .document(user.userKey)
                .delete();
            myUser.reference.updateData({
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

  Widget _buildButton(String title, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(128.0),
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(128.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xfffd5c76),
              Color(0xffff8951),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: common_l_gap),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: FontFamily.jua,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  AlertDialog _buildAnswerDialog(User myUser) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      content: SizedBox(
        width: 100,
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
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.featherAlt,
                  color: Colors.purple,
                  size: 30,
                ),
                SizedBox(height: 40),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Bubble(
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
                ),
                SizedBox(height: 40),
                Container(
                  alignment: Alignment.centerRight,
                  child: Bubble(
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
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerRight,
                  child: Bubble(
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
                ),
                SizedBox(height: 40),
                _buildButton("채팅 연결하기", () async {
                  await myUser.reference
                      .collection("Chats")
                      .document(user.userKey)
                      .setData({
                    "lastMessage": "",
                    "lastDateTime": Timestamp.now(),
                  });
                  await user.reference
                      .collection("Chats")
                      .document(myUser.userKey)
                      .setData({
                    "lastMessage": "",
                    "lastDateTime": Timestamp.now(),
                  });

                  final myQuestion = await myUser.reference
                      .collection("TodayQuestions")
                      .document(formattedDate)
                      .get();
                  final peerQuestion = await user.reference
                      .collection("TodayQuestions")
                      .document(formattedDate)
                      .get();

                  final chatKey =
                      myUser.userKey.hashCode <= user.userKey.hashCode
                          ? '${myUser.userKey}-${user.userKey}'
                          : '${user.userKey}-${myUser.userKey}';

                  final now = DateTime.now();
                  final messages = <Message>[
                    Message(
                      idFrom: "bot",
                      idTo: "",
                      content: myQuestion.data["question"],
                      timestamp: now.millisecondsSinceEpoch.toString(),
                      type: MessageType.text,
                      isRead: true,
                    ),
                    Message(
                      idFrom: myUser.userKey,
                      idTo: "",
                      content: myQuestion.data["answer"],
                      timestamp: (now.millisecondsSinceEpoch + 1).toString(),
                      type: MessageType.text,
                      isRead: true,
                    ),
                    Message(
                      idFrom: user.userKey,
                      idTo: "",
                      content: peerQuestion.data["answer"],
                      timestamp: (now.millisecondsSinceEpoch + 2).toString(),
                      type: MessageType.text,
                      isRead: true,
                    ),
                    Message(
                      idFrom: "bot",
                      idTo: "",
                      content: "채팅이 시작되었습니다",
                      timestamp: (now.millisecondsSinceEpoch + 3).toString(),
                      type: MessageType.text,
                      isRead: true,
                    ),
                  ];

                  messages.forEach((message) async {
                    await firestoreProvider.createMessage(chatKey, message);
                  });

                  myUser.reference
                      .collection("Receives")
                      .document(user.userKey)
                      .delete();

                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatDetailPage(
                                chatKey: chatKey,
                                myKey: myUser.userKey,
                                peer: user,
                              )));
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
