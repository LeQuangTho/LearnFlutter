part of 'ekyc_bloc.dart';

abstract class EkycState {}

class EkycInitial extends EkycState {}

class EkycCameraReadyState extends EkycState {
  final CameraController cameraController;
  final VideoPlayerController? videoPlayerController;
  final Map<String, XFile?> images;
  final int currentStep;
  final bool needShowTutorial;
  final bool isPlaying;

  EkycCameraReadyState({
    required this.images,
    required this.cameraController,
    required this.currentStep,
    required this.needShowTutorial,
    required this.videoPlayerController,
    required this.isPlaying,
  });
}

class EkycGettingDataInprogressState extends EkycState {}

class EkycVideoRecordingState extends EkycState {}

class EkycVideoDoneState extends EkycState {}

class EkycGetCompletedState extends EkycState {
  final EkycOCRResponse? ekycResponseModel;
  final EkycPutDataResponseDataEntry? ekycPutDataResponseDataEntry;
  EkycGetCompletedState({
    required this.ekycResponseModel,
    required this.ekycPutDataResponseDataEntry,
  });
}
