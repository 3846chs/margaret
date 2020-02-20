import 'package:cached_network_image/cached_network_image.dart';
import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/message.dart';
import 'package:datingapp/firebase/storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isSent;
  final Function(String) onRead;

  ChatBubble(
      {@required this.message, @required this.isSent, @required this.onRead});

  @override
  Widget build(BuildContext context) {
    if (isSent) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const Spacer(),
          message.isRead ? const SizedBox.shrink() : _buildHeart(),
          _buildTime(),
          _buildBubble(),
        ],
      );
    }

    if (!message.isRead && ModalRoute.of(context).isCurrent)
      onRead(message.timestamp);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _buildBubble(),
        _buildTime(),
        const Spacer(),
      ],
    );
  }

  Widget _buildHeart() {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: const Icon(
        Icons.favorite,
        color: Colors.red,
        size: 16.0,
      ),
    );
  }

  Widget _buildTime() {
    return Padding(
      padding: const EdgeInsets.only(bottom: common_gap),
      child: Text(
        DateFormat.jm().format(
            DateTime.fromMillisecondsSinceEpoch(int.parse(message.timestamp))),
        style: const TextStyle(fontSize: 10.0),
      ),
    );
  }

  Widget _buildBubble() {
    return Container(
      padding: const EdgeInsets.all(common_gap),
      constraints: const BoxConstraints(maxWidth: 200.0),
      decoration: BoxDecoration(
        color: isSent ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(common_gap),
      child: message.type == MessageType.text
          ? Text(
              message.content,
              style: const TextStyle(color: Colors.white),
            )
          : FutureBuilder<String>(
              future: storageProvider.getImageUri(message.content),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: const CircularProgressIndicator(),
                  );
                return CachedNetworkImage(
                  imageUrl: snapshot.data,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                );
              },
            ),
    );
  }
}
