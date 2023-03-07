import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:sample_sdk_flutter/src/models/ekyc_session.dart';
import 'package:video_player/video_player.dart';

import '../../UI/common_widgets/dialogs/show_dialog_animations.dart';
import '../../constants/hard_constants.dart';
import '../../constants/http_status_codes.dart';
import '../../helpers/untils/logger.dart';
import '../../navigations/app_pages.dart';
import '../../navigations/app_routes.dart';
import '../../repositories/remote/ekyc_repository.dart';
import '../app_blocs.dart';
import '../timer/timer_bloc.dart';
import 'models/ekyc_modify_infor_form.dart';
import 'models/ekyc_put_data_response.dart';
import 'models/ekyc_response_model.dart';

part 'ekyc_event.dart';
part 'ekyc_state.dart';

class EkycBloc extends Bloc<EkycEvent, EkycState> {
  late List<CameraDescription> cameras;
  CameraController? cameraController;
  VideoPlayerController? videoPlayerController;
  bool needShowTutorial = true;
  bool isManageCTS = true;
  Map<String, XFile?> images = {
    'front': null,
    'back': null,
    'face': null,
    'passport': null,
    'video_identification': null,
    'video_face': null,
    'video_verify_info': null,
  };
  EkycOCRResponse? ekycOCRResponseModel;
  EkycPutDataResponseDataEntry? ekycPutDataResponseDataEntry;

  EkycBloc() : super(EkycInitial()) {
    on<EkycSetupFirstCameraEvent>(_onSetupFirstCamera);
    on<EkycSetupSecondaryCameraEvent>(_onSetupSecondaryCamera);
    on<EkycTakeFacePictureEvent>(_onTakeFacePicture);
    on<EkycTakePassportPictureEvent>(_onTakePassportPicture);
    on<EkycTakeFrontPictureEvent>(_onTakeFrontPicture);
    on<EkycTakeBackPictureEvent>(_onTakeBackPicture);
    on<EkycStartRecordVideoCccdEvent>(_onStartRecordVideoCccd);
    on<EkycStopRecordVideoCccdEvent>(_onStopRecordVideoCccd);
    on<EkycStartRecordVideoFaceEvent>(_onStartRecordVideoFace);
    on<EkycStopRecordVideoFaceEvent>(_onStopRecordVideoFace);
    on<EkycStartRecordVideoVerifyInfoEvent>(_onStartRecordVideoVerifyInfo);
    on<EkycStopRecordVideoVerifyInfoEvent>(_onStopRecordVideoVerifyInfo);
    on<EkycMovingForwardStepEvent>(_onMovingForwardStep);
    on<EkycCleanDataEvent>(_onCleanData);
    on<EkycDisableTutorialEvent>(_onDisableTutorial);
    on<EkycPlayingVideoEvent>(_onPlayingVideo);
    on<EkycStopedVideoEvent>(_onStopedVideo);
    on<EkycCreateEformRequestDiCerEvent>(_onCreateEformRequestDiCer);
    on<EkycConfirmEformRequestDiCerEvent>(_onConfirmEformRequestDiCer);
    on<EkycAddCTSEvent>(_onAddCTS);
    on<EkycUploadFileEvent>(_onUploadFile);
    on<EkycGetOcrInfo>(_onGetOcrInfo);
  }
  int currentStep = 0;

  bool isPlaying = false;

  void _onSetupFirstCamera(
    EkycSetupFirstCameraEvent event,
    Emitter<EkycState> emit,
  ) async {
    await _initFirstCamera();
    emit(_ekycCameraReadyState);
  }

  void _onSetupSecondaryCamera(
    EkycSetupSecondaryCameraEvent event,
    Emitter<EkycState> emit,
  ) async {
    await _initSecondaryCamera();
    emit(_ekycCameraReadyState);
  }

  void _onTakeFacePicture(
    EkycTakeFacePictureEvent event,
    Emitter<EkycState> emit,
  ) async {
    await _takeFacePicture();
    emit(_ekycCameraReadyState);
  }

  void _onTakePassportPicture(
    EkycTakePassportPictureEvent event,
    Emitter<EkycState> emit,
  ) async {
    await _takePassportPicture();
    emit(_ekycCameraReadyState);
  }

  void _onTakeFrontPicture(
    EkycTakeFrontPictureEvent event,
    Emitter<EkycState> emit,
  ) async {
    await _takeFrontPicture();
    emit(_ekycCameraReadyState);
  }

