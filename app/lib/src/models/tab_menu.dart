import 'package:ddish/src/models/tab_models.dart';
import 'package:flutter/material.dart';

class TabMenuItem{
  const TabMenuItem(this.title, this.icon,@required this.state):assert(state != null);

  final String title;
  final IconData icon;
  final dynamic state;
}
