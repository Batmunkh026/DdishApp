import 'package:flutter/material.dart';

class Menu {
  Menu(
      {this.title,
        this.screen,
        this.children,
        this.secure = false,
        this.trailing});

  String title;
  Widget screen;
  bool secure;
  Widget trailing;
  List<Menu> children = const <Menu>[];
}