  void _onTakeBackPicture(
    EkycTakeBackPictureEvent event,
    Emitter<EkycState> emit,
  ) async {
    await _takeBackPicture();
    emit(_ekycCameraReadyState);
  }

  void _onStartRecordVideoCccd(
    EkycStartRecordVideoCccdEvent event,
    Emitter<EkycState> emit,
  ) async {
    await _startRecordCccd();
    AppBlocs.timerBloc.add(StartTimerRecordVideoEvent(
      stopRecordEvent: () =>
          AppBlocs.ekycBloc.add(EkycStopRecordVideoCccdEvent()),
    ));
    emit(_ekycCameraReadyState);
  }

  void _onStopRecordVideoCccd(
    EkycStopRecordVideoCccdEvent event,
    Emitter<EkycState> emit,
  ) async {
    await _stopRecordCccd();
    AppBlocs.timerBloc.add(StopTimerRecordVideoEvent());

    emit(_ekycCameraReadyState);
  }

  void _onStartRecordVideoFace(
    EkycStartRecordVideoFaceEvent event,
    Emitter<EkycState> emit,
  ) async {
    await _startRecordFace();
    emit(_ekycCameraReadyState);
  }

  void _onStopRecordVideoFace(
    EkycStopRecordVideoFaceEvent event,
    Emitter<EkycState> emit,
  ) async {
    await _stopRecordFace();
    emit(_ekycCameraReadyState);
  }

  void _onStartRecordVideoVerifyInfo(
    EkycStartRecordVideoVerifyInfoEvent event,
    Emitter<EkycState> emit,
  ) async {
    await _startRecordVerifyInfo();
    AppBlocs.timerBloc.add(StartTimerRecordVideoEvent(
      stopRecordEvent: () =>
          AppBlocs.ekycBloc.add(EkycStopRecordVideoVerifyInfoEvent()),
    ));
    emit(_ekycCameraReadyState);
  }

  void _onStopRecordVideoVerifyInfo(
    EkycStopRecordVideoVerifyInfoEvent event,
    Emitter<EkycState> emit,
  ) async {
    await _stopRecordVerifyInfo();
    AppBlocs.timerBloc.add(StopTimerRecordVideoEvent());
    emit(_ekycCameraReadyState);
  }

  void _onMovingForwardStep(
    EkycMovingForwardStepEvent event,
    Emitter<EkycState> emit,
  ) async {
    currentStep = event.newStep;
    if (currentStep == 0) {
      emit(_ekycInitial);
    } else {
      emit(_ekycCameraReadyState);
    }
  }

  void _onCleanData(
    EkycCleanDataEvent event,
    Emitter<EkycState> emit,
  ) async {
    if (cameraController != null) {
      _cleanAllImages();
      _disposeCamera();
      emit(_ekycInitial);
    }
  }

  void _onDisableTutorial(
    EkycDisableTutorialEvent event,
    Emitter<EkycState> emit,
  ) async {
    needShowTutorial = false;
    emit(_ekycCameraReadyState);
  }

  void _onPlayingVideo(
    EkycPlayingVideoEvent event,
    Emitter<EkycState> emit,
  ) async {
    videoPlayerController?.play().then((value) {
      isPlaying = true;
    });
    emit(_ekycCameraReadyState);
  }

  void _onStopedVideo(
    EkycStopedVideoEvent event,
    Emitter<EkycState> emit,
  ) async {
    emit(_ekycCameraReadyState);
  }

  void _onCreateEformRequestDiCer(
    EkycCreateEformRequestDiCerEvent event,
    Emitter<EkycState> emit,
  ) async {
    final res = await EkycReporitory().createEformRequestDiCer(event);
    if (res?.code == StatusCode.OK) {
      AppNavigator.replaceWith(Routes.AGREE_DI_CER, arguments: {'eform': res});
    } else {
      AppNavigator.replaceWith(Routes.EKYC_FAILED_VIEW,
          arguments: {'message': res?.message});
      // showToast(ToastType.error, title: res?.message);
    }
  }

