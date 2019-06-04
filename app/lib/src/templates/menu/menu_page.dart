import 'package:ddish/src/blocs/menu/menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ddish/src/templates/order/order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ddish/src/blocs/menu/menu_event.dart';
import 'package:ddish/src/blocs/menu/menu_state.dart';
import 'package:ddish/src/blocs/navigation/navigation_bloc.dart';

class MenuPage extends StatefulWidget {
  final NavigationBloc navigationBloc;
  final MenuBloc menuBloc;

  MenuPage({Key key, @required this.navigationBloc, @required this.menuBloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  MenuBloc _menuBloc;
  NavigationBloc _navigationBloc;
  List<Menu> menuItems;
  Order orderWidget;

  @override
  void initState() {
    _menuBloc = widget.menuBloc;
    menuItems = initMenu();
    _navigationBloc = widget.navigationBloc;
    super.initState();
  }

  @override
  void dispose() {
    _menuBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 80.0),
      child: BlocProvider(
        bloc: _menuBloc,
        child: BlocBuilder<MenuEvent, MenuState>(
            bloc: _menuBloc,
            builder: (BuildContext context, MenuState state) {
              if (state is ChildMenuOpened && state.menu.screen != null) {
                return state.menu.screen;
              }
              if (state is MenuOpened || state is MenuInitial) {
                return ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          _buildMenuItem(menuItems[index], true),
                          Container(
                            margin:
                            EdgeInsetsDirectional.only(start: 15.0, end: 15.0),
                            height: 1.0,
                            color: Color(0xFF3069b2),
                          ),
                        ],
                      );
                    },
                  );
              }
            }),
      ),
    );
  }

  Widget _buildMenuItem(Menu menu, bool root) {
    bool expanded = false;
    if (menu.children == null || menu.children.isEmpty)
      return ListTile(
        contentPadding: root ? null : const EdgeInsets.only(left: 30.0),
        title: _buildTitle(menu.title),
        onTap: () => onMenuTap(menu),
      );
    return ExpansionTile(
      onExpansionChanged: (v) => expanded = v,
      key: PageStorageKey<Menu>(menu),
      trailing: SizedBox.shrink(),
      title: _buildTitle(menu.title),
      children: menu.children.map((m) => _buildMenuItem(m, false)).toList(),
    );
  }

  onMenuTap(Menu menu) {
    _menuBloc.dispatch(MenuClicked(selectedMenu: menu));
  }

  _buildTitle(String title) {
    return Container(
      color:  null,
      child: Text(
        title,
        style: TextStyle(
            color: Color(0xFFe4f0ff),
            fontWeight: FontWeight.w400,
            fontFamily: "Montserrat",
            fontStyle: FontStyle.normal,
            fontSize: 15.0),
      ),
    );
  }

  List initMenu() {
    List<Menu> menuItems = <Menu>[
      Menu(
        title: 'Антен тохируулах заавар',
        screen: null,
        children: <Menu>[
          Menu(title: 'Зурган заавар', screen: Order('Зурган заавар')),
          Menu(title: 'Видео заавар', screen: Order('Видео заавар'))
        ],
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

    return menuItems;
  }
}

class Menu {
  Menu({this.title, this.screen, this.children});

  String title;
  Widget screen;
  List<Menu> children = const <Menu>[];
}
