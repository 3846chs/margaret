import 'package:margaret/widgets/send_card.dart';
import 'package:flutter/material.dart';

class SendPage extends StatefulWidget {
  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) {
          return InkWell(
            child: SendCard(),
            onTap: () {},
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(height: 1);
        },
      ),
    );
  }
}
