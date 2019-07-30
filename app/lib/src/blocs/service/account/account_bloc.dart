import 'package:bloc/bloc.dart';
import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/models/counter.dart';
import 'package:ddish/src/repositiories/user_repository.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends AbstractBloc<AccountEvent, AccountState> {

  UserRepository _userRepository;

  AccountBloc(pageState):super(pageState){
    _userRepository = UserRepository(this);
  }

  @override
  AccountState get initialState => AccountBalanceStarted();

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if(event is AccountTabSelected) {
      Counter counter = await _userRepository.getMainCounter();
      yield AccountBalanceLoaded(mainCounter: counter);
    }
  }
}