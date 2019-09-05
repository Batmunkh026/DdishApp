import 'package:ddish/src/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef void Select<T>(T selectedValue);
typedef Widget ChildWidgetMap<T>(T value);

class DialogPicker<T> extends CustomDialog {
  String title;

  List<T> items;

  final Select<T> onSelect;

  final ChildWidgetMap<T> itemMap;

  DialogPicker({this.title, this.items, this.itemMap, this.onSelect})
      : assert(items != null && items.isNotEmpty),
        assert(itemMap != null),
        super(title: title, content: createContent);

  static get createContent => (items, itemMap, onSelect) {
        List<Widget> itemElements = List<Widget>.of(
          items.map(
            (item) => InkWell(
              child: itemMap(item),
              onTap: () => () {
                if (onSelect == null) return;
                onSelect(item);
              },
            ),
          ),
        );

        ListView itemContainer = ListView(
          children: itemElements,
        );
        return itemContainer;
      };
}
