import 'package:ddish/src/models/counter.dart';
import 'package:ddish/src/models/pack.dart';
import 'package:ddish/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ddish/src/blocs/menu/user/user_information_bloc.dart';
import 'package:ddish/src/blocs/menu/user/user_information_event.dart';
import 'package:ddish/src/blocs/menu/user/user_information_state.dart';
import 'package:ddish/src/repositiories/user_repository.dart';

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
    return Container(
      child: BlocBuilder<UserInformationEvent, UserInformationState>(
        bloc: _bloc,
        builder: (BuildContext context, UserInformationState state) {
          if (state is UserInformationInitial) {
            _bloc.dispatch(UserInformationStarted());
            return CircularProgressIndicator();
          }
          if (state is UserInformationLoaded) {
            User user = state.user;
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Смарт картын дугаар:'),
                    Text(user.cartNo),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Хэрэглэгчийн овог, нэр:'),
                    Text(user.userLastName.substring(0, 1) +
                        '. ${user.userFirstName}'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Админ утасны дугаар:'),
                    Text(user.adminNumber.toString()),
                  ],
                ),
                Visibility(
                  visible: user.activeCounters != null &&
                      user.activeCounters.isNotEmpty,
                  child: Column(
                    children: <Widget>[
                      new Text(
                        "Урамшууллын данс болон эрх:",
                      ),
                      ListView.builder(
                        itemCount: user.activeCounters.length,
                        itemBuilder: (BuildContext context, int index) {
                          Counter activeCounter =
                              user.activeCounters.elementAt(index);
                          return Row(
                            children: <Widget>[
                              Text(activeCounter.counterName),
                              Text(activeCounter.countBalance.toString()),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
//                Visibility(
//                  visible: user.activeProducts != null &&
//                      user.activeProducts.isNotEmpty,
//                  child: Column(
//                    children: <Widget>[
//                      new Text(
//                        "Идэвхтэй багцууд:",
//                      ),
//                      ListView.builder(
//                        itemCount: user.activeProducts.length,
//                        itemBuilder: (BuildContext context, int index) {
//                          Pack activeProduct =
//                              user.activeProducts.elementAt(index);
//                          return Row(
//                            children: <Widget>[
//                              Text(activeProduct.name),
//                              Text(
//                                  'Дуусах хугацаа: ${activeProduct.expireTime}'),
//                            ],
//                          );
//                        },
//                      ),
//                    ],
//                  ),
//                )
              ],
            );
          }
        },
      ),
    );
  }
}
