import 'package:ddish/src/blocs/menu/menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MenuPageState();

}
class MenuPageState extends State<MenuPage>{

  MenuBloc _menuBloc;

  @override
  void initState() {
    _menuBloc = BlocProvider.of<MenuBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("menu"),);
  }

  @override
  void dispose() {
    _menuBloc.dispose();
    super.dispose();
  }
}