import 'package:ddish/src/blocs/notification/notification_bloc.dart';
import 'package:ddish/src/blocs/notification/notification_event.dart';
import 'package:ddish/src/blocs/notification/notification_state.dart';
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
    return BlocBuilder(
        bloc: _notificationBloc,
        builder: (context, state) {
          if (state is Started) _notificationBloc.dispatch(LoadEvent());
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 1, bottom: 15),
                  child: Text(
                    'Сонордуулга',
                    style: TextStyle(fontSize: 17, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    padding: EdgeInsets.only(top: 26),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(Radius.circular(35)),
                    ),
                    child: buildNotification(state),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    _notificationBloc.dispose();
    super.dispose();
  }

  Widget buildNotification(state) {
    Widget body = Container();

    if (state is Loading || state is Started)
      body = Center(child: CircularProgressIndicator());
    else if (state is Loaded)
      return state.notifications.isEmpty
          ? Center(
              child: Text(
                'Мэдэгдэл ирээгүй байна.',
                textAlign: TextAlign.center,
              ),
            )
          : buildNotifications(state.notifications);
    return body;
  }

  Widget buildNotifications(notifications) {
    return ListView(
      children: List<Widget>.from(
        notifications.map((notification) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: Color.fromRGBO(154, 199, 255, 1),
              onTap: () => {},
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 5, right: 15, left: 15),
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
        }),
      ),
    );
  }
}
