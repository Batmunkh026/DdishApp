import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  String text;
  var onPressed;
  double verticalMargin;
  double horizontalMargin;

  SubmitButton({
    this.text,
    this.onPressed,
    this.verticalMargin,
    this.horizontalMargin,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Color(0xFF318aff),
      padding: EdgeInsets.symmetric(
          vertical: verticalMargin, horizontal: horizontalMargin),
      onPressed: onPressed,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
      child: Text(text,
          style: const TextStyle(
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w400,
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 15.0)),
    );
  }
}
