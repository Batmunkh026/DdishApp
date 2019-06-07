import 'package:flutter/material.dart';
import 'package:ddish/src/widgets/line.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final bool important;

  CustomDialog({this.title, this.content, this.actions, this.important = false });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(0.0),
      title: Text(title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: const Color(0xfffcfdfe),
              fontWeight: important ? FontWeight.w600 : FontWeight.w400,
              fontFamily: "Montserrat",
              fontStyle: FontStyle.normal,
              fontSize: 15.0)),
      backgroundColor: Color.fromRGBO(103, 170, 255, 0.5),
      children: <Widget>[
        Container(
          child: content,
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        ),
        Divider(
          height: 1.0,
          color: Color(0xFFFFFFFF),
        ),
//        Line(thickness: 1.0, color: Color(0xFFFFFFFF),),
        Container(
          padding: const EdgeInsets.only(bottom: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: actions,
        ))
      ],
    );
  }
}
