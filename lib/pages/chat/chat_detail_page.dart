import 'dart:io';

import 'package:margaret/constants/firebase_keys.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/message.dart';
import 'package:margaret/data/user.dart';
import 'package:margaret/firebase/firestore_provider.dart';
import 'package:margaret/firebase/storage_provider.dart';
import 'package:margaret/pages/image_page.dart';
import 'package:margaret/utils/prefs_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:margaret/widgets/chat/chat_bubble.dart';

class ChatDetailPage extends StatefulWidget {
  final String chatKey;
  final String myKey;
  final User peer;

  ChatDetailPage(
      {@required this.chatKey, @required this.myKey, @required this.peer});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage>
    with WidgetsBindingObserver {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isNotificationEnabled;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    prefsProvider.initialize().then((_) {
      _messageController.text =
          prefsProvider.getMessage(widget.myKey, widget.peer.userKey);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      prefsProvider.setMessage(
          widget.myKey, widget.peer.userKey, _messageController.text);
    } else {
      _messageController.text =
          prefsProvider.getMessage(widget.myKey, widget.peer.userKey);
    }
  }

  void _sendMessage(String content, MessageType type) {
    if (content.trim().isNotEmpty) {
      _messageController.clear();

      final message = Message(
        idFrom: widget.myKey,
        idTo: widget.peer.userKey,
        content: content,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        isRead: false,
      );

      firestoreProvider.createMessage(widget.chatKey, message);
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
      final url = await storageProvider.uploadImg(image,
          'chats/${DateTime.now().millisecondsSinceEpoch}_${widget.myKey}');
      _sendMessage(url, MessageType.image);
    }
  }

  void _notificationChange() async {
    await prefsProvider.setNotification(
        widget.peer.nickname, !_isNotificationEnabled);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _isNotificationEnabled =
        prefsProvider.isNotificationEnabled(widget.peer.nickname);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.peer.nickname),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isNotificationEnabled
                ? Icons.notifications
                : Icons.notifications_off),
            onPressed: _notificationChange,
          ),
        ],
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
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 100),
              child: TextField(
                controller: _messageController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: _buildInputDecoration("메시지를 입력해주세요..."),
              ),
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
        stream: firestoreProvider.fetchAllMessages(widget.chatKey),
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
      isSent: widget.myKey == message.idFrom,
      onTap: () {
        if (message.type == MessageType.image) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImagePage(message.content)));
        }
      },
      onRead: (key) {
        firestoreProvider.updateMessage(widget.chatKey, key, {
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
