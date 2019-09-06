import 'package:ddish/src/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef void Select<T>(T selectedValue);
typedef Widget ChildWidgetMap<T>(T value);
typedef ListView ChildrenContainer<T>(
    List<T> children, ChildWidgetMap<T> childMap, Select<T> onChildSelect);

class DialogPicker<T> extends StatelessWidget {
  String title;

  T selectedItem;

  List<T> items;

  final Select<T> onSelect;

  final ChildWidgetMap<T> itemMap;

  String closeButtonText;

  double width;
  double height;

  DialogPicker({
    this.title,
    this.items,
    this.selectedItem,
    this.itemMap,
    this.onSelect,
    this.closeButtonText,
    this.width,
    this.height,
  })  : assert(items != null && items.isNotEmpty),
        assert(itemMap != null);

  @override
  Widget build(BuildContext context) {
    var minWidth = MediaQuery.of(context).size.width * 0.6;
    var minHeight = 200.0;

    return CustomDialog(
      title: title,
      content: Container(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: width ?? minWidth,
            minHeight: height ?? minHeight,
            maxWidth: width ?? minWidth,
            maxHeight: height ?? minHeight,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: List<Widget>.of(
                  items.map(
                    (item) => InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        width: width ?? minWidth,
                        child: itemMap(item),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withOpacity(0.03),
                              width: 3,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 6),
                        margin: EdgeInsets.only(bottom: 1),
                      ),
                      onTap: () {
                        if (onSelect == null) return;
                        Navigator.of(context).pop();
                        onSelect(item);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      closeButtonText: closeButtonText,
    );
  }
}

class DialogPickerButton<T> extends StatelessWidget {
  ///товчлуур дээр харуулах текст
  ///
  ///Хэрэв текст өгөгдөөгүй бол dialog ыг title ыг харуулна
  String btnLabel;
  DialogPicker<T> pickerDialog;

  Color backgroundColor;
  TextStyle textStyle;
  IconData buttonIcon;
  Color iconColor;

  DialogPickerButton({
    this.pickerDialog,
    this.btnLabel,
    this.backgroundColor = Colors.white24,
    this.textStyle = const TextStyle(color: Colors.white),
    this.iconColor = Colors.white,
    this.buttonIcon = Icons.keyboard_arrow_down,
  }) : assert(pickerDialog != null);

  @override
  Widget build(BuildContext context) {
    String buttonLabel = btnLabel ?? pickerDialog.title;
    if (pickerDialog.selectedItem != null)
      buttonLabel = pickerDialog.selectedItem.toString();

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.all(5),
      child: InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                buttonLabel,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ),
            Icon(buttonIcon)
          ],
        ),
        onTap: () =>
            showDialog(context: context, builder: (context) => pickerDialog),
      ),
    );
  }
}
