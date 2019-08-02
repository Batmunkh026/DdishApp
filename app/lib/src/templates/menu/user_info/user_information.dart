import 'package:ddish/src/blocs/menu/user/user_information_bloc.dart';
import 'package:ddish/src/blocs/menu/user/user_information_event.dart';
import 'package:ddish/src/blocs/menu/user/user_information_state.dart';
import 'package:ddish/src/models/user.dart';
import 'package:ddish/src/repositiories/user_repository.dart';
import 'package:ddish/src/templates/menu/user_info/style.dart' as style;
import 'package:ddish/src/utils/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInformationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserInformationWidgetState();
}

class UserInformationWidgetState extends State<UserInformationWidget> {
  UserInformationBloc _bloc;

  double width = 0;
  double height = 0;

  @override
  void initState() {
    _bloc = UserInformationBloc(this);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (height == 0) height = MediaQuery.of(context).size.height;
    if (width == 0) width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: BlocBuilder<UserInformationEvent, UserInformationState>(
        bloc: _bloc,
        builder: (BuildContext context, UserInformationState state) {
          if (state is UserInformationInitial) {
            _bloc.dispatch(UserInformationStarted());
            return CircularProgressIndicator();
          }
          if (state is UserInformationLoaded) {
            User user = state.user;
            Stack layoutWidgets = populateUserInformation(user);
            return Container(
              height: height * 0.65,
              width: width * 0.9,
              padding: EdgeInsets.all(3),
              child: SingleChildScrollView(
                child: layoutWidgets,
                scrollDirection: Axis.vertical,
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  populateUserInformation(User user) {
    bool hasActiveCounters =
        user.activeCounters != null && user.activeCounters.isNotEmpty;
    bool hasActiveProducts =
        user.activeProducts != null && user.activeProducts.isNotEmpty;
    bool hasAdditionalProducts =
        user.additionalProducts != null && user.additionalProducts.isNotEmpty;

    List<Widget> userInformationKeys = [
      Text('Смарт картын дугаар:', style: style.userInfoIndicatorStyle),
      Text('Хэрэглэгчийн овог, нэр:', style: style.userInfoIndicatorStyle),
      Text('Админ утасны дугаар:', style: style.userInfoIndicatorStyle),
      Visibility(
        visible: hasActiveCounters,
        child: Text("Урамшууллын данс болон эрх:",
            style: style.userInfoIndicatorStyle),
      ),
    ];

    List<Widget> userInformationValues = [];
    userInformationValues.addAll([
      Text(user.cardNo.toString(), style: style.userInfoValueStyle),
      Text(user.userLastName.substring(0, 1) + '. ${user.userFirstName}',
          style: style.userInfoValueStyle),
      Text('${user.adminNumber}', style: style.userInfoValueStyle),
    ]);

    user.activeCounters
        .map((counter) => userInformationKeys.add(Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  counter.counterName,
                  style: style.activeProductsStyle,
                ),
                Text(
                  '${counter.counterBalance} ₮',
                  style: style.activeProductsStyle,
                ),
              ],
            )))
        .toList();
    userInformationKeys.add(
      Visibility(
        visible: hasActiveProducts,
        child: Text("Идэвхтэй багцууд:", style: style.userInfoIndicatorStyle),
      ),
    );
    user.activeProducts
        .map((product) => userInformationKeys.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: style.activeProductsStyle,
                  ),
                  Text(
                    '${DateUtil.formatDateTimeWithDot(product.expireDate)}-нд дуусна',
                    style: style.activeProductsStyle,
                  ),
                ])))
        .toList();
    userInformationKeys.add(
      Visibility(
        visible: hasAdditionalProducts,
        child: Text("Идэвхтэй нэмэлт сувгууд:",
            style: style.userInfoIndicatorStyle),
      ),
    );
    user.additionalProducts
        .map((product) => userInformationKeys.add(Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: style.activeProductsStyle,
                  ),
                  Text(
                    '${DateUtil.formatDateTimeWithDot(product.expireDate)}-нд дуусна',
                    style: style.activeProductsStyle,
                  ),
                ])))
        .toList();
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: userInformationKeys
              .map((child) => Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: child,
                  ))
              .toList(),
        ),
        Container(
          width: width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: userInformationValues
                .map((child) => Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: child,
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
