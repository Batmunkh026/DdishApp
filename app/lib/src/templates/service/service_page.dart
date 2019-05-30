import 'package:ddish/src/blocs/service/service_bloc.dart';
import 'package:ddish/src/templates/base_page.dart';
import 'package:ddish/src/templates/service/service_base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServicePage extends ServiceBasePage {
  @override
  ServiceBasePageState createState(){
    super.createState();
    return ServicePageState();
  }
}

class ServicePageState extends ServiceBasePageState {
  @override
  Widget build(BuildContext context) {
    var title = Text("Багц сонгох");
    return super.build(context);
  }
}
