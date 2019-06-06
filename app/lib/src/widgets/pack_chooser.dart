import 'package:ddish/src/models/month_price.dart';
import 'package:ddish/src/models/pack.dart';
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

class PackGridPicker extends StatelessWidget {
  var parentContext;
  int columnNumber;
  Pack pack;
  Function(Pack p, MonthAndPriceToExtend mp) pick;

  PackGridPicker(this.parentContext, this.columnNumber, this.pack, this.pick);

  @override
  Widget build(BuildContext context) {
    assert(pack != null);

    var contents = pack.packsForMonth.map((mp) {
      return Center(
        child: GestureDetector(
          child: Card(
            color: Color.fromRGBO(49, 138, 255, 1),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("${mp.monthToExtend} сар"),
                  Text("₮ ${mp.price}"),
                ],
              ),
            ),
          ),
          onTap: () {
            var contextSize = context.size;
            var screenSize = MediaQuery.of(context).size;
            var parentSize = parentContext.size;
            RenderBox renderbox = parentContext.findRenderObject();
            Offset globalCoord =
                renderbox.localToGlobal(new Offset(0.5, context.size.height));

            var lef = contextSize.topLeft;
            var offsetTop = screenSize.height - contextSize.height;
            var offsetLeft = (screenSize.width - contextSize.width) / 2;

            var builder = new Container(
              padding: new EdgeInsets.only(top: offsetTop, bottom: 0),
              width: contextSize.width,
              child: Card(
                  margin: EdgeInsets.only(
                      left: offsetLeft, right: offsetLeft),
                  child: new Builder(
                    builder: (context) => PackPaymentPreview(),
                  )),
            );

            Navigator.of(context, rootNavigator: true).push(PackNavigator(
                builder: (context) => builder, color: Colors.blue));
          },
        ),
      );
    }).toList();

    return GridView.count(
      crossAxisCount: 2,
      children: contents,
    );
  }
}

class PackPaymentPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Төлбөрийн мэдээлэл",
          textAlign: TextAlign.left,
        ),
      ),
      body: ListView(
        children: <Widget>[
        ],
      ),
    );
  }
}
