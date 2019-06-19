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
  UserRepository _userRepository;

  @override
  void initState() {
    _userRepository = UserRepository();
    _bloc = UserInformationBloc(userRepository: _userRepository);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.all(30.0),
      child: BlocBuilder<UserInformationEvent, UserInformationState>(
        bloc: _bloc,
        builder: (BuildContext context, UserInformationState state) {
          if (state is UserInformationInitial) {
            _bloc.dispatch(UserInformationStarted());
            return CircularProgressIndicator();
          }
          if (state is UserInformationLoaded) {
            User user = state.user;
            List<Widget> layoutWidgets = populateUserInformation(user);
            return Container(
              height: height * 0.6,
              child: Stack(
                overflow: Overflow.visible,
                children: layoutWidgets,
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  populateUserInformation(User user) {
    bool hasActiveCounters = user.activeCounters != null &&
        user.activeCounters.counterList.isNotEmpty;
    int counterSize =
        hasActiveCounters ? user.activeCounters.counterList.length : 0;
    double counterPosition = 90.0;
    bool hasActiveProducts =
        user.activeProducts != null && user.activeProducts.isNotEmpty;
    double productPosition = hasActiveCounters
        ? counterPosition + 30.0 * (counterSize + 1)
        : counterPosition;
    bool hasAdditionalProducts =
        user.additionalProducts != null && user.additionalProducts.isNotEmpty;
    double additionalProductPosition = hasAdditionalProducts
        ? productPosition + 30.0 * (user.activeProducts.length + 1)
        : productPosition;
    List<Widget> activeProductWidgets = [
      Positioned(
        left: 10.0,
        child:
            Text('Смарт картын дугаар:', style: style.userInfoIndicatorStyle),
      ),
      Positioned(
        left: 200.0,
        child: Text(user.cardNo.toString(), style: style.userInfoValueStyle),
      ),
      Positioned(
        top: 30.0,
        left: 10.0,
        child: Text('Хэрэглэгчийн овог, нэр:',
            style: style.userInfoIndicatorStyle),
      ),
      Positioned(
        top: 30.0,
        left: 200.0,
        child: Text(
            user.userLastName.substring(0, 1) + '. ${user.userFirstName}',
            style: style.userInfoValueStyle),
      ),
      Positioned(
        top: 60.0,
        left: 10.0,
        child:
            Text('Админ утасны дугаар:', style: style.userInfoIndicatorStyle),
      ),
      Positioned(
        top: 60.0,
        left: 200.0,
        child: Text(user.adminNumber, style: style.userInfoValueStyle),
      ),
      Positioned(
        top: 60.0,
        left: 200.0,
        child: Text(user.adminNumber, style: style.userInfoValueStyle),
      ),
      Positioned(
        top: 60.0,
        left: 200.0,
        child: Text(user.adminNumber, style: style.userInfoValueStyle),
      ),
      Positioned(
        top: counterPosition,
        left: 10.0,
        child: Visibility(
          visible: hasActiveCounters,
          child: Text("Урамшууллын данс болон эрх:",
              style: style.userInfoIndicatorStyle),
        ),
      ),
      Positioned(
        top: productPosition,
        left: 10.0,
        child: Visibility(
          visible: hasActiveProducts,
          child: Text("Идэвхтэй багцууд:", style: style.userInfoIndicatorStyle),
        ),
      ),
      Positioned(
        top: additionalProductPosition,
        left: 10.0,
        child: Visibility(
          visible: hasAdditionalProducts,
          child: Text("Идэвхтэй нэмэлт сувгууд:",
              style: style.userInfoIndicatorStyle),
        ),
      ),
    ];
    user.activeCounters.counterList
        .map((counter) => activeProductWidgets.addAll([
              Positioned(
                top: counterPosition +
                    30.0 *
                        (user.activeCounters.counterList.indexOf(counter) + 1),
                left: 10.0,
                child: Text(
                  counter.counterName,
                  style: style.activeProductsStyle,
                ),
              ),
              Positioned(
                top: counterPosition +
                    30.0 *
                        (user.activeCounters.counterList.indexOf(counter) + 1),
//        left: 150.0,
                right: 0.0,
                child: Text(
                  '${counter.counterBalance} ₮',
                  style: style.activeProductsStyle,
                ),
              )
            ]))
        .toList();
    user.activeProducts
        .map((product) => activeProductWidgets.addAll([
              Positioned(
                top: productPosition +
                    30.0 * (user.activeProducts.indexOf(product) + 1),
                left: 10.0,
                child: Text(
                  product.name,
                  style: style.activeProductsStyle,
                ),
              ),
              Positioned(
                top: productPosition +
                    30.0 * (user.activeProducts.indexOf(product) + 1),
                left: 150.0,
                child: Text(
                  'Дуусах хугацаа: ${DateUtil.formatDateTime(product.expireDate)}',
                  style: style.activeProductsStyle,
                ),
              )
            ]))
        .toList();
    user.additionalProducts
        .map((product) => activeProductWidgets.addAll([
              Positioned(
                top: additionalProductPosition +
                    30.0 * (user.additionalProducts.indexOf(product) + 1),
                left: 10.0,
                child: Text(
                  product.name,
                  style: style.activeProductsStyle,
                ),
              ),
              Positioned(
                top: additionalProductPosition +
                    30.0 * (user.additionalProducts.indexOf(product) + 1),
                left: 150.0,
                child: Text(
                  'Дуусах хугацаа: ${DateUtil.formatDateTime(product.expireDate)}',
                  style: style.activeProductsStyle,
                ),
              )
            ]))
        .toList();
    return activeProductWidgets;
  }
}
