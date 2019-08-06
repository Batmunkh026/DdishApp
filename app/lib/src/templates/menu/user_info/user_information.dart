import 'package:ddish/src/blocs/menu/user/user_information_bloc.dart';
import 'package:ddish/src/blocs/menu/user/user_information_event.dart';
import 'package:ddish/src/blocs/menu/user/user_information_state.dart';
import 'package:ddish/src/models/user.dart';
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
    return Expanded(
      child: BlocBuilder<UserInformationEvent, UserInformationState>(
        bloc: _bloc,
        builder: (BuildContext context, UserInformationState state) {
          if (state is UserInformationInitial) {
            _bloc.dispatch(UserInformationStarted());
            return Center(child: CircularProgressIndicator());
          }
          if (state is UserInformationLoaded) {
            User user = state.user;
            var layoutWidgets = populateUserInformation(user);
            return Container(
              padding: const EdgeInsets.all(10),
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

    List<Widget> userInfoChildren = [];
    Map<Widget, Widget> userInfoMap = {
      Text(
        'Смарт картын дугаар:',
        style: style.userInfoIndicatorStyle,
        softWrap: true,
      ): Text(
        user.cardNo.toString(),
        style: style.userInfoValueStyle,
      ),
      Text(
        'Хэрэглэгчийн овог, нэр:',
        style: style.userInfoIndicatorStyle,
        softWrap: true,
      ): Text(user.userLastName.substring(0, 1) + '. ${user.userFirstName}',
          style: style.userInfoValueStyle),
      Text(
        'Админ утасны дугаар:',
        style: style.userInfoIndicatorStyle,
        softWrap: true,
      ): Text('${user.adminNumber}', style: style.userInfoValueStyle),
      Visibility(
        visible: hasActiveCounters,
        child: Text(
          "Урамшууллын данс болон эрх:",
          style: style.userInfoIndicatorStyle,
          softWrap: true,
        ),
      ): Container(),
    };

//    Function mapper = (keyChild, valueChild) => Row(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            keyChild,
//            Flexible(
//              child: Container(
//                padding: EdgeInsets.only(left: 20),
//                child: valueChild,
//              ),
//            )
//          ],
//        );
    userInfoMap.forEach((keyChild, valueChild) =>
        userInfoChildren.add(createChildRow(keyChild, valueChild)));

    List<Widget> userInformationValues = [];
    userInformationValues.addAll([
      Text(user.cardNo.toString(), style: style.userInfoValueStyle),
      Text(user.userLastName.substring(0, 1) + '. ${user.userFirstName}',
          style: style.userInfoValueStyle),
      Text('${user.adminNumber}', style: style.userInfoValueStyle),
    ]);

    user.activeCounters
        .map(
          (counter) => userInfoChildren.add(
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: createChildRow(
                Text(
                  counter.counterName,
                  style: style.activeProductsStyle,
                  softWrap: true,
                ),
                Text(
                  '${counter.counterBalance} ₮',
                  style: style.activeProductsStyle,
                  softWrap: true,
                ),
              ),
            ),
          ),
        )
        .toList();
    userInfoChildren.add(
      Visibility(
        visible: hasActiveProducts,
        child: Text("Идэвхтэй багцууд:", style: style.userInfoIndicatorStyle),
      ),
    );
    user.activeProducts
        .map(
          (product) => userInfoChildren.add(
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: createChildRow(
                Text(
                  product.name,
                  style: style.activeProductsStyle,
                ),
                Text(
                  '${DateUtil.formatDateTimeWithDot(product.expireDate)}-нд дуусна',
                  style: style.activeProductsStyle,
                  softWrap: true,
                ),
              ),
            ),
          ),
        )
        .toList();
    userInfoChildren.add(
      Visibility(
        visible: hasAdditionalProducts,
        child: Text("Идэвхтэй нэмэлт сувгууд:",
            style: style.userInfoIndicatorStyle),
      ),
    );
    user.additionalProducts
        .map(
          (product) => userInfoChildren.add(
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: createChildRow(
                Text(
                  product.name,
                  style: style.activeProductsStyle,
                ),
                Text(
                  '${DateUtil.formatDateTimeWithDot(product.expireDate)}-нд дуусна',
                  style: style.activeProductsStyle,
                ),
              ),
            ),
          ),
        )
        .toList();
    Column userInfo = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.from(userInfoChildren.map((child) => Container(
              padding: EdgeInsets.only(bottom: 15),
              child: child,
            ))));
    return userInfo;
  }

  createChildRow(Widget widget, Widget widget2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: widget,
        ),
        Flexible(
          child: Container(padding: EdgeInsets.only(left: 20), child: widget2,),
        )
      ],
    );
  }
}
