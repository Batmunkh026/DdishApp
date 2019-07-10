import 'package:flutter/material.dart';

class UnderlinedText extends StatelessWidget {
  String _title;
  TextStyle textStyle;
  Color underlineColor;
  double underlineWidth;

  UnderlinedText(this._title,
      {this.textStyle = const TextStyle(fontSize: 13),
        this.underlineWidth = 2,
        this.underlineColor = const Color.fromRGBO(48, 105, 178, 1)});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "$_title",
        style: textStyle,
      ),
      padding: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          border: Border(
              bottom:
              BorderSide(color: underlineColor, width: underlineWidth))),
    );
  }
}