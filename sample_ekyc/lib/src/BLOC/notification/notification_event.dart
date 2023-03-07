part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class NotificationCatchOTPEvent extends NotificationEvent {
  final NotificationOtp smartOTPModel;

  NotificationCatchOTPEvent({
    required this.smartOTPModel,
  });
}

class NotificationCleanEvent extends NotificationEvent {}
