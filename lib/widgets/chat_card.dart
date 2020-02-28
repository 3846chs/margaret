import 'package:margaret/constants/size.dart';
import 'package:margaret/data/message.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatCard extends StatelessWidget {
  final User peer;
  final Message lastMessage;
  final int newCount;
  final VoidCallback onTap;
  final VoidCallback onProfileTap;

  ChatCard(
      {@required this.peer,
      @required this.lastMessage,
      this.newCount,
      this.onTap,
      this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    String subtitle = '';

    if (lastMessage != null) {
      subtitle = lastMessage.type == MessageType.text
          ? lastMessage.content
          : '사진을 보냈습니다.';
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: onProfileTap,
              child: Padding(
                padding: const EdgeInsets.all(common_gap),
                child: UserAvatar(user: peer),
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
                      child: Text(peer.nickname),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(common_s_gap),
                      child: Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black45),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(common_gap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(common_s_gap),
                    child: Text(
                      lastMessage == null
                          ? ''
                          : DateFormat.jm().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(lastMessage.timestamp))),
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: newCount > 0,
                    maintainAnimation: true,
                    maintainSize: true,
                    maintainState: true,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      margin: const EdgeInsets.all(common_s_gap),
                      child: Text(
                        newCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
