import 'package:cached_network_image/cached_network_image.dart';
import 'package:datingapp/constants/size.dart';
import 'package:datingapp/data/message.dart';
import 'package:datingapp/firebase/storage_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatefulWidget {
  final Message message;
  final bool isSent;
  final Function(String) onRead;

  ChatBubble(
      {@required this.message, @required this.isSent, @required this.onRead});

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.isSent) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const Spacer(),
          _buildHeart(),
          _buildTime(),
          _buildBubble(),
        ],
      );
    }

    if (!widget.message.isRead && ModalRoute.of(context).isCurrent)
      widget.onRead(widget.message.timestamp);

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
    return Visibility(
      visible: !widget.message.isRead,
      child: Padding(
        padding: const EdgeInsets.all(common_gap),
        child: const Icon(
          Icons.favorite,
          color: Colors.red,
          size: 16.0,
        ),
      ),
    );
  }

  Widget _buildTime() {
    return Padding(
      padding: const EdgeInsets.only(bottom: common_gap),
      child: Text(
        DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
            int.parse(widget.message.timestamp))),
        style: const TextStyle(fontSize: 10.0),
      ),
    );
  }

  Widget _buildBubble() {
    return Container(
      padding: widget.message.type == MessageType.text
          ? const EdgeInsets.all(common_gap)
          : null,
      constraints: const BoxConstraints(maxWidth: 200.0),
      decoration: BoxDecoration(
        color: widget.isSent ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(common_gap),
      child: widget.message.type == MessageType.text
          ? Text(
              widget.message.content,
              style: const TextStyle(color: Colors.white),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: CachedNetworkImage(
                imageUrl: widget.message.content,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image),
                cacheManager: StorageCacheManager(),
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
