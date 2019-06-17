import 'package:flutter/material.dart';

class DetailButton extends StatelessWidget {
  final String text;
  var onTap;

  DetailButton({this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Color(0xFF4e86cb),
      onPressed: onTap,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
      child: Text(text,
          style: const TextStyle(
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 15.0)),
    );
  }
}
