import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final User peer;
  final String lastMessage;

  ChatCard({@required this.peer, @required this.lastMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(common_gap),
            child: UserAvatar(user: peer),
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
                      peer.nickname,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(common_s_gap),
                    child: Text(
                      lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
