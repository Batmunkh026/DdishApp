import 'package:ddish/src/repositiories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:ddish/src/blocs/service/account/account_bloc.dart';
import 'package:ddish/src/blocs/service/account/account_event.dart';
import 'package:ddish/src/blocs/service/account/account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  AccountBloc _bloc;
  UserRepository _userRepository;

  @override
  void initState() {
    _userRepository = UserRepository();
    _bloc = AccountBloc(userRepository: _userRepository);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountEvent, AccountState>(
      bloc: _bloc,
      builder: (BuildContext context, AccountState state) {
        _bloc.dispatch(AccountTabSelected());
        return Container(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            children: <Widget>[
              RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        style: const TextStyle(
                            color: const Color(0xff144478),
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            fontSize: 17.0),
                        text: "Үндсэн дансны үлдэгдэл:   "),
                    TextSpan(
                        style: const TextStyle(
                            color: const Color(0xff144478),
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 17.0),
                        text: state is AccountBalanceLoaded
                            ? ' ${state.mainCounter.counterBalance} ₮'
                            : '-')
                  ])),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text("Данс цэнэглэх заавар",
                    style: const TextStyle(
                        color: const Color(0xff071f49),
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 15.0)),
              ),
            ],
          ),
        );
      },
    );
  }
}
