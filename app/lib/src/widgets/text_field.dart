import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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
  var onFieldSubmitted;
  var textController;
  bool hasBorder;
  Key key;
  TextAlign align;
  EdgeInsets padding;
  List<TextInputFormatter> inputFormatters;
  final bool hasClearButton;
  final VoidCallback onClear;

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
      this.fontSize,
      this.onSaved,
      this.textController,
      this.hasBorder = false,
      this.align = TextAlign.start,
      this.padding,
      this.inputFormatters,
      this.onFieldSubmitted,
      this.hasClearButton = false,
      this.onClear});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (new Container(
      padding: padding,
      margin: new EdgeInsets.only(
          bottom: bottomMargin == null ? 0.0 : bottomMargin),
      child: new TextFormField(
        initialValue: initialValue,
        enabled: true,
        style: TextStyle(
          color: hasBorder ? Color(0xFF071f49) : Color(0xffe8e8e8),
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: fontSize,
        ),
        key: key,
        obscureText: obscureText,
        keyboardType: textInputType,
        validator: validateFunction,
        onSaved: onSaved,
        onFieldSubmitted: onFieldSubmitted,
        controller: textController,
        textAlign: align,
        inputFormatters: inputFormatters,
        decoration: new InputDecoration(
          enabledBorder: hasBorder
              ? null
              : UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
          border: hasBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                )
              : null,
          contentPadding: const EdgeInsets.only(bottom: 5.0, top: 10.0),
          hintText: placeholder,
          hintStyle: TextStyle(
            color: hasBorder ? Color(0xFF071f49) : Color(0xffa4cafb),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: fontSize,
          ),
        ),
      ),
    ));
  }
}
