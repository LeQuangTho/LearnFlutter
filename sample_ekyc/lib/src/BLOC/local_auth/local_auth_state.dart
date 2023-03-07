part of 'local_auth_bloc.dart';

abstract class LocalAuthState extends Equatable {
  const LocalAuthState();

  @override
  List<Object> get props => [];
}

class LocalAuthInitial extends LocalAuthState {}

class LocalAuthUnAuthenticated extends LocalAuthState {
  final List<BiometricType> biometricTypes;
  LocalAuthUnAuthenticated({
    required this.biometricTypes,
  });
  @override
  List<Object> get props => [biometricTypes];
}

class LocalAuthProcessing extends LocalAuthState {
  final List<BiometricType> biometricTypes;
  final BiometricAccount account;
  final String cachedUsername;
  final String cachesPassword;

  LocalAuthProcessing({
    required this.biometricTypes,
    required this.account,
    required this.cachedUsername,
    required this.cachesPassword,
  });
  @override
  List<Object> get props =>
      [biometricTypes, account, cachedUsername, cachesPassword];
}

class LocalAuthAuthenticated extends LocalAuthState {
  final List<BiometricType> biometricTypes;
  final BiometricAccount account;
  final String cachedUsername;
  final String cachesPassword;

  LocalAuthAuthenticated({
    required this.biometricTypes,
    required this.account,
    required this.cachedUsername,
    required this.cachesPassword,
  });
  List<Object> get props =>
      [biometricTypes, account, cachedUsername, cachesPassword];
}
