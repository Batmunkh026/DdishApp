import 'package:ddish/src/blocs/menu/user/user_information_bloc.dart';
import 'package:ddish/src/blocs/menu/user/user_information_event.dart';
import 'package:ddish/src/blocs/menu/user/user_information_state.dart';
import 'package:ddish/src/models/user.dart';
import 'package:ddish/src/templates/menu/user_info/style.dart' as style;
import 'package:ddish/src/utils/date_util.dart';
import 'package:ddish/src/utils/formatter.dart';
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
    var formatter = StringFormatter();

    Map<Widget, Widget> userInfoMap = {
      Text(
        'Смарт картын дугаар:',
        style: style.userInfoIndicatorStyle,
        softWrap: true,
      ): Text(
        formatter.formatCardNumber(user.cardNo.toString()),
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
      ): Text('${formatter.formatPhoneNumber(user.adminNumber.toString())}',
          style: style.userInfoValueStyle),
      Visibility(
        visible: hasActiveCounters,
        child: Container(
          child: Text(
            "Урамшууллын данс болон эрх:",
            style: style.userInfoIndicatorStyle,
            softWrap: true,
          ),
          margin: EdgeInsets.only(top: 8),
        ),
      ): null,
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
              padding: EdgeInsets.only(bottom: 3),
              child: createChildRow(
                  Text(
                    counter.counterName,
                    style: style.activeProductsStyle,
                    softWrap: true,
                  ),
                  Text(
                    '${StringFormatter().isNumeric(counter.counterBalance) ? PriceFormatter.productPriceFormat(counter.counterBalance) + "₮" : counter.counterBalance} ',
                    style: style.activeProductsStyle,
                    softWrap: true,
                  ),
                  childWidth: MediaQuery.of(context).size.width * 0.4,
                  isDependOnDevice: true),
            ),
          ),
        )
        .toList();
    userInfoChildren.add(
      Visibility(
        visible: hasActiveProducts,
        child: Container(
          child: Text("Идэвхтэй багцууд:", style: style.userInfoIndicatorStyle),
          margin: EdgeInsets.only(top: 8),
        ),
      ),
    );
    user.activeProducts
        .map(
          (product) => userInfoChildren.add(
            createChildRow(
              Text(
                product.name,
                style: style.activeProductsStyle,
                softWrap: true,
              ),
              Text(
                'Дуусах хугацаа: ${DateUtil.formatDateTimeWithDot(product.expireDate)}',
                style: style.activeProductsStyle,
                softWrap: true,
              ),
              childWidth: width * 0.6,
            ),
          ),
        )
        .toList();
    userInfoChildren.add(
      Visibility(
        visible: hasAdditionalProducts,
        child: Container(
          child: Text("Идэвхтэй нэмэлт сувгууд:",
              style: style.userInfoIndicatorStyle),
          margin: EdgeInsets.only(top: 8),
        ),
      ),
    );
    user.additionalProducts
        .map(
          (product) => userInfoChildren.add(
            createChildRow(
              Text(
                product.name,
                style: style.activeProductsStyle,
                softWrap: true,
              ),
              Text(
                'Дуусах хугацаа: ${DateUtil.formatDateTimeWithDot(product.expireDate)}',
                style: style.activeProductsStyle,
                softWrap: true,
              ),
              childWidth: width * 0.6,
            ),
          ),
        )
        .toList();
    Column userInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.from(
        userInfoChildren.map(
          (child) => Container(
            padding: EdgeInsets.only(bottom: 15),
            child: child,
          ),
        ),
      ),
    );
    return userInfo;
  }

  createChildRow(Widget widget, Widget widget2,
      {childWidth = 0.0, bool isDependOnDevice = false}) {
    List<Widget> children = [];
    var deviceWidth = MediaQuery.of(context).size.width;
    if (childWidth == 0) childWidth = deviceWidth * 0.5;

    Widget rightWidget = Flexible(
      child: Container(
        padding: EdgeInsets.only(left: 10),
        width: isDependOnDevice && deviceWidth > 350
            ? deviceWidth * 0.4
            : childWidth,
        child: widget2,
      ),
    );
    if (deviceWidth < 350)
      rightWidget = Container(
        padding: EdgeInsets.only(left: 10),
        width: childWidth,
        child: widget2,
      );

    Widget leftChild = deviceWidth > 350 && deviceWidth * 0.5 < childWidth
        ? widget
        : Flexible(
            child: widget,
          );

    if (widget2 != null)
      children = [leftChild, rightWidget];
    else
      children.add(widget);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}
