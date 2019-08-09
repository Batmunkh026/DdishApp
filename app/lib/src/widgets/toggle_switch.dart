import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  String hint;
  var onChanged;
  TextStyle style;
  bool value;

  ToggleSwitch({this.hint, this.onChanged, this.style, this.value});

  @override
  State<StatefulWidget> createState() => ToggleSwitchState();
}

class ToggleSwitchState extends State<ToggleSwitch> {
  bool value;
  @override
  Widget build(BuildContext context) {
    value = widget.value;

    return Row(
      children: <Widget>[
        GestureDetector(
          onTapDown: (details) {
            setState((){
              value = !value;
              widget.value = value;
              widget.onChanged(value);
            });
          },
          child: Switch(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            inactiveTrackColor: Colors.grey,
            inactiveThumbColor: Color(0xffffffff),
            value: value,
            activeColor: Color(0xFF5d92d6),
            onChanged: (value) => widget.onChanged(value),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(
            widget.hint,
            style: widget.style,
          ),
        )
      ],
    );
  }
}
