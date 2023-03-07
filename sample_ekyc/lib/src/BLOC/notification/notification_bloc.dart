import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hdsaison_signing/src/helpers/untils/logger.dart';

import 'models/otp_model.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationOtp? cachedOTPModel;
  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationCatchOTPEvent>(_onCatchOTPEvent);
    on<NotificationCleanEvent>(_onCleanEvent);
  }

  void _onCatchOTPEvent(
    NotificationCatchOTPEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(_loading);
    _clean();
    _catchOTP(oTPModel: event.smartOTPModel);
    if (cachedOTPModel != null) {
      emit(_loaded);
    } else {
      emit(NotificationInitial());
    }
  }

  void _onCleanEvent(
    NotificationCleanEvent event,
    Emitter<NotificationState> emit,
  ) {
    _clean();
    emit(NotificationInitial());
  }

  NotificationLoading get _loading =>
      NotificationLoading(smartOTP: cachedOTPModel ?? NotificationOtp.empty);
  NotificationLoaded get _loaded =>
      NotificationLoaded(smartOTP: cachedOTPModel!);

  void _catchOTP({required NotificationOtp oTPModel}) {
    cachedOTPModel = oTPModel;
    UtilLogger.log('NotificationBloc', 'OTP: ${cachedOTPModel?.otp}');
  }

  void _clean() {
    cachedOTPModel = null;
  }
}
