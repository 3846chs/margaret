import 'package:flutter/material.dart';

//화면 비율 맞추기
const double baseHeight = 640.0;
const double baseWidth = 360.0;

double screenAwareHeight(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.height / baseHeight;
}

double screenAwareWidth(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.width / baseWidth;
}
