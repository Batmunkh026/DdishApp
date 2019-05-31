import 'package:flutter/material.dart';

class Order extends StatelessWidget {
  final String orderType;

  Order(this.orderType);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(orderType),);
  }
}