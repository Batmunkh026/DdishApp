import 'package:flutter/material.dart';

var switchHint = const TextStyle(
    color: const Color(0xffe4f0ff),
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 15.0);

var hintTextStyle = const TextStyle(
    color: const Color(0xffe4f0ff),
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 14.0);

var hintBoldTextStyle = const TextStyle(
    color: const Color(0xffffffff),
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 14.0);

var forgotPasswordHint = new RichText(
    text: new TextSpan(children: [
  new TextSpan(
      style: hintTextStyle,
      text: "- Та нууц кодоо харах бол "),
  new TextSpan(
      style: hintBoldTextStyle,
      text: "139898"),
  new TextSpan(
      style: hintTextStyle,
      text: " дугаарт "),
  new TextSpan(
      style: hintBoldTextStyle,
      text: "KOD "),
  new TextSpan(
      style: hintTextStyle,
      text: "гэж бичин илгээнэ үү. \n- Та нууц кодоо солих бол "),
  new TextSpan(
      style: hintBoldTextStyle,
      text: "139898 "),
  new TextSpan(
      style: hintTextStyle,
      text: "дугаарт "),
  new TextSpan(
      style: hintBoldTextStyle,
      text: "SOLIH "),
  new TextSpan(
      style: hintTextStyle,
      text:
          "гэж бичээд солих нууц кодоо бичин илгээнэ үү. \n- Та админ утасны дугааргүй бол "),
  new TextSpan(
      style: hintBoldTextStyle,
      text: "139898 "),
  new TextSpan(
      style: hintTextStyle,
      text: "дугаар "),
  new TextSpan(
      style: hintBoldTextStyle,
      text: "Help "),
  new TextSpan(
      style: hintTextStyle,
      text:
          "мессеж илгээн админ дугаараа бүртгүүлэх дэлгэрэнгүй зааврыг авна уу")
]));
