import 'package:cached_network_image/cached_network_image.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/size.dart';
import 'package:margaret/data/message.dart';
import 'package:margaret/firebase/storage_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatefulWidget {
  final Message message;
  final bool isSent;
  final VoidCallback onTap;
  final Function(String) onRead;

  ChatBubble(
      {@required this.message, @required this.isSent, this.onTap, this.onRead});

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.message.idFrom == "bot") {
      return Center(
        child: _buildBubble(Colors.grey[400]),
      );
    }

    if (widget.isSent) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const Spacer(),
          _buildHeart(),
          _buildTime(),
          _buildBubble(Color(0xffffaabb)),
        ],
      );
    }

    if (!widget.message.isRead && ModalRoute.of(context).isCurrent)
      widget.onRead(widget.message.timestamp);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _buildBubble(pastel_purple),
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

  Widget _buildBubble(Color color) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(common_gap),
      child: widget.message.type == MessageType.text
          ? _buildTextBubble()
          : _buildImageBubble(),
    );
  }

  Widget _buildImageBubble() {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: CachedNetworkImage(
            imageUrl: widget.message.content,
            cacheManager: StorageCacheManager(),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextBubble() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(common_gap),
          child: Text(
            widget.message.content,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
