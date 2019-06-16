import 'package:ddish/src/blocs/menu/user/user_information_bloc.dart';
import 'package:ddish/src/blocs/menu/user/user_information_event.dart';
import 'package:ddish/src/blocs/menu/user/user_information_state.dart';
import 'package:ddish/src/models/user.dart';
import 'package:ddish/src/repositiories/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'style.dart' as style;

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
            return Container(
              height: height * 0.7,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 10.0,
                    child: Text('Смарт картын дугаар:',
                        style: style.userInfoIndicatorStyle),
                  ),
                  Positioned(
                    left: 200.0,
                    child: Text(user.cardNo.toString(),
                        style: style.userInfoValueStyle),
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
                        user.userLastName.substring(0, 1) +
                            '. ${user.userFirstName}',
                        style: style.userInfoValueStyle),
                  ),
                  Positioned(
                    top: 60.0,
                    left: 10.0,
                    child: Text('Админ утасны дугаар:',
                        style: style.userInfoIndicatorStyle),
                  ),
                  Positioned(
                    top: 60.0,
                    left: 200.0,
                    child:
                        Text(user.adminNumber, style: style.userInfoValueStyle),
                  ),
                  Positioned(
                    top: 90.0,
                    left: 10.0,
                    child: Visibility(
                      visible: user.activeCounters != null &&
                      user.activeCounters.counterList.isNotEmpty,
                      child: Text('Админ утасны дугаар:',
                          style: style.userInfoIndicatorStyle),
                    ),
                  ),
//                  Visibility(
//                    visible: user.activeCounters != null &&
//                        user.activeCounters.counterList.isNotEmpty,
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        new Text("Урамшууллын данс болон эрх:",
//                            style: style.userInfoIndicatorStyle),
//                        ListView.builder(
//                          scrollDirection: Axis.vertical,
//                          shrinkWrap: true,
//                          itemCount: user.activeCounters.counterList.length,
//                          itemBuilder: (BuildContext context, int index) {
//                            Counter activeCounter = user
//                                .activeCounters.counterList
//                                .elementAt(index);
//                            return Row(
//                              children: <Widget>[
//                                Text(
//                                  activeCounter.counterName,
//                                  style: style.activeProductsStyle,
//                                ),
//                                Text(
//                                  activeCounter.counterBalance,
//                                  style: style.activeProductsStyle,
//                                ),
//                              ],
//                            );
//                          },
//                        ),
//                      ],
//                    ),
//                  ),
//                  Visibility(
//                    visible: user.activeProducts != null &&
//                        user.activeProducts.products.isNotEmpty,
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        new Text("Идэвхтэй багцууд:",
//                            style: style.userInfoIndicatorStyle),
//                        ListView.builder(
//                          scrollDirection: Axis.vertical,
//                          shrinkWrap: true,
//                          itemCount: user.activeProducts.products.length,
//                          itemBuilder: (BuildContext context, int index) {
//                            Product activeProduct =
//                                user.activeProducts.products.elementAt(index);
//                            return Row(
//                              children: <Widget>[
//                                Text(
//                                  activeProduct.productName,
//                                  style: style.activeProductsStyle,
//                                ),
//                                Text(
//                                  'Дуусах хугацаа: ${DateUtil.formatDateTime(activeProduct.endDate)}',
//                                  style: style.activeProductsStyle,
//                                ),
//                              ],
//                            );
//                          },
//                        ),
//                      ],
//                    ),
//                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
