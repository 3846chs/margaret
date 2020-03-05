import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:margaret/constants/font_names.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
import 'package:margaret/utils/base_height.dart';

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
    return InkWell(
      onTap: () {},
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              print('패스하기');
            },
            child: Padding(
              padding: const EdgeInsets.all(common_l_gap),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.solidTrashAlt,
                    color: Colors.pink[200],
                  ),
                  SizedBox(width: 10),
                ],
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
                    const BoxShadow(color: Colors.grey, blurRadius: 5.0),
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
                        fontFamily: FontFamily.jua, fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${(DateTime.now().year - peer.birthYear + 1).toString()}세 / ${peer.region}',
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
          Container(
            alignment: Alignment(-0.8, 0),
            child: Icon(
              FontAwesomeIcons.quoteLeft,
              size: 15,
              color: Colors.purple[100],
            ),
          ),
          Container(
            width: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
          Container(
            alignment: const Alignment(0.8, 0),
            child: Icon(
              FontAwesomeIcons.quoteRight,
              size: 15,
              color: Colors.purple[100],
            ),
          ),
          SizedBox(height: screenAwareSize(10, context)),
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      peerAnswer,
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
                      Colors.pink[100],
                      Colors.white,
                    ],
                  ),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(7.0, 7.0), // shadow direction: bottom right
                    ),
                  ],
//                    border: Border.all(color: Colors.pink[100], width: 2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
