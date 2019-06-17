import 'package:flutter/material.dart';
import 'package:ddish/src/widgets/line.dart';

class CustomDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> actions;
  final bool important;
  final bool hasDivider;
  final EdgeInsets padding;

  CustomDialog(
      {this.title,
      this.content,
      this.actions,
      this.important = false,
      this.hasDivider = true,
      this.padding = const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0)});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: const EdgeInsets.all(0.0),
      title: title,
      backgroundColor: Color.fromRGBO(103, 170, 255, 0.5),
      children: <Widget>[
        Container(
          child: content,
          padding: padding,
        ),
        Visibility(
          child: Divider(
            height: 1.0,
            color: Color(0xFFFFFFFF),
          ),
          visible: hasDivider,
        ),
//        Line(thickness: 1.0, color: Color(0xFFFFFFFF),),
        actions == null ? Container() : Container(
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
