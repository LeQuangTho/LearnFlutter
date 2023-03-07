part of 'local_auth_bloc.dart';

abstract class LocalAuthEvent extends Equatable {
  const LocalAuthEvent();

  @override
  List<Object> get props => [];
}

class LocalAuthGetBiometricTypesSupportEvent extends LocalAuthEvent {}

class LocalAuthCheckAccountIsActiveBiometricEvent extends LocalAuthEvent {
  final String username;
  final String password;
  LocalAuthCheckAccountIsActiveBiometricEvent({
    required this.username,
    required this.password,
  });
}

class LocalAuthBiometricLoginEvent extends LocalAuthEvent {
  final String username;
  LocalAuthBiometricLoginEvent({
    required this.username,
  });
}

class LocalAuthActiveBiometricEvent extends LocalAuthEvent {
  final String username;
  final String password;
  LocalAuthActiveBiometricEvent({
    required this.username,
    required this.password,
  });
}

class LocalAuthDisableBiometricEvent extends LocalAuthEvent {
  final String username;
  LocalAuthDisableBiometricEvent({
    required this.username,
  });
}

class LocalAuthDisableBiometricNoAuthenEvent extends LocalAuthEvent {
  final String username;
  LocalAuthDisableBiometricNoAuthenEvent({
    required this.username,
  });
}

class LocalAuthBioAuthBeforeActiveEvent extends LocalAuthEvent {}

class LocalAuthCheckBioStatusEvent extends LocalAuthEvent {
  final String username;
  LocalAuthCheckBioStatusEvent({
    required this.username,
  });
}

class LocalAuthCleanCachedDataEvent extends LocalAuthEvent {}
