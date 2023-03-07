part of 'ekyc_bloc.dart';

abstract class EkycEvent {}

class EkycSetupFirstCameraEvent extends EkycEvent {}

class EkycSetupSecondaryCameraEvent extends EkycEvent {}

class EkycTakeFacePictureEvent extends EkycEvent {}

class EkycTakeFrontPictureEvent extends EkycEvent {}

class EkycTakeBackPictureEvent extends EkycEvent {}

class EkycTakePassportPictureEvent extends EkycEvent {}

class EkycChangeCameraEvent extends EkycEvent {}

class EkycGetOCRResultEvent extends EkycEvent {}

class EkycPutFormDataEvent extends EkycEvent {
  final EkycModifyFormModel ekycModifyFormModel;
  EkycPutFormDataEvent({
    required this.ekycModifyFormModel,
  });
}

class EkycMovingForwardStepEvent extends EkycEvent {
  final int newStep;
  EkycMovingForwardStepEvent({
    required this.newStep,
  });
}

class EkycRetryEvent extends EkycEvent {}

class EkycSetupVideoCallEvent extends EkycEvent {}

class EkycCleanDataEvent extends EkycEvent {}

class EkycDisableTutorialEvent extends EkycEvent {}

class EkycStartRecordVideoCccdEvent extends EkycEvent {}

class EkycStopRecordVideoCccdEvent extends EkycEvent {}

class EkycStartRecordVideoFaceEvent extends EkycEvent {}

class EkycStopRecordVideoFaceEvent extends EkycEvent {}

class EkycStartRecordVideoVerifyInfoEvent extends EkycEvent {}

class EkycStopRecordVideoVerifyInfoEvent extends EkycEvent {}

class EkycPlayingVideoEvent extends EkycEvent {}

class EkycStopedVideoEvent extends EkycEvent {}

class EkycCreateEformRequestDiCerEvent extends EkycEvent {
  final String? certValidTime;
  final EKycSessionInfor? info;
  EkycCreateEformRequestDiCerEvent({
    this.certValidTime,
    this.info,
  });
}

class EkycConfirmEformRequestDiCerEvent extends EkycEvent {
  final String? documentCode;
  EkycConfirmEformRequestDiCerEvent({
    required this.documentCode,
  });
}

class EkycAddCTSEvent extends EkycEvent {}

class EkycUploadFileEvent extends EkycEvent {
  final File file;
  final String fileName;
  final String? routeReplace;
  final String? routePush;
  EkycUploadFileEvent({
    required this.file,
    required this.fileName,
    this.routeReplace,
    this.routePush,
  });
}

class EkycGetOcrInfo extends EkycEvent {}
