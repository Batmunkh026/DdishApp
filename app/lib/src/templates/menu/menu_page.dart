import 'package:ddish/src/blocs/menu/menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ddish/src/templates/order/order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ddish/src/blocs/menu/menu_event.dart';
import 'package:ddish/src/blocs/menu/menu_state.dart';
import 'package:ddish/src/blocs/navigation/navigation_bloc.dart';

class MenuPage extends StatefulWidget {
  final NavigationBloc navigationBloc;

  MenuPage({Key key, @required this.navigationBloc}) : super(key: key);
  @override
  State<StatefulWidget> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  MenuBloc menuBloc;
  NavigationBloc _navigationBloc;
  List<Menu> menuItems = <Menu>[
    Menu(
      title: 'Антен тохируулах заавар', screen :null,
      children: <Menu>[Menu(title:'Зурган заавар', screen: Order('Зурган заавар')), Menu(title: 'Видео заавар', screen: Order('Видео заавар'))],
    ),
    Menu(
      title: 'Захиалга өгөх',
      children: <Menu>[
        Menu(title: 'Антен тохируулах захиалга өгөх'),
        Menu(title: 'Шинэ хэрэглэгчийн захиалга өгөх')
      ],
    ),
    Menu(
      title: 'Мэдээ урамшуулах',
    ),
    Menu(
      title: 'Салбарын мэдээлэл',
    ),
    Menu(
      title: '7777-1434',
    ),
  ];
  Order orderWidget;

  @override
  void initState() {
    menuBloc = MenuBloc();
    _navigationBloc = widget.navigationBloc;
    super.initState();
  }

  @override
  void dispose() {
    menuBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: menuBloc,
      child: BlocBuilder<MenuEvent, MenuState>(
        bloc: menuBloc,
        builder: (BuildContext context, MenuState state) {
          if(state is MenuOpened && state.menu.screen != null) {
            return state.menu.screen;
          }
          if(state is MenuInitial) {
            return ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (BuildContext context, int index) =>
                  _buildMenuItem(menuItems[index]),
            );
          }
        }),
    );
  }

  Widget _buildMenuItem(Menu menu) {
    if (menu.children == null || menu.children.isEmpty)
      return ListTile(
        title: _buildTitle(menu.title),
        onTap: () => onMenuTap(menu),
      );
    return ExpansionTile(
      key: PageStorageKey<Menu>(menu),
      trailing: SizedBox.shrink(),
      title: _buildTitle(menu.title),
      children: menu.children.map(_buildMenuItem).toList(),
    );
  }

  onMenuTap(Menu menu) {
    _navigationBloc.dispatch(NavigationEvent.INACTIVE);
    menuBloc.dispatch(MenuClicked(selectedMenu: menu));
  }
  _buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
//                color: const Color(0xffe4f0ff),
          color: Colors.indigoAccent,
          fontWeight: FontWeight.w400,
          fontFamily: "Montserrat",
          fontStyle: FontStyle.normal,
          fontSize: 15.0),
    );
  }
}

class Menu {
  Menu({this.title, this.screen, this.children});

  String title;
  Widget screen;
  List<Menu> children = const <Menu>[];
}
