import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/message.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
import 'package:margaret/pages/chat/chat_detail_page.dart';
import 'package:margaret/utils/adjust_size.dart';
import 'package:provider/provider.dart';

class MyQuestionsCard extends StatelessWidget {
  final String myQuestion;
  final String peerAnswer;
  final String documentId;
  final User peer;

  MyQuestionsCard({
    Key key,
    @required this.myQuestion,
    @required this.peerAnswer,
    @required this.documentId,
    @required this.peer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myUser = Provider.of<MyUserData>(context, listen: false).userData;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => _buildDeleteDialog(context, myUser));
              },
              child: Padding(
                padding: const EdgeInsets.all(common_gap),
                child: Icon(
                  FontAwesomeIcons.solidTrashAlt,
                  color: Colors.purple[200],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48.0),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                child: ClipOval(
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: "profiles/${peer.profiles[0]}",
                        cacheManager: StorageCacheManager(),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.account_circle),
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: screenAwareWidth(40, context)),
            Column(
              children: <Widget>[
                Text(
                  peer.nickname,
                  style: const TextStyle(
                    fontFamily: FontFamily.jua,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: screenAwareHeight(10, context)),
                Text(
                  '${(DateTime.now().year - peer.birthYear + 1)}세 / ${peer.region}',
                  style: const TextStyle(
                    fontFamily: FontFamily.jua,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: screenAwareHeight(10, context)),
        Align(
          alignment: const Alignment(-0.8, 0),
          child: Icon(
            FontAwesomeIcons.quoteLeft,
            size: 15,
            color: Colors.purple[100],
          ),
        ),
        SizedBox(
          width: screenAwareWidth(250, context),
          child: Padding(
            padding: const EdgeInsets.all(common_gap),
            child: Center(
              child: Text(
                peer.introduction ?? '등록된 자기소개가 없습니다',
                style: const TextStyle(
                  fontFamily: FontFamily.nanumBarunpen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0.8, 0),
          child: Icon(
            FontAwesomeIcons.quoteRight,
            size: 15,
            color: Colors.purple[100],
          ),
        ),
        SizedBox(height: screenAwareHeight(10, context)),
        FlipCard(
          front: Container(
            child: Padding(
              padding: const EdgeInsets.all(common_gap),
              child: Center(
                child: Text(
                  myQuestion,
                  style: const TextStyle(
                    fontFamily: FontFamily.miSaeng,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            width: screenAwareWidth(270, context),
            height: screenAwareHeight(130, context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  myUser.gender == '남성' ? Colors.blue[100] : Colors.pink[100],
                  Colors.white,
                ],
              ),
              boxShadow: [
                const BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(7.0, 7.0), // shadow direction: bottom right
                ),
              ],
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          back: Container(
            child: Padding(
              padding: const EdgeInsets.all(common_gap),
              child: Center(
                child: Text(
                  peerAnswer,
                  style: TextStyle(
                    fontFamily: FontFamily.miSaeng,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            width: screenAwareWidth(270, context),
            height: screenAwareHeight(130, context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  this.peer.gender == '남성'
                      ? Colors.blue[100]
                      : Colors.pink[100],
                  Colors.white,
                ],
              ),
              boxShadow: [
                const BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(7.0, 7.0), // shadow direction: bottom right
                ),
              ],
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
        SizedBox(height: screenAwareHeight(10, context)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.arrow_upward,
              size: 10,
              color: Colors.grey[400],
            ),
            Text(
              '카드를 눌러보세요!',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(
              width: screenAwareWidth(50, context),
            ),
          ],
        ),
        SizedBox(height: screenAwareHeight(20, context)),
        InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => _buildChatDialog(context, myUser));
          },
          child: Container(
            width: screenAwareWidth(150, context),
            height: screenAwareHeight(40, context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(128.0),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  FontAwesomeIcons.commentDots,
                  color: Colors.white,
                ),
                Text(
                  "  채팅하기",
                  style: const TextStyle(
                    fontFamily: FontFamily.jua,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  AlertDialog _buildChatDialog(BuildContext context, User myUser) {
    return AlertDialog(
      title: Text('채팅으로 바로 연결됩니다'),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            // 이 버튼을 누르면 채팅창이 바로 생성되며, 채팅 시작할 때 채팅창의 UI 는 사진 참고해주세요.
            await myUser.reference
                .collection("Chats")
                .document(peer.userKey)
                .setData({
              "lastMessage": "",
              "lastDateTime": Timestamp.now(),
            });
            await peer.reference
                .collection("Chats")
                .document(myUser.userKey)
                .setData({
              "lastMessage": "",
              "lastDateTime": Timestamp.now(),
            });

            final chatKey = myUser.userKey.hashCode <= peer.userKey.hashCode
                ? '${myUser.userKey}-${peer.userKey}'
                : '${peer.userKey}-${myUser.userKey}';

            final now = DateTime.now();
            final messages = <Message>[
              Message(
                idFrom: myUser.userKey,
                idTo: "",
                content: myQuestion,
                timestamp: now.millisecondsSinceEpoch.toString(),
                type: MessageType.text,
                isRead: true,
              ),
              Message(
                idFrom: peer.userKey,
                idTo: "",
                content: peerAnswer,
                timestamp: (now.millisecondsSinceEpoch + 1).toString(),
                type: MessageType.text,
                isRead: true,
              ),
              Message(
                idFrom: "bot",
                idTo: "",
                content: "채팅이 시작되었습니다",
                timestamp: (now.millisecondsSinceEpoch + 2).toString(),
                type: MessageType.text,
                isRead: true,
              ),
            ];

            messages.forEach((message) async {
              await firestoreProvider.createMessage(chatKey, message);
            });

            myUser.reference
                .collection(MYQUESTIONS)
                .document(documentId)
                .delete();

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatDetailPage(
                          chatKey: chatKey,
                          myKey: myUser.userKey,
                          peer: peer,
                        )));
          },
          child: Text(
            '채팅하기',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('취소하기', style: TextStyle(color: Colors.blueAccent)),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  AlertDialog _buildDeleteDialog(BuildContext context, User myUser) {
    return AlertDialog(
      title: Text('카드를 삭제하겠습니까?'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            myUser.reference
                .collection(MYQUESTIONS)
                .document(documentId)
                .delete();
            print('삭제 완료');
            Navigator.pop(context);
          },
          child: Text(
            '삭제만 하고 싶어요',
            style: const TextStyle(color: Colors.blue),
          ),
        ),
        FlatButton(
          onPressed: () {
            myUser.reference
                .collection(MYQUESTIONS)
                .document(documentId)
                .delete();
            print('삭제 완료');
            Navigator.pop(context);

            // blocks 에 추가 (서로 blocks 에 추가) 구현해야 합니다
            myUser.reference.updateData({
              "blocks": FieldValue.arrayUnion([peer.userKey]),
            });
            peer.reference.updateData({
              "blocks": FieldValue.arrayUnion([myUser.userKey]),
            });
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
}
