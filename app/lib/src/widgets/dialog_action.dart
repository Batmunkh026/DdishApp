import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  String title;
  var onTap;

  ActionButton({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Text(title,
          style: TextStyle(
            color:  const Color(0xffe8e8e8),
            fontWeight: FontWeight.w500,
            fontFamily: "Montserrat",
            fontStyle:  FontStyle.normal,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}