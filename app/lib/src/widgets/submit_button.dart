import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  String text;
  var onPressed;
  double verticalMargin;
  double horizontalMargin;
  EdgeInsets padding;

  SubmitButton({
    this.text,
    this.onPressed,
    this.verticalMargin = 0.0,
    this.horizontalMargin = 0.0,
    this.padding = const EdgeInsets.all(0.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: RaisedButton(
        color: Color(0xFF318aff),
        padding: EdgeInsets.symmetric(
            vertical: verticalMargin, horizontal: horizontalMargin),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0)),
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }
}
