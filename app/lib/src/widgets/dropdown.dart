import 'dart:ui';
import 'package:ddish/presentation/ddish_flutter_app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
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

  double iconFontSize;

  bool _visibleChildren = false;

  ///сонгогдсон элементийг selector дээр харуулах эсэх
  bool visibleSelectorElementOnSelector;

  bool isSelectable = true;

  IconData icon;
  Color iconColor;

  ///icon ын default location нь баруун талд нь байх бас доод талд нь байршуулж болно
  bool isIconOnBottom;

  Color backgroundColor;

  TextStyle defaultTextStyle;

  String placeholder;

  Widget underline;

  Selector({
    @required this.items,
    @required this.initialValue,
    @required this.onSelect,
    @required this.childMap,
    this.iconFontSize = 20,
    this.visibleSelectorElementOnSelector = false,
    this.icon = Icons.keyboard_arrow_down,
    this.iconColor = const Color.fromRGBO(202, 224, 252, 1),
    this.isIconOnBottom = false,
    this.backgroundColor = Colors.white,
    this.defaultTextStyle,
    this.placeholder,
    this.underline,
  }) : assert(items != null) {
    isSelectable = onSelect != null;
  }

  @override
  State<StatefulWidget> createState() =>
      SelectorState<T>(childMap, onSelect, items);
}

class SelectorState<T> extends State<Selector> with WidgetsBindingObserver {
  Logger _logger = Logger("Selector");

  List<T> items = [];
  ChildWidgetMap<T> childMap;
  Select<T> onSelect;
  Rect _rect = Rect.zero;
  Rect _btnRect;
  EdgeInsetsGeometry _selectorItemPadding = EdgeInsets.only(left: 2, right: 2);

  SelectorState(
    this.childMap,
    this.onSelect,
    this.items,
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
    _logger.finer("visibleChildren : ${widget._visibleChildren}");

    if (widget.initialValue == null &&
        items.isNotEmpty &&
        widget.placeholder == null)
      setState(() => widget.initialValue = items.first);

    if (widget._visibleChildren) {
      _initializeSizes();

      WidgetsBinding.instance.addPostFrameCallback((_) => _openSelector());
    }

    var childElement;

    if (widget.initialValue != null)
      childElement = childMap(widget.initialValue);

    //хэрэв placeholder тохируулж өгөөгүй бол жагсаалтын эхний элемент сонгогдсон харагдана
    if (widget.placeholder != null && widget.initialValue == null)
      childElement = Expanded(
        child: Text(
          widget.placeholder,
          style: widget.defaultTextStyle,
          textAlign: TextAlign.center,
        ),
      );
    else if (childElement != null && widget.defaultTextStyle != null)
      childElement = Expanded(
        child: DefaultTextStyle(
          child: childElement,
          style: widget.defaultTextStyle,
        ),
      );

    List<Widget> children = [
      childElement,
      widget.isSelectable
          ? Icon(
              widget.icon,
              size: widget.iconFontSize,
              color: widget.iconColor,
            )
          : Container(
              height: widget.iconFontSize,
              width: widget.iconFontSize,
            )
    ];

    Widget selectorBody = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
    if (widget.isIconOnBottom)
      selectorBody = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      );

    if (widget.underline != null)
      selectorBody = Stack(
        children: <Widget>[
          selectorBody,
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 3.0,
            child: widget.underline ??
                Container(
                  height: 1.0,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color(0xFFBDBDBD), width: 0.0))),
                ),
          )
        ],
      );

    return InkWell(
      child: selectorBody,
      onTap: widget.isSelectable
          ? () => setState(() => widget._visibleChildren = true)
          : null,
    );
  }

  void _openSelector() {
    _logger.finer("opening selector ...");
    int itemsSize = widget.visibleSelectorElementOnSelector
        ? items.length
        : items.length - 1; // сонгогдсон элементийг
    double _verticalPadding = _selectorItemPadding.vertical;
    double _height = itemsSize * _rect.height + itemsSize;

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
            scrollDirection: Axis.vertical,
            child: Container(
              width: _containerRect.width,
//              height: _containerRect.height,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xff3069b2)),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.of(
                    items.where((item) => widget.initialValue != item).map(
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
    ).then((_) => setState(() => widget._visibleChildren = false));
  }

  void _initializeSizes() {
    final RenderBox itemBox = context.findRenderObject();
    _btnRect = itemBox.localToGlobal(Offset.zero) & itemBox.size;
    final EdgeInsetsGeometry _btnPadding = ButtonTheme.of(context).padding;

    if (_btnPadding.horizontal != 0) {
      double _padding = (_btnPadding.horizontal) / 2;
      var leftWithPadding = _btnRect.left;
      var offsetTop = _btnRect.top - widget.iconFontSize;

      if (!widget.isIconOnBottom) offsetTop = offsetTop + _padding + 5;

      _btnRect = Rect.fromLTWH(
        leftWithPadding,
        offsetTop,
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
    setState(() => widget.initialValue = item);
    if (widget.isSelectable) onSelect(item);
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
    var deviceHeight = MediaQuery.of(context).size.height;
    return CustomSingleChildLayout(
      delegate: _SelectorChildDelegate(rect, deviceHeight),
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
  double deviceHeight = 0;

  _SelectorChildDelegate(this.rect, this.deviceHeight)
      : assert(rect != Rect.zero);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    ///тухайн элементийн одоогийн байршлаас дэлгэцний доод зах хүртэлх зайны 80 хувь
    double maxHeight = (deviceHeight - rect.top) * 0.8;
    return BoxConstraints(
        minHeight: rect.height,
        maxHeight: maxHeight,
        minWidth: rect.width,
        maxWidth: rect.width);
//    return BoxConstraints.tightFor(width: rect.width, height: rect.height);
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
