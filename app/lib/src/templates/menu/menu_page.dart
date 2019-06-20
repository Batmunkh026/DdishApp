import 'package:ddish/src/blocs/menu/menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ddish/src/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ddish/src/blocs/menu/menu_event.dart';
import 'package:ddish/src/blocs/menu/menu_state.dart';
import 'package:ddish/src/widgets/line.dart';
import 'package:ddish/src/widgets/header.dart';
import 'menu.dart';
import 'package:ddish/src/widgets/menu_expansion_tile.dart';

class MenuPage extends StatefulWidget {
  final VoidCallback onBackButtonTap;

  MenuPage({Key key, this.onBackButtonTap}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  bool authenticated;
  MenuBloc _menuBloc;
  List<Menu> menuItems;
  List<GlobalKey<MenuExpansionTileState>> expansionTileKeys;

  @override
  void initState() {
    authenticated = widget.onBackButtonTap == null;
    _menuBloc = MenuBloc();
    this.menuItems = Constants.menuItems;
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
      resizeToAvoidBottomPadding: false,
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
                expansionTileKeys = List();
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
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                child: menuItem != null ? menuItem : Container(),
                              ),
                              Visibility(
                                visible: menuItem != null,
                                child: Line(
                                  color: Color(0xFF3069b2),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 25.0),
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
        trailing: Padding(
          padding: const EdgeInsets.only(right: 25.0),
          child: menu.trailing,
        ),
        contentPadding: root ? null : const EdgeInsets.only(left: 30.0),
        title: _buildTitle(menu.title),
        onTap: () => menu.screen == null && menu.event != null ? Future(menu.event) : onMenuTap(menu),
      );
    }
    GlobalKey<MenuExpansionTileState> _key = new GlobalKey();
    expansionTileKeys.add(_key);
    return MenuExpansionTile(
      key: _key,
      trailing: SizedBox.shrink(),
      title: _buildTitle(menu.title),
      children: menu.children.map((m) => _buildMenuItem(m, false)).toList(),
      onExpansionChanged: (expanded) {
        if(expanded) {
          expansionTileKeys.where((key) => key != _key).forEach((key) => key.currentState.collapse());
        }
      },
    );
  }

  onMenuTap(Menu menu) {
    if (menu.title == 'Гарах') {
      Navigator.of(context).pop();
    } else
      _menuBloc.dispatch(MenuClicked(selectedMenu: menu));
  }

  _buildTitle(String title) {
    return Container(
      child: Text(
        title,
        style: TextStyle(
            color: Color(0xFFe4f0ff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 15.0),
      ),
    );
  }
}
