import 'package:flutter/material.dart';
import 'line.dart';

class Header extends StatelessWidget {
  final String title;
  final VoidCallback onBackPressed;

  Header({this.title, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xffe4f0ff),
                  size: 20.0,
                ),
                onPressed: onBackPressed),
          ),
          Visibility(
            visible: title != null && title.isNotEmpty,
            child: Center(
              child: Text(title != null && title.isNotEmpty ? title : '',
                  style: const TextStyle(
                      color: const Color(0xffe4f0ff),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0)),
            ),
          ),
          Visibility(
            visible: title != null && title.isNotEmpty,
            child: Line(
              color: Color(0xff3069b2),
              thickness: 1.0,
              margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            ),
          ),
        ],
      ),
    );
  }
}
