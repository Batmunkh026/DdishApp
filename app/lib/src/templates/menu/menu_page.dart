import 'package:ddish/src/blocs/menu/menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  List<String> menuItems = [
    "Хэрэглэгчийн мэдээлэл",
    "Антен тохируулах заавар",
    "Захиалга өгөх",
    "Мэдээлэл урамшуулах",
    "Салбарын мэдээлэл",
    "7777-1434"
  ];
  MenuBloc _menuBloc;

  @override
  void initState() {
    _menuBloc = MenuBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: menuItems.length,
      itemBuilder: (BuildContext context, int index) {
        return Text(menuItems[index]);
      },
    );
  }

  @override
  void dispose() {
    _menuBloc.dispose();
    super.dispose();
  }
}
