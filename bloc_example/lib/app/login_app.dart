import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_example/bloc/authentication/authentication_bloc.dart';
import 'package:bloc_example/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class LoginApp extends StatelessWidget {
  const LoginApp(
      {Key? key,
      required this.authenticationRepository,
      required this.userRepository})
      : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (context) => AuthenticationBloc(
          userRepository: userRepository,
          authenticationRepository: authenticationRepository,
        ),
        child: const LoginView(),
      ),
    );
  }
}
