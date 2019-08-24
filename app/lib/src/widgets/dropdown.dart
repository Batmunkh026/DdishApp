import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

typedef void Select<T>(T selectedValue);
typedef Widget ChildWidgetMap<T>(T value);

class Selector<T> extends StatefulWidget {
  final List<T> items;

  ///анхны утга, null байж болохгүй
  T initialValue;
  final Select<T> onSelect;

  ///тухайн item ыг харуулах widget template
  final ChildWidgetMap<T> childMap;

  bool visibleChildren = false;

  Selector({
    @required this.items,
    @required this.initialValue,
    @required this.onSelect,
    @required this.childMap,
  });

  @override
  State<StatefulWidget> createState() => SelectorState<T>(
        childMap,
        onSelect,
      );
}

class SelectorState<T> extends State<Selector> with WidgetsBindingObserver {
  Logger _logger = Logger("Selector");
  ChildWidgetMap<T> childMap;
  Select<T> onSelect;
  Rect _rect = Rect.zero;
  Rect _btnRect;
  EdgeInsetsGeometry _selectorItemPadding =
      EdgeInsets.only(left: 2, right: 2, bottom: 5);

  SelectorState(
    this.childMap,
    this.onSelect,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logger.finer("visibleChildren : ${widget.visibleChildren}");
    if (widget.visibleChildren) {
      _checkSizes();

      WidgetsBinding.instance.addPostFrameCallback((_) => _openSelector());
    }

    return InkWell(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          childMap(widget.initialValue),
          Container(
            height: 0,
            child: Icon(
              Icons.arrow_drop_down,
              size: 30,
              color: Color.fromRGBO(48, 105, 178, 1),
            ),
          )
        ],
      ),
      onTap: () => setState(() => widget.visibleChildren = true),
    );
  }

  void _openSelector() {
    _logger.finer("opening selector ...");
    int itemsSize = widget.items.length;
    double _verticalPadding = _selectorItemPadding.vertical;
    double _height = itemsSize * _rect.height + itemsSize * _verticalPadding;

    Rect _containerRect = Rect.fromCenter(
        center: _rect.bottomLeft, width: _rect.width, height: _height);

    Navigator.push(
      context,
      _SelectorRoute(
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: MaterialLocalizations.of(context).popupMenuLabel,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: _containerRect.width,
              height: _containerRect.height,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.of(
                    widget.items
                        .where((item) => widget.initialValue != item)
                        .map(
                          (item) => InkWell(
                            child: Padding(
                              padding: _selectorItemPadding,
                              child: childMap(item),
                            ),
                            onTap: () => _onItemSelected(item),
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
        rect: _containerRect,
      ),
    ).then((_) => setState(() => widget.visibleChildren = false));
  }

  void _checkSizes() {
    final RenderBox itemBox = context.findRenderObject();
    _btnRect = itemBox.localToGlobal(Offset.zero) & itemBox.size;
    final EdgeInsetsGeometry _btnPadding = ButtonTheme.of(context).padding;

    if (_btnPadding.horizontal != 0) {
      double padding = (_btnPadding.horizontal) / 2;
      var leftWithPadding = _btnRect.left;
      _btnRect = Rect.fromLTWH(
        leftWithPadding,
        _btnRect.top,
        _btnRect.width,
        _btnRect.height,
      );
    }

    _logger.finer(
        "rect: $_btnRect , size: ${_btnRect.size} , padding: $_btnPadding}");
    if (_rect != _btnRect) setState(() => _rect = _btnRect);
  }

  _onItemSelected(item) {
    Navigator.pop(context);
    onSelect(item);
  }
}

class _SelectorRoute extends PopupRoute {
  final Widget child;
  final Color color;

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => "";

  Rect rect;

  _SelectorRoute({@required this.child, this.color, this.rect});
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return CustomSingleChildLayout(
      delegate: _SelectorChildDelegate(rect),
      child: child,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(
      opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    );
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 200);
}

class _SelectorChildDelegate extends SingleChildLayoutDelegate {
  Rect rect;

  _SelectorChildDelegate(this.rect) : assert(rect != Rect.zero);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.tightFor(width: rect.width, height: rect.height);
  }

  @override
  Size getSize(BoxConstraints constraints) => rect.size;

  @override
  Offset getPositionForChild(Size size, Size childSize) => rect.center;

  @override
  bool shouldRelayout(_SelectorChildDelegate oldDelegate) {
    return rect != oldDelegate.rect;
  }
}
