import 'package:dating_app/constants/size.dart';
import 'package:dating_app/widgets/send_card.dart';
import 'package:flutter/material.dart';

class SendPage extends StatefulWidget {
  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('보낸 요청'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(common_l_gap),
        child: ListView(
          children: List.generate(15, (index) => SendCard()),
        ),
      ),
    );
  }
}
