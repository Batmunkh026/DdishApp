import 'package:flutter/material.dart';

class Line extends StatelessWidget {
  Color color;
  double thickness;
  EdgeInsets margin;

  Line({this.color = Colors.white, this.thickness = 1.0, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: thickness,
      color: color,
    );
  }
}
