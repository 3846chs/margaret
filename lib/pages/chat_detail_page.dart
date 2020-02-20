import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/message.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/firebase/firestore_provider.dart';
import 'package:datingapp/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';

class ChatDetailPage extends StatelessWidget {
  final String chatKey;
  final String myKey;
  final User peer;
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  ChatDetailPage(
      {@required this.chatKey, @required this.myKey, @required this.peer});

  void _sendMessage(String chatKey, String myKey, String content) {
    if (content.trim().isNotEmpty) {
      _messageController.clear();

      final message = Message(
        idFrom: myKey,
        idTo: peer.userKey,
        content: content,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        isRead: false,
      );

      firestoreProvider.createMessage(chatKey, message);
      _scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(peer.nickname),
      ),
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
            onPressed: () =>
                _sendMessage(chatKey, myKey, _messageController.text),
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
                .map((message) => ChatBubble(myKey: myKey, message: message))
                .toList(),
          );
        },
      ),
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
