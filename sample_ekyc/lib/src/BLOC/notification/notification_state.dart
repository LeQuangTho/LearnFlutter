part of 'notification_bloc.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {
  final NotificationOtp smartOTP;
  NotificationLoading({
    required this.smartOTP,
  });
}

class NotificationLoaded extends NotificationState {
  final NotificationOtp smartOTP;
  NotificationLoaded({
    required this.smartOTP,
  });
}
// class NotificationInitial extends NotificationState {}
// class NotificationInitial extends NotificationState {}
// class NotificationInitial extends NotificationState {}
