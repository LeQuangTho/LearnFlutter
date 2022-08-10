import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_example/app/login_app.dart';
import 'package:bloc_example/counter_observer.dart';
import 'package:flutter/widgets.dart';
import 'package:user_repository/user_repository.dart';

// void main() {
//   BlocOverrides.runZoned(
//     () => runApp(const CounterApp()),
//     blocObserver: CounterObserver(),
//   );
// }

// void main() {
//   BlocOverrides.runZoned(
//     () => runApp(const TimerApp()),
//     blocObserver: CounterObserver(),
//   );
// }

void main() {
  Bloc.observer = CounterObserver();
  // runApp(const CounterApp());
  // runApp(const TimerApp());
  // runApp(const InfiniteListApp());
  runApp(
    LoginApp(
      authenticationRepository: AuthenticationRepository(),
      userRepository: UserRepository(),
    ),
  );
}
