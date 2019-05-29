import 'package:flutter/material.dart';
import 'src/app.dart';
import 'package:bloc/bloc.dart';
import 'package:ddish/src/repositiories/user_repository.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App(userRepository: UserRepository()));
}