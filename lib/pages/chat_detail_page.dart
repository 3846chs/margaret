import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/message.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:datingapp/firebase/firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatDetailPage extends StatelessWidget {
  final String peerKey;
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  ChatDetailPage({@required this.peerKey});

  void _sendMessage(String chatKey, String myKey, String content) {
    if (content.trim().isNotEmpty) {
      _messageController.clear();

      firestoreProvider.createMessage(
          chatKey,
          Message(
            idFrom: myKey,
            idTo: peerKey,
            content: content,
            timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
            isRead: false,
          ));

      _scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final myUserData = Provider.of<MyUserData>(context, listen: false);
    final myKey = myUserData.userData.userKey;

    final chatKey = myKey.hashCode <= peerKey.hashCode
        ? '$myKey-$peerKey'
        : '$peerKey-$myKey';

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          _buildBubbleList(chatKey, myKey),
          _buildInput(chatKey, myKey),
        ],
      ),
    );
  }

  Widget _buildInput(String chatKey, String myKey) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(common_s_gap),
            child: TextField(
              controller: _messageController,
              decoration: _buildInputDecoration("메시지를 입력해주세요..."),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(common_s_gap),
          child: IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _sendMessage(chatKey, myKey, _messageController.text);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBubbleList(String chatKey, String myKey) {
    return Expanded(
      child: StreamBuilder<List<Message>>(
        stream: firestoreProvider.fetchAllMessages(chatKey),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }

          return ListView(
            controller: _scrollController,
            padding: const EdgeInsets.all(common_gap),
            reverse: true,
            children: snapshot.data
                .map((message) => _buildBubble(myKey, message))
                .toList(),
          );
        },
      ),
    );
  }

  Widget _buildBubble(String myKey, Message message) {
    final isSent = myKey == message.idFrom;
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(message.timestamp));
    final bubble = Container(
      padding: const EdgeInsets.all(common_gap),
      constraints: const BoxConstraints(maxWidth: 200.0),
      decoration: BoxDecoration(
        color: isSent ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(common_gap),
      child: Text(
        message.content,
        style: TextStyle(color: Colors.white),
      ),
    );
    final time = Padding(
      padding: const EdgeInsets.only(bottom: common_gap),
      child: Text(
        DateFormat.jm().format(dateTime),
        style: TextStyle(fontSize: 10.0),
      ),
    );

    if (isSent) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const Spacer(),
          time,
          bubble,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        bubble,
        time,
        const Spacer(),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.lightBlue[300],
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.lightBlue[300],
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      fillColor: Colors.white60,
      filled: true,
    );
  }
}
