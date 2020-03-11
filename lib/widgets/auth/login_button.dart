import 'dart:async';

import 'package:flutter/material.dart';
import 'package:margaret/utils/adjust_size.dart';

class LoginButton extends StatefulWidget {
  final Color color;
  final Color iconColor;
  final String text;
  final IconData icon;
  final FutureOr<void> Function() onPressed;

  LoginButton(
      {@required this.color,
      this.iconColor,
      @required this.text,
      this.icon,
      this.onPressed});

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool _isProgress = false;

  void setProgressState(bool isProgress) {
    setState(() {
      _isProgress = isProgress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(
        vertical: screenAwareHeight(10.0, context),
        horizontal: 10.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      color: widget.color,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth * 2 / 3,
            height: screenAwareHeight(20, context),
            child: Stack(
              overflow: Overflow.visible,
              alignment: Alignment.center,
              children: <Widget>[
//                Positioned(
//                  left: 0.0,
//                  child: Container(
//                    decoration: BoxDecoration(
//                      shape: BoxShape.circle,
//                      color: Colors.white,
//                    ),
//                    child: Padding(
//                      padding: EdgeInsets.all(screenAwareSize(5.0, context)),
//                      child: Icon(
//                        icon,
//                        color: iconColor ?? color,
//                        size: screenAwareSize(15.0, context),
//                      ),
//                    ),
//                  ),
//                ),
                _isProgress
                    ? Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: const CircularProgressIndicator(),
                        ),
                      )
                    : Text(
                        widget.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ],
            ),
          );
        },
      ),
      onPressed: _isProgress
          ? () {}
          : () async {
              setProgressState(true);
              await widget.onPressed();
              setProgressState(false);
            },
    );
  }
}
