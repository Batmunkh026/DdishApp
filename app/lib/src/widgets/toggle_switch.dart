import 'package:flutter/material.dart';

class ToggleSwitch extends StatelessWidget {
  String hint;
  var onChanged;
  TextStyle style;
  bool value;

  ToggleSwitch({
    this.hint,
    this.onChanged,
    this.style,
    this.value
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Switch(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          inactiveTrackColor: Colors.grey,
          inactiveThumbColor: Color(0xffffffff),
          value: value,
          activeColor: Color(0xFF5d92d6),
          onChanged: onChanged,
        ),
        Text(
          hint,
          style: style,
        )
      ],
    );
  }
}
