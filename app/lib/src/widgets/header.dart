import 'package:flutter/material.dart';
import 'line.dart';

class Header extends StatelessWidget {
  String title;
  bool backArrowVisible;
  bool hasUnderline;

  Header(
      {this.title, this.backArrowVisible = false, this.hasUnderline = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          Visibility(
            maintainState: true,
            maintainAnimation: true,
            maintainSize: true,
            visible: backArrowVisible,
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xffe4f0ff),
                    size: 20.0,
                  ),
                  onPressed: null),
            ),
          ),
          Visibility(
            maintainState: true,
            maintainAnimation: true,
            maintainSize: true,
            visible: title != null && title.isNotEmpty,
            child: Center(
                child: Text(title,
                    style: const TextStyle(
                        color: const Color(0xffe4f0ff),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.normal,
                        fontSize: 15.0)),
              ),
          ),
          Visibility(
            maintainState: true,
            maintainAnimation: true,
            maintainSize: true,
            visible: hasUnderline,
            child: Line(
                color: Color(0xffe4f0ff),
                thickness: 1.0,
                margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),),
          ),
        ],
      ),
    );
  }
}
