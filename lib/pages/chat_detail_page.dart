import 'dart:io';

import 'package:datingapp/constants/firebase_keys.dart';
import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/message.dart';
import 'package:datingapp/data/user.dart';
import 'package:datingapp/firebase/firestore_provider.dart';
import 'package:datingapp/firebase/storage_provider.dart';
import 'package:datingapp/pages/image_page.dart';
import 'package:datingapp/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
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

  Future<void> _sendImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    image = await ImageCropper.cropImage(
      sourcePath: image.path,
      maxWidth: 200,
    );

    if (image != null) {
      final url = await storageProvider.uploadImg(
          image, 'chats/${DateTime.now().millisecondsSinceEpoch}_$myKey');
      _sendMessage(url, MessageType.image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(peer.nickname),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: <Widget>[
            _buildBubbleList(),
            _buildInput(),
          ],
        ),
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
            onPressed: _sendImage,
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

          return Scrollbar(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(common_gap),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final date2 = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(messages[i].timestamp));

                if (i == messages.length - 1) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buildDate(date2),
                      _buildChatBubble(context, messages[i]),
                    ],
                  );
                }

                final date1 = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(messages[i + 1].timestamp));

                if (date1.year != date2.year ||
                    date1.month != date2.month ||
                    date1.day != date2.day) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buildDate(date2),
                      _buildChatBubble(context, messages[i]),
                    ],
                  );
                }

                return _buildChatBubble(context, messages[i]);
              },
            ),
          );
        },
      ),
    );
  }

  ChatBubble _buildChatBubble(BuildContext context, Message message) {
    return ChatBubble(
      message: message,
      isSent: myKey == message.idFrom,
      onTap: () {
        if (message.type == MessageType.image) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImagePage(message.content)));
        }
      },
      onRead: (key) {
        firestoreProvider.updateMessage(chatKey, key, {
          MessageKeys.KEY_ISREAD: true,
        });
      },
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
