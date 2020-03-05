// Source: https://fireship.io/lessons/flutter-radial-menu-staggered-animations/
// Source: https://github.com/fireship-io/170-flutter-animated-radial-menu

import 'package:flutter/material.dart';
import 'package:margaret/constants/colors.dart';
import 'package:margaret/constants/font_names.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RadialMenu extends StatefulWidget {
  RadialMenu();

  createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 900), vsync: this);
    // ..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return RadialAnimation(controller: controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class RadialAnimation extends StatelessWidget {
  RadialAnimation({Key key, this.controller})
      : translation = Tween<double>(
          begin: 0.0,
          end: 100.0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.elasticOut),
        ),
        scale = Tween<double>(
          begin: 1.5,
          end: 0.0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
        ),
        rotation = Tween<double>(
          begin: 0.0,
          end: 360.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.7,
              curve: Curves.decelerate,
            ),
          ),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> rotation;
  final Animation<double> translation;
  final Animation<double> scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, widget) {
          return Transform.rotate(
              angle: radians(rotation.value),
              child: Stack(alignment: Alignment.center, children: <Widget>[
                _buildButton(context,0,
                    color: Colors.red, icon: FontAwesomeIcons.thumbtack),
                _buildButton(context,72,
                    color: Colors.green, icon: FontAwesomeIcons.sprayCan),
                _buildButton(context,144,
                    color: Colors.orange, icon: FontAwesomeIcons.fire),
                _buildButton(context,216,
                    color: Colors.blue, icon: FontAwesomeIcons.kiwiBird),
                _buildButton(context,288,
                    color: Colors.purpleAccent, icon: FontAwesomeIcons.cat),
                Transform.scale(
                  scale: scale.value - 1,
                  child: FloatingActionButton(
                      heroTag: 'timesCircle',
                      child: Icon(FontAwesomeIcons.timesCircle),
                      onPressed: _close,
                      backgroundColor: Colors.red),
                ),
                Transform.scale(
                  scale: scale.value,
                  child: FloatingActionButton(
                      backgroundColor: pastel_purple,
                      heroTag: 'solidDotCircle',
                      child: Text(
                        'Q',
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: FontFamily.jua,
                            color: Colors.white),
                      ),
                      onPressed: _open),
                )
              ]));
        });
  }

  _open() {
    controller.forward();
  }

  _close() {
    controller.reverse();
  }

  _buildButton(BuildContext context,double angle, {Color color, IconData icon}) {
    final double rad = radians(angle);
    return Transform(
        transform: Matrix4.identity()
          ..translate(
              (translation.value) * cos(rad), (translation.value) * sin(rad)),
        child: FloatingActionButton(
            heroTag: angle.toString(),
            child: Text('결혼'),
            backgroundColor: color,
            onPressed: (){
              return showDialog(
                context: context,
                builder: (context) => Center(
                  child: Container(
                      height: 600, child: _buildRegionDialog(context)),
                ),
              );
            },
            elevation: 10));
  }
  SimpleDialog _buildRegionDialog(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        _simpleDialogOption(context, '싸웠을 때 바로 푸는 편인가요?'),
        _simpleDialogOption(context, '여사친/남사친 허용범위를 알려주세요'),
        _simpleDialogOption(context, '연애와 결혼은 별개인가요?'),
        _simpleDialogOption(context, '연락을 온종일 하는 편인가요? 시간날때 하는 편인가요?'),
        _simpleDialogOption(context, '자기만의 시간이나 공간이 필요한 편인가요?'),
        _simpleDialogOption(context, '화장실 청소를 얼마나 자주 하나요?'),
        _simpleDialogOption(context, '먹는 것에 기쁨을 느끼나요?'),
        _simpleDialogOption(context, '종교를 자기고 있나요?'),
        _simpleDialogOption(context, '반려동물을 키우는 것에 대해 어떻게 생각하나요?'),
        _simpleDialogOption(context, '여행을 즐겨하는 편인가요?'),
        _simpleDialogOption(context, '운동을 즐겨하는 편인가요?'),
        _simpleDialogOption(context, '자존감이 높은 편인가요?'),
        _simpleDialogOption(context, '장거리 연애에 대해 어떻게 생각하나요?'),
      ],
    );
  }


  SimpleDialogOption _simpleDialogOption(
      BuildContext context, String name) {
    return SimpleDialogOption(
      onPressed: () {
        print('ddd');
      },
      child: Center(child: Text('$name')),
    );
  }
}
