import 'package:flutter/material.dart';

void simpleSnackbar(BuildContext context, String txt) {
  final snackBar = SnackBar(
    content: Text(txt),
    duration: Duration(seconds: 1),
  );
  Scaffold.of(context).showSnackBar(snackBar);
}
