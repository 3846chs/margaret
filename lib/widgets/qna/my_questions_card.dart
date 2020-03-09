import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/provider/my_user_data.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
import 'package:margaret/pages/chat/chat_detail_page.dart';
import 'package:margaret/utils/base_height.dart';
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
        Padding(
          padding: const EdgeInsets.only(right: common_gap),
          child: InkWell(
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
            SizedBox(width: 40),
            Column(
              children: <Widget>[
                Text(
                  peer.nickname,
                  style: const TextStyle(
                    fontFamily: FontFamily.jua,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
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
        SizedBox(height: screenAwareSize(10, context)),
        Align(
          alignment: const Alignment(-0.8, 0),
          child: Icon(
            FontAwesomeIcons.quoteLeft,
            size: 15,
            color: Colors.purple[100],
          ),
        ),
        SizedBox(
          width: 250,
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
        SizedBox(height: screenAwareSize(10, context)),
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
            width: 270,
            height: 130,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.blue[100],
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
            width: 270,
            height: 130,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.pink[100],
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
        SizedBox(height: screenAwareSize(20, context)),
        InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => _buildChatDialog(context, myUser));
          },
          child: Container(
            width: 150,
            height: 40,
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
      title: Text('채팅 연결하기'),
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

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatDetailPage(
                          chatKey: chatKey,
                          myKey: myUser.userKey,
                          peer: peer,
                        )));
          },
          child: Text('채팅하기'),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('취소하기'),
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
