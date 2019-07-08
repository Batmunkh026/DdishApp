import 'package:ddish/src/blocs/notification/notification_bloc.dart';
import 'package:ddish/src/blocs/notification/notification_state.dart';
import 'package:ddish/src/models/notification.dart' as ddish;
import 'package:ddish/src/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  NotificationBloc _notificationBloc;

  @override
  void initState() {
    _notificationBloc = NotificationBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: BlocBuilder(
        bloc: _notificationBloc,
        builder: (context, state) {
          if (state is Loading)
            return Center(child: CircularProgressIndicator());
          else if (state is Loaded)
            return buildNotification(state.notifications);
        },
      ),
    );
  }

  @override
  void dispose() {
    _notificationBloc.dispose();
    super.dispose();
  }

  Widget buildNotification(List<ddish.Notification> notifications) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(Radius.circular(20))),
        child: notifications.isEmpty
            ? Center(
                child: Text(
                  'Мэдэгдэл ирээгүй байна.',
                  textAlign: TextAlign.center,
                ),
              )
            : buildNotifications(notifications),
      ),
    );
  }

  Widget buildNotifications(notifications) {
    return ListView(
        children: notifications.map((notification) {
      return Material(
        child: InkWell(
          highlightColor: Color.fromRGBO(154, 199, 255, 1),
          onTap: () => {},
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        notification.name,
                        softWrap: true,
                      ),
                    ),
                    Text(DateUtil.formatDateTime(notification.date)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(notification.text),
                )
              ],
            ),
          ),
        ),
      );
    }).toList());
  }
}
