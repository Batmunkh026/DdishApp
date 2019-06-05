import 'package:flutter/material.dart';
import 'package:ddish/src/widgets/line.dart';

class CustomDialog extends StatelessWidget {
  String title;
  Widget content;
  List<Widget> actions;

  CustomDialog({this.title, this.content, this.actions});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(0.0),
      title: Text(title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: const Color(0xfffcfdfe),
              fontWeight: FontWeight.w400,
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
