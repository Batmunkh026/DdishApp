import 'package:ddish/src/blocs/notification/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => NotificationPageState();

}
class NotificationPageState extends State<NotificationPage>{

  NotificationBloc _notificationBloc;

  @override
  void initState() {
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("notification"),);
  }

  @override
  void dispose() {
    _notificationBloc.dispose();
    super.dispose();
  }
}