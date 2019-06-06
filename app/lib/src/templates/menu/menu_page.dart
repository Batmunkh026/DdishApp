import 'package:ddish/src/blocs/menu/menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ddish/src/templates/order/order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ddish/src/blocs/menu/menu_event.dart';
import 'package:ddish/src/blocs/menu/menu_state.dart';
import 'package:ddish/src/widgets/line.dart';
import 'package:ddish/src/widgets/header.dart';

class MenuPage extends StatefulWidget {
  var onBackButtonTap;

  MenuPage({Key key, this.onBackButtonTap}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  bool authenticated;
  MenuBloc _menuBloc;
  List<Menu> menuItems;

  @override
  void initState() {
    authenticated = widget.onBackButtonTap == null;
    _menuBloc = MenuBloc();
    menuItems = initMenu();
    super.initState();
  }

  @override
  void dispose() {
    _menuBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocProvider(
        bloc: _menuBloc,
        child: BlocBuilder<MenuEvent, MenuState>(
            bloc: _menuBloc,
            builder: (BuildContext context, MenuState state) {
              if (state is ChildMenuOpened && state.menu.screen != null) {
                return Column(
                  children: <Widget>[
                    Header(
                      title: state.menu.title,
                      onBackPressed: () =>
                          _menuBloc.dispatch(MenuNavigationClicked()),
                    ),
                    state.menu.screen
                  ],
                );
              } else if (state is MenuOpened || state is MenuInitial) {
                return Column(
                  children: <Widget>[
                    Visibility(
                      maintainState: true,
                      maintainAnimation: true,
                      maintainSize: true,
                      visible: !authenticated,
                      child: Header(onBackPressed: widget.onBackButtonTap),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: menuItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          var menuItem = _buildMenuItem(menuItems[index], true);
                          return Column(
                            children: <Widget>[
                              menuItem != null ? menuItem : Container(),
                              Visibility(
                                visible: menuItem != null,
                                child: Line(
                                  color: Color(0xFF3069b2),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  thickness: 1.0,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    )
                  ],
                );
              } else
                return Container();
            }),
      ),
    );
  }

  Widget _buildMenuItem(Menu menu, bool root) {
    if (menu.children == null || menu.children.isEmpty) {
      if (menu.secure && !authenticated) return null;
      return ListTile(
        trailing: menu.trailing,
        contentPadding: root ? null : const EdgeInsets.only(left: 30.0),
        title: _buildTitle(menu.title),
        onTap: () => onMenuTap(menu),
      );
    }
    return ExpansionTile(
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
      color: null,
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
        title: 'Хэрэглэгчийн мэдээлэл',
        screen: Container(),
        secure: true,
      ),
      Menu(
        title: 'Антен тохируулах заавар',
        screen: Container(),
        children: <Menu>[
          Menu(
            title: 'Зурган заавар',
            screen: Container(),
          ),
          Menu(
            title: 'Видео заавар',
            screen: Container(),
          )
        ],
      ),
      Menu(
        title: 'Захиалга өгөх',
        children: <Menu>[
          Menu(
              title: 'Антен тохируулах захиалга өгөх',
              screen: Order('Антен тохируулах')),
          Menu(
              title: 'Шинэ хэрэглэгчийн захиалга өгөх',
              screen: Order('Шинэ хэрэглэгч'))
        ],
      ),
      Menu(
        title: 'Мэдээ урамшуулал',
        screen: Container(),
      ),
      Menu(
        title: 'Салбарын мэдээлэл',
        screen: Container(),
      ),
      Menu(
        title: '7777-1434',
      ),
      Menu(
          title: 'Гарах',
          secure: true,
          trailing: Icon(
            Icons.exit_to_app,
            color: Colors.white,
          )),
    ];

    return menuItems;
  }
}

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
