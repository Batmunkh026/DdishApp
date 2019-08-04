import 'package:ddish/src/blocs/notification/notification_bloc.dart';
import 'package:ddish/src/blocs/notification/notification_event.dart';
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
    _notificationBloc = NotificationBloc(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Notification',
            style: TextStyle(fontSize: 14, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.only(left: 18, right: 18, bottom: 20),
        child: BlocBuilder(
          bloc: _notificationBloc,
          builder: (context, state) {
            if (state is Started) _notificationBloc.dispatch(LoadEvent());

            if (state is Loading || state is Started)
              return Center(child: CircularProgressIndicator());
            else if (state is Loaded)
              return buildNotification(state.notifications);
            else
              return Container();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notificationBloc.dispose();
    super.dispose();
  }

  Widget buildNotification(List<ddish.Notification> notifications) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(Radius.circular(20)),
      ),
      padding: EdgeInsets.only(top: 10),
      child: notifications.isEmpty
          ? Center(
              child: Text(
                'Мэдэгдэл ирээгүй байна.',
                textAlign: TextAlign.center,
              ),
            )
          : buildNotifications(notifications),
    );
  }

  Widget buildNotifications(notifications) {
    return ListView(
      children: List<Widget>.from(notifications.map((notification) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            highlightColor: Color.fromRGBO(154, 199, 255, 1),
            onTap: () => {},
            child: Container(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
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
      })),
    );
  }
}
