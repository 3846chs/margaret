import 'package:margaret/utils/base_height.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Color color;
  final Color iconColor;
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  LoginButton(
      {@required this.color,
      this.iconColor,
      @required this.text,
      this.icon,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(
        vertical: screenAwareSize(10.0, context),
        horizontal: 10.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      color: color,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth * 2 / 3,
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
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
      onPressed: onPressed ?? () {},
    );
  }
}