import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  ActionButton({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.6,
        alignment: Alignment.center,
        child: title != null
            ? Text(
                title,
                style: TextStyle(
                  color: const Color(0xffe8e8e8),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0,
                ),
              )
            : Icon(
                Icons.close,
                color: Color(0xffffffff),
                size: 30.0,
              ),
      ),
    );
  }
}
