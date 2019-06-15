import 'package:bloc/bloc.dart';
import 'package:ddish/src/models/counter.dart';
import 'package:ddish/src/repositiories/user_repository.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {

  final UserRepository userRepository;

  AccountBloc({this.userRepository});

  @override
  AccountState get initialState => AccountBalanceStarted();

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if(event is AccountTabSelected) {
      Counter counter = await userRepository.getMainCounter();
      yield AccountBalanceLoaded(mainCounter: counter);
    }
  }
}