  void _onConfirmEformRequestDiCer(
    EkycConfirmEformRequestDiCerEvent event,
    Emitter<EkycState> emit,
  ) async {
    showDialogLoading();
    final res = await EkycReporitory().confirmEformRequestDiCer(event);
    if (res.code == StatusCode.OK) {
      AppNavigator.pop();
      AppNavigator.push(Routes.CHECK_INFO_OCR, arguments: {'data': res.data});
    } else {
      AppNavigator.pop();
      showToast(ToastType.error, title: res.message);
    }
  }

  void _onAddCTS(
    EkycAddCTSEvent event,
    Emitter<EkycState> emit,
  ) async {
    Future.delayed(DELAY_1_S * 2, () async {
      final res = await EkycReporitory().addCTS();
      if (res.code == StatusCode.OK) {
        AppNavigator.push(Routes.REGISTER_DI_CER_SUCCESS,
            arguments: {'idCTS': res.data});
      } else {
        showToast(ToastType.error, title: res.message);
      }
    });
  }

  void _onUploadFile(
    EkycUploadFileEvent event,
    Emitter<EkycState> emit,
  ) async {
    showDialogLoading();
    final res = await EkycReporitory()
        .uploadFile(file: event.file, name: event.fileName);
    if (res.code == StatusCode.OK) {
      AppNavigator.pop();
      if (event.routeReplace != null) {
        AppNavigator.replaceWith(event.routeReplace!);
      }
      if (event.routePush != null) {
        AppNavigator.push(event.routePush!);
      }
    } else {
      AppNavigator.pop();
      showToast(ToastType.error, title: res.message);
    }
  }

  void _onGetOcrInfo(
    EkycGetOcrInfo event,
    Emitter<EkycState> emit,
  ) async {
    showDialogLoading();
    final res = await EkycReporitory().getDetailOcrInfo();
    if (res.code == StatusCode.OK) {
      AppNavigator.pop();
      if (res.data != null) {
        AppNavigator.push(Routes.CHECK_INFO_CCCD,
            arguments: {'detailOcrResponse': res});
      } else {
        showToast(ToastType.error, title: 'Bạn chưa xác thực giấy tờ');
      }
    } else {
      AppNavigator.pop();
      showToast(ToastType.error, title: res.message);
    }
  }
  //* ---------------------------------------------------------------------------

  EkycInitial get _ekycInitial => EkycInitial();

  EkycCameraReadyState get _ekycCameraReadyState => EkycCameraReadyState(
        images: images,
        cameraController: cameraController!,
        currentStep: currentStep,
        needShowTutorial: needShowTutorial,
        videoPlayerController: videoPlayerController,
        isPlaying: isPlaying,
      );

  // MARK: PRIVATE METHODS

  // Steps:
  // 0: Init Front Camera - ready to take Face Picture
  // 1: Camera paused - view face Picture
  // 2: Init Face Camera - ready to take Front Picture
  // 3: Camera paused - view front Picture
  // 4: Init Front Camera - ready to take Back Picture
  // 5: Camera paused - view back Picture

