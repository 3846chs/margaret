import 'package:dating_app/constants/size.dart';
import 'package:dating_app/widgets/receive_card.dart';
import 'package:flutter/material.dart';

class ReceivePage extends StatefulWidget {
  @override
  _ReceivePageState createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          '받은 요청',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(common_l_gap),
        child: ListView(
          children: List.generate(15, (index) => ReceiveCard()),
        ),
      ),
    );
  }
}
