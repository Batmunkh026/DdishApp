import 'package:flutter/material.dart';

class PackNavigator extends PopupRoute {
  final WidgetBuilder builder;
  final Color color;

  @override
  Color get barrierColor => color;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => "";

  PackNavigator({@required this.builder, this.color});

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Builder(
      builder: builder,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(
        opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child);
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  Iterable<OverlayEntry> createOverlayEntries() sync* {
    yield super.createOverlayEntries().last;
  }
}

