import 'package:flutter/material.dart';

class Line extends StatelessWidget {
  final Color color;
  final double thickness;
  final EdgeInsets margin;

  Line({this.color = Colors.red, this.thickness = 1.0, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: thickness,
      color: color,
    );
  }
}
