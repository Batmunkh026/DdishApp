import 'package:ddish/src/blocs/menu/menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ddish/src/templates/order/order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ddish/src/blocs/menu/menu_event.dart';
import 'package:ddish/src/blocs/menu/menu_state.dart';

class MenuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  MenuBloc menuBloc;

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
    super.initState();
  }

  @override
  void disponse() {
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
        onTap: () => menuBloc.dispatch(MenuClicked(selectedMenu: menu)),
      );
    return ExpansionTile(
      key: PageStorageKey<Menu>(menu),
      trailing: SizedBox.shrink(),
      title: _buildTitle(menu.title),
      children: menu.children.map(_buildMenuItem).toList(),
    );
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
