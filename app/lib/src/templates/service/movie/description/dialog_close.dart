import 'package:flutter/material.dart';

class DialogCloseButton extends StatelessWidget {
  var onTap;

  DialogCloseButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Icon(
          Icons.close,
          color: Color(0xffffffff),
          size: 40.0,
        ),
      ),
    );
  }
}
