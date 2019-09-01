import 'package:ddish/presentation/ddish_flutter_app_icons.dart';
import 'package:flutter/material.dart';

class DialogCloseButton extends StatelessWidget {
  var onTap;
  double size;

  DialogCloseButton({this.size = 40.0, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Icon(
          Icons.close,
          color: Color(0xffffffff),
          size: size,
        ),
      ),
    );
  }
}
