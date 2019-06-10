import 'package:bloc/bloc.dart';
import 'package:ddish/src/repositiories/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:ddish/src/models/user.dart';
import 'user_information_event.dart';
import 'user_information_state.dart';

class UserInformationBloc extends Bloc<UserInformationEvent, UserInformationState>{
  final UserRepository userRepository;

  UserInformationBloc({
    @required this.userRepository});

  @override
  UserInformationState get initialState => UserInformationInitial();

  @override
  Stream<UserInformationState> mapEventToState(UserInformationEvent event) async* {
    if(event is UserInformationStarted) {
      yield UserInformationInitial();
      User userInformation = await userRepository.getUserInformation();
      yield UserInformationLoaded(user: userInformation);
    }
  }
}