import 'package:ddish/src/widgets/line.dart';
import 'package:flutter/material.dart';

class SearchHeader extends StatelessWidget {
  final VoidCallback onReturnTap;

  SearchHeader({this.onReturnTap});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Container(
            height: 40.0,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    iconSize: 25.0,
                    color: Color(0xff3069b2),
                    disabledColor: Color(0xffe8e8e8),
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: onReturnTap,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Хайлтын үр дүн',
                    style: const TextStyle(
                      color: const Color(0xff071f49),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Line(
            color: Color(0xff3069b2),
            thickness: 1.0,
            margin: const EdgeInsets.only(bottom: 10.0, right: 20.0, left: 20.0 ),
          )
        ],
    );
  }
}
