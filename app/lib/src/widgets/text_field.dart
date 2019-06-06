import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  String initialValue;
  String placeholder;
  Color textFieldColor;
  TextInputType textInputType;
  bool obscureText;
  double bottomMargin;
  double fontSize;
  var validateFunction;
  var onSaved;
  var textController;
  Key key;

  //passing props in the Constructor.
  //Java like style
  InputField(
      {this.key,
        this.initialValue,
        this.placeholder,
        this.textFieldColor,
        this.obscureText = false,
        this.textInputType,
        this.bottomMargin,
        this.validateFunction,
        this.onSaved,
        this.textController,});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (new Container(
        margin: new EdgeInsets.only(bottom: bottomMargin == null ? 0.0 : bottomMargin),
        child: new TextFormField(
            initialValue: initialValue,
            enabled: true,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontFamily: "Montserrat",
              fontStyle:  FontStyle.normal,
              fontSize: fontSize,
            ),
            key: key,
            obscureText: obscureText,
            keyboardType: textInputType,
            validator: validateFunction,
            onSaved: onSaved,
            controller: textController,
            decoration: new InputDecoration(
              contentPadding: const EdgeInsets.only(bottom: 5.0, top: 10.0),
              hintText: placeholder,
              hintStyle: TextStyle(
                color: Color(0xffe8e8e8),
                fontWeight: FontWeight.w400,
                fontFamily: "Montserrat",
                fontStyle:  FontStyle.normal,
                fontSize: fontSize,
              ),
            ),
          ),
        ));
  }
}
