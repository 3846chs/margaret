import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/provider/my_user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatDetailPage extends StatelessWidget {
  final String peerKey;
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  ChatDetailPage({@required this.peerKey});

  void _sendMessage(String chatKey, String myKey, String content) {
    if (content.trim().isNotEmpty) {
      _messageController.clear();

      final reference = Firestore.instance
          .collection('Chats')
          .document(chatKey)
          .collection(chatKey)
          .document(DateTime.now().millisecondsSinceEpoch.toString());
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(reference, {
          'idFrom': myKey,
          'idTo': peerKey,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
        });
      });

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
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Chats')
            .document(chatKey)
            .collection(chatKey)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }

          final messages = snapshot.data.documents;

          return ListView(
            controller: _scrollController,
            padding: const EdgeInsets.all(common_gap),
            reverse: true,
            children: messages
                .map((message) => _buildSendBubble(myKey, message))
                .toList(),
          );
        },
      ),
    );
  }

  Widget _buildSendBubble(String myKey, DocumentSnapshot document) {
    bool isSent = myKey == document['idFrom'];

    final card = Card(
      color: isSent ? Colors.blue : Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Text(
          document['content'],
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    if (isSent) {
      return Row(
        children: <Widget>[
          Spacer(),
          card,
        ],
      );
    }
    return Row(
      children: <Widget>[
        card,
        Spacer(),
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
