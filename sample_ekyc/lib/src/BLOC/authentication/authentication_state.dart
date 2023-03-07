part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Quản lý trạng thái tài khoản

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationRemembered extends AuthenticationState {
  final String username;
  final String password;
  final bool remember;
  final String name;
  AuthenticationRemembered({
    required this.username,
    required this.password,
    required this.remember,
    required this.name,
  });
  @override
  List<Object?> get props => [username, password, remember, name];
}

class AuthenticationInprogress extends AuthenticationState {
  final String username;
  final String password;
  final bool remember;
  final String name;
  AuthenticationInprogress({
    required this.username,
    required this.password,
    required this.remember,
    required this.name,
  });
  @override
  List<Object?> get props => [username, password, remember, name];
}

class AuthenticationSuccess extends AuthenticationState {
  final String username;
  final String password;
  final bool remember;
  final String name;
  AuthenticationSuccess({
    required this.username,
    required this.password,
    required this.remember,
    required this.name,
  });
  @override
  List<Object?> get props => [username, password, remember, name];
}

class AuthenticationFailure extends AuthenticationState {}

class LocalAuthCheckCurrentPasswordFail extends AuthenticationState {}

class LocalAuthCheckCurrentPasswordSuccess extends AuthenticationState {}
