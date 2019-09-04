import 'dart:ui';
import 'package:ddish/presentation/ddish_flutter_app_icons.dart';
import 'package:ddish/src/templates/service/movie/description/detail_button.dart';
import 'package:ddish/src/templates/service/movie/description/dialog_close.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

typedef void Select<T>(T selectedValue);
typedef Widget ChildWidgetMap<T>(T value);

class Preview extends StatefulWidget {
  ///default rect нь өргөн нь 96%, өндөр нь өргөнтэй 1.5 харьцаатай , centered байна
  Rect rect;
  String label;
  Widget previewWidget;
  EdgeInsets contentPadding;
  Color contentBackgroundColor;
  bool isClickAble;

  Preview({
    this.rect,
    this.label,
    this.previewWidget,
    this.contentPadding = const EdgeInsets.only(left: 30, right: 30, top: 30),
    this.contentBackgroundColor = const Color.fromRGBO(50, 88, 150, 1),
    this.isClickAble = true,
  });

  @override
  State<StatefulWidget> createState() => PreviewState(rect);
}

class PreviewState extends State<Preview> with WidgetsBindingObserver {
  Logger _logger = Logger("Selector");
  Rect rect;

  PreviewState(this.rect);

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
    if (rect == null) {
      Size size = MediaQuery.of(context).size;
      var width = size.width * .96;
      var height = width * 1.5;
      var offsetLeft = (size.width - width) / 2;
      var offsetTop = (size.height - height) / 2;

      rect = Rect.fromLTWH(
        offsetLeft,
        offsetTop,
        width,
        height,
      );
      _logger.info(
          "offsetLeft: $offsetLeft , offsetTop: $offsetTop , width: $width , height: $height");
    }

    return InkWell(
      child: DetailButton(
        text: widget.label,
        onTap: widget.isClickAble ? () => preview() : null,
      ),
    );
  }

  void preview() {
    Navigator.push(
      context,
      _PreviewRoute(
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: MaterialLocalizations.of(context).popupMenuLabel,
          child: Material(
            type: MaterialType.transparency,
            child: BackdropFilter(
              child: SingleChildScrollView(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    child: BackdropFilter(
                      child: Container(
                        width: rect.width,
                        height: rect.height,
                        padding: widget.contentPadding,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          color: widget.contentBackgroundColor.withOpacity(0.8),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                    child: widget.previewWidget,
                                  ),
                                  padding: EdgeInsets.all(5),
                                  color: Colors.white24,
                                ),
                              ),
                              DialogCloseButton(
                                  onTap: () => Navigator.pop(context))
                            ],
                          ),
                        ),
                      ),
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    ),
                  ),
                ),
              ),
              filter: ImageFilter.blur(sigmaX: .1, sigmaY: .1),
            ),
          ),
        ),
        rect: rect,
      ),
    );
  }
}

class _PreviewRoute extends PopupRoute {
  final Widget child;

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => "";

  Rect rect;

  _PreviewRoute({@required this.child, this.rect});
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    var deviceHeight = MediaQuery.of(context).size.height;

    return CustomSingleChildLayout(
      delegate: _PreviewChildDelegate(rect, deviceHeight),
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

class _PreviewChildDelegate extends SingleChildLayoutDelegate {
  Rect rect;
  double deviceHeight = 0;

  _PreviewChildDelegate(this.rect, this.deviceHeight)
      : assert(rect != Rect.zero);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints.tightFor(width: rect.width, height: rect.height);
  @override
  Offset getPositionForChild(Size size, Size childSize) =>
      Offset(rect.left, rect.top);

  @override
  bool shouldRelayout(_PreviewChildDelegate oldDelegate) {
    return rect != oldDelegate.rect;
  }
}
