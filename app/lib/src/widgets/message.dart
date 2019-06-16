import 'package:flutter/material.dart';

enum SnackBarType { INFO, ERROR, WARNING, SUCCESS }

List<Color> colorList = [
  Color(0xFF79C4E0),
  Color(0xADDF0B0B),
  Color(0xFFf4bf42),
  Color(0xFF84ce77)
];

void show(BuildContext context, String message, SnackBarType type) {
  Color backgroundColor = colorList[type.index];
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor,
  ));
}

void showUsingKey(
    GlobalKey<ScaffoldState> scaffoldKey, String message, SnackBarType type) {
  Color backgroundColor = colorList[type.index];
  scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor,
  ));
}
