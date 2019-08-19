import 'package:flutter/material.dart';
mixin MenuAccessible{
  Function onBack;

  bool hasBackState = false;
}
class Menu {
  Menu(
      {this.title,
        this.screen,
        this.children,
        this.secure = false,
        this.trailing, this.event});

  String title;
  Widget screen;
  bool secure;
  Widget trailing;
  List<Menu> children = const <Menu>[];
  Function event;
}
