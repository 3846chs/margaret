import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/message.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/firebase/firestore_provider.dart';
import 'package:datingapp/firebase/storage_provider.dart';
import 'package:datingapp/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatDetailPage extends StatelessWidget {
  final String chatKey;
  final String myKey;
  final User peer;
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  ChatDetailPage(
      {@required this.chatKey, @required this.myKey, @required this.peer});

  void _sendMessage(String content, MessageType type) {
    if (content.trim().isNotEmpty) {
      _messageController.clear();

      final message = Message(
        idFrom: myKey,
        idTo: peer.userKey,
        content: content,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
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
          _buildBubbleList(),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(common_s_gap),
          child: IconButton(
            icon: const Icon(Icons.image),
            onPressed: () async {
              final image =
                  await ImagePicker.pickImage(source: ImageSource.gallery);

              if (image != null) {
                final url = await storageProvider.uploadImg(image,
                    'chats/${DateTime.now().millisecondsSinceEpoch}_$myKey');
                _sendMessage(url, MessageType.image);
              }
            },
          ),
        ),
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
                _sendMessage(_messageController.text, MessageType.text),
          ),
        ),
      ],
    );
  }

  Widget _buildBubbleList() {
    return Expanded(
      child: StreamBuilder<List<Message>>(
        stream: firestoreProvider.fetchAllMessages(chatKey),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }

          final messages = snapshot.data;
          final children = <Widget>[];

          for (int i = 0; i < messages.length; i++) {
            final date2 = DateTime.fromMillisecondsSinceEpoch(
                int.parse(messages[i].timestamp));

            children.add(ChatBubble(
              message: messages[i],
              isSent: myKey == messages[i].idFrom,
              onRead: (key) => firestoreProvider.setMessageRead(chatKey, key),
            ));

            if (i == messages.length - 1) {
              children.add(_buildDate(date2));
            } else {
              final date1 = DateTime.fromMillisecondsSinceEpoch(
                  int.parse(messages[i + 1].timestamp));

              if (date1.year != date2.year ||
                  date1.month != date2.month ||
                  date1.day != date2.day) {
                children.add(_buildDate(date2));
              }
            }
          }

          return ListView(
            controller: _scrollController,
            padding: const EdgeInsets.all(common_gap),
            reverse: true,
            children: children,
          );
        },
      ),
    );
  }

  Widget _buildDate(DateTime date) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.black26,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: common_gap,
          vertical: common_s_gap,
        ),
        child: Text(
          DateFormat.yMEd().format(date),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
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