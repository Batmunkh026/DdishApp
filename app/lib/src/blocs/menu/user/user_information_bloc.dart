import 'package:ddish/src/abstract/abstract.dart';
import 'package:ddish/src/models/user.dart';
import 'package:ddish/src/repositiories/user_repository.dart';

import 'user_information_event.dart';
import 'user_information_state.dart';

class UserInformationBloc extends AbstractBloc<UserInformationEvent, UserInformationState>{
  UserRepository _userRepository;

  UserInformationBloc(pageState):super(pageState){
   _userRepository = UserRepository(this);
  }

  @override
  UserInformationState get initialState => UserInformationInitial();

  @override
  Stream<UserInformationState> mapEventToState(UserInformationEvent event) async* {
    if(event is UserInformationStarted) {
      yield UserInformationInitial();
      User userInformation = await _userRepository.getUserInformation();
      yield UserInformationLoaded(user: userInformation);
    }
  }
}