  Future<void> _initFirstCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.high);
    await cameraController?.initialize();
    cameraController?.setZoomLevel(1);
  }

  Future<void> _initSecondaryCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[1], ResolutionPreset.high);
    await cameraController?.initialize();
    cameraController?.setZoomLevel(1);
  }

  Future<void> _takeFacePicture() async {
    showDialogLoading();
    try {
      final XFile _picture = await cameraController!.takePicture();
      images['face'] = _picture;
      cameraController!.pausePreview();
      add(EkycMovingForwardStepEvent(newStep: 2));
    } catch (e) {
      UtilLogger.log('Ekyc Bloc', e);
    }
    AppNavigator.pop();

    return;
  }

  Future<void> _takeFrontPicture() async {
    showDialogLoading();
    try {
      final XFile _picture = await cameraController!.takePicture();
      images['front'] = _picture;

      cameraController!.pausePreview();
      add(EkycMovingForwardStepEvent(newStep: 2));
    } catch (e) {
      UtilLogger.log('Ekyc Bloc', e);
    }
    AppNavigator.pop();

    return;
  }

  Future<void> _takeBackPicture() async {
    showDialogLoading();
    try {
      final XFile _picture = await cameraController!.takePicture();
      images['back'] = _picture;
      cameraController!.pausePreview();
      add(EkycMovingForwardStepEvent(newStep: 4));
      AppNavigator.pop();
    } catch (e) {
      UtilLogger.log('Ekyc Bloc', e);
      AppNavigator.pop();
    }

    return;
  }

  Future<void> _takePassportPicture() async {
    showDialogLoading();
    try {
      final XFile _picture = await cameraController!.takePicture();
      images['passport'] = _picture;
      cameraController!.pausePreview();
      add(EkycMovingForwardStepEvent(newStep: 2));
      AppNavigator.pop();
    } catch (e) {
      UtilLogger.log('Ekyc Bloc', e);
      AppNavigator.pop();
    }

    return;
  }

  Future<void> _startRecordCccd() async {
    showDialogLoading();
    try {
      await cameraController!.prepareForVideoRecording();
      if (cameraController != null && cameraController!.value.isInitialized) {
        cameraController!.startImageStream((CameraImage image) {});
      }
      await cameraController!.startVideoRecording();
      add(EkycMovingForwardStepEvent(newStep: 2));
      AppNavigator.pop();
    } catch (e) {
      UtilLogger.log('Ekyc Bloc', e);
      AppNavigator.pop();
    }

    return;
  }

  Future<void> _stopRecordCccd() async {
    showDialogLoading();
    try {
      final XFile _video = await cameraController!.stopVideoRecording();
      cameraController!.stopImageStream();
      images['video_identification'] = _video;
      add(EkycMovingForwardStepEvent(newStep: 3));
      videoPlayerController = VideoPlayerController.file(File(_video.path))
        ..initialize().then((_) {
          videoPlayerController?.addListener(playVideo);
        });

      AppNavigator.pop();
    } catch (e) {
      UtilLogger.log('Ekyc Bloc', e);
      AppNavigator.pop();
    }

    return;
  }

  Future<void> _startRecordFace() async {
    showDialogLoading();
    try {
      if (cameraController != null && cameraController!.value.isInitialized) {
        cameraController!.startImageStream((CameraImage image) {});
      }
      await cameraController!.startVideoRecording();
      add(EkycMovingForwardStepEvent(newStep: 2));
      AppNavigator.pop();
    } catch (e) {
      UtilLogger.log('Ekyc Bloc', e);
      AppNavigator.pop();
    }

    return;
  }

  Future<void> _stopRecordFace() async {
    showDialogLoading();
    try {
      final XFile _video = await cameraController!.stopVideoRecording();
      cameraController!.stopImageStream();
      images['video_face'] = _video;
      add(EkycMovingForwardStepEvent(newStep: 3));
      videoPlayerController = VideoPlayerController.file(File(_video.path))
        ..initialize().then((_) {});
      videoPlayerController?.addListener(playVideo);
      AppNavigator.pop();
    } catch (e) {
      UtilLogger.log('Ekyc Bloc', e);
      AppNavigator.pop();
    }

    return;
  }

  Future<void> _startRecordVerifyInfo() async {
    showDialogLoading();
    try {
      if (cameraController != null && cameraController!.value.isInitialized) {
        cameraController!.startImageStream((CameraImage image) {});
      }
      await cameraController!.startVideoRecording();
      add(EkycMovingForwardStepEvent(newStep: 2));
      AppNavigator.pop();
    } catch (e) {
      UtilLogger.log('Ekyc Bloc', e);
      AppNavigator.pop();
    }

    return;
  }

  Future<void> _stopRecordVerifyInfo() async {
    showDialogLoading();
    try {
      final XFile _video = await cameraController!.stopVideoRecording();
      cameraController!.stopImageStream();
      images['video_verify_info'] = _video;
      add(EkycMovingForwardStepEvent(newStep: 3));
      videoPlayerController = VideoPlayerController.file(File(_video.path))
        ..initialize().then((_) {});
      videoPlayerController?.addListener(playVideo);
      AppNavigator.pop();
    } catch (e) {
      UtilLogger.log('Ekyc Bloc', e);
      AppNavigator.pop();
    }

    return;
  }

  void playVideo() {
    if (videoPlayerController?.value.isPlaying == true) {
      isPlaying = true;
    } else {
      isPlaying = false;
      add(EkycStopedVideoEvent());
    }
  }

  void _cleanAllImages() {
    images = {
      'front': null,
      'back': null,
      'face': null,
      'passport': null,
      'video_identification': null,
      'video_face': null,
      'video_verify_info': null,
    };
    needShowTutorial = false;
  }

  void _disposeCamera() {
    cameraController?.dispose();
    videoPlayerController?.dispose();
  }
}
