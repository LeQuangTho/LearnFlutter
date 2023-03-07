// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:ekyc_flutter_sdk/ekyc_flutter_sdk.dart';
// import 'dart:async';
// import 'package:uiux_ekyc_flutter_sdk/src/helper/face_validation_status.dart';
// import 'package:uiux_ekyc_flutter_sdk/src/provider/face_validation_provider.dart';
// import 'package:uiux_ekyc_flutter_sdk/src/widgets/face_scanner.dart';
// import 'package:provider/provider.dart';
// import 'package:uiux_ekyc_flutter_sdk/src/callback/face_validation_callback.dart';
// // import 'package:uiux_ekyc_flutter_sdk/src/view_model/face_validation_viewmodel.dart';
// import 'package:ekyc_logic/ekyc_logic.dart';

// class FaceValidationViewTest extends StatefulWidget {
//   FaceValidationCallback faceValidationCallback;
//   FaceValidationViewTest({Key? key, required this.faceValidationCallback})
//       : super(key: key);

//   @override
//   _FaceValidationViewTestState createState() => _FaceValidationViewTestState();
// }

// class _FaceValidationViewTestState extends State<FaceValidationViewTest>
//     with WidgetsBindingObserver, TickerProviderStateMixin {
//   CameraController? cameraController;
//   bool isCameraReady = false;
//   late CameraImage currentImage;
//   late double screenWidth, screenHeight;
//   late double _cardAreaLeft, _cardAreaTop, _cardAreaHeight, _cardAreaWidth;
//   FaceValidation? faceValidation;
//   Color boderColor = Colors.white;
//   bool isInit = false;
//   CameraDescription? choosenCamera;
//   FaceValidationNotifier faceValidationNotifier =
//       FaceValidationNotifier(currentStatus: FaceValidationStatus.WAITING);
//   late FaceValidationCallback faceValidationCallback;
//   late FaceValidationViewModel _faceValidationViewModel;

//   int countFailFrame = 0;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     faceValidationCallback = widget.faceValidationCallback;
//     initializeCamera();
//   }

//   Future<void> initializeCamera() async {
//     if (cameraController != null) cameraController!.dispose();
//     final cameras = await availableCameras();
//     for (int i = 0; i < cameras.length; i++) {
//       if (cameras[i].lensDirection == CameraLensDirection.front) {
//         choosenCamera = cameras[i];
//         break;
//       }
//     }
//     if (choosenCamera == null) {
//       print("Can't select camera !!!");
//       return;
//     }
//     cameraController = CameraController(choosenCamera!, ResolutionPreset.high,
//         enableAudio: false);

//     cameraController!.addListener(() {
//       if (mounted) {
//         setState(() {});
//       }
//     });

//     if (cameraController!.value.hasError) {
//       print('Camera Error ${cameraController!.value.errorDescription}');
//     }

//     try {
//       await cameraController!.initialize().then((_) => {
//             setState(() {
//               isCameraReady = true;
//             })
//           });
//     } catch (e) {
//       print('Camera Error ${e}');
//     }

//     if (mounted) {
//       setState(() {});
//     }

//     if (cameraController != null && cameraController!.value.isInitialized) {
//       cameraController!.startImageStream((CameraImage image) {
//         if (_faceValidationViewModel != null) {
//           _faceValidationViewModel.runDetect(image);
//         }
//       });
//     }
//   }

//   Future<void> _disposeCamera() async {
//     setState(() {
//       isCameraReady = false;
//     });
//     Future<void>.delayed(const Duration(milliseconds: 200), () {
//       if (cameraController != null) {
//         cameraController!.dispose();
//         cameraController = null;
//       }
//     });
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//     } else if (state == AppLifecycleState.inactive) {
//       _disposeCamera();
//     } else if (state == AppLifecycleState.paused) {
//       _disposeCamera();
//     } else if (state == AppLifecycleState.detached) {
//       _disposeCamera();
//     }
//   }

//   @override
//   void dispose() {
//     if (cameraController != null) {
//       cameraController!.dispose();
//     }
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   void realTimeCallBack(List<Detection> detection, bool livenessResult,
//       double leftAndRigtPercent, FaceValidationViewModelStep currentStep) {
//     print("Hubert detection.len = ${detection.length}");
//     print("Hubert livenessResult = ${livenessResult}");
//     print("Hubert leftAndRigtPercent = ${leftAndRigtPercent}");
//     print("Hubert currentStep = ${currentStep}");
//   }

//   void faceValidationResult(
//       bool inSuccess, FaceValidationViewModelStep currentStep) {
//     print("Hubert inSuccess = ${inSuccess}");
//     print("Hubert currentStep = ${currentStep}");
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;
//     getScannerSize();
//     if (!isInit && choosenCamera != null && isCameraReady) {
//       // print("init _faceValidationViewModel");
//       // _faceValidationViewModel = FaceValidationViewModel(
//       //     realTimeCallBack, faceValidationResult,
//       //     screenSize: MediaQuery.of(context).size,
//       //     choosenCamera: choosenCamera,
//       //     cardAreaLeft: _cardAreaLeft,
//       //     cardAreaTop: _cardAreaTop,
//       //     cardAreaWidth: _cardAreaWidth,
//       //     cardAreaHeight: _cardAreaHeight);
//       // isInit = true;
//     }
//     return getBody();
//   }

//   void getScannerSize() {
//     const _CARD_ASPECT_RATIO = 1.25 / 1;
//     const _OFFSET_X_FACTOR = 0.15;
//     final screenRatio = screenWidth / screenHeight;

//     _cardAreaLeft = _OFFSET_X_FACTOR * screenWidth.round();
//     _cardAreaWidth = screenWidth.round() - _cardAreaLeft * 2;
//     _cardAreaHeight = _cardAreaWidth * _CARD_ASPECT_RATIO;
//     _cardAreaTop =
//         (screenHeight.round() - screenHeight.round() * 0.15 - _cardAreaHeight) /
//             2;
//   }

//   getBody() {
//     var scale = 1.0;
//     final size = MediaQuery.of(context).size;
//     if (isCameraReady) {
//       var camera = cameraController!.value;
//       scale = size.aspectRatio * camera.aspectRatio;
//       if (scale < 1) scale = 1 / scale;
//     }
//     return SafeArea(
//       bottom: false,
//       top: false,
//       child: Container(
//         height: size.height,
//         width: size.width,
//         child: Stack(
//           fit: StackFit.expand,
//           children: <Widget>[
//             Transform.scale(
//               scale: scale,
//               child: isCameraReady
//                   ? Center(
//                       child: CameraPreview(cameraController!),
//                     )
//                   : Center(child: CircularProgressIndicator()),
//             ),
//             Container(
//               decoration: ShapeDecoration(
//                 shape: FaceScannerOverlayShape(
//                   borderColor: faceValidationNotifier.faceMaskBorderColor,
//                   borderRadius: 12,
//                   borderLength: 32,
//                   borderWidth: 4,
//                 ),
//               ),
//             ),
//             Positioned(
//               top: _cardAreaTop + _cardAreaHeight / 2 - 70 / 2,
//               left: _cardAreaLeft + _cardAreaWidth / 2 - 160 / 2,
//               child: SizedBox(
//                 child: faceValidationNotifier.arrowPath != null
//                     ? Image.asset(
//                         AssetImage(faceValidationNotifier.arrowPath!).assetName,
//                         package: 'uiux_ekyc_flutter_sdk')
//                     : Container(),
//                 height: 70,
//                 width: 160,
//               ),
//             ),
//             Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding: EdgeInsets.only(top: size.height * 0.15),
//                 child: Text(
//                   faceValidationNotifier.validationResult,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.normal,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: EdgeInsets.only(top: size.height * 0.05),
//                 child: Container(
//                   height: size.height * 0.3,
//                   margin: EdgeInsets.all(16),
//                   child: Column(
//                     children: <Widget>[
//                       SizedBox(
//                         child: faceValidationNotifier.iconPath != null
//                             ? Image.asset(
//                                 AssetImage(faceValidationNotifier.iconPath!)
//                                     .assetName,
//                                 package: 'uiux_ekyc_flutter_sdk',
//                               )
//                             : Container(),
//                         height: 70,
//                         width: 70,
//                       ),
//                       const SizedBox(height: 10),
//                       Container(
//                         width: size.width,
//                         child: SizedBox(
//                           width: 80,
//                           height: 80,
//                           child: faceValidationNotifier.canStart
//                               ? InkWell(
//                                   onTap: () {},
//                                   child: Image.asset(
//                                       const AssetImage(
//                                               "assets/images/ic_capture.png")
//                                           .assetName,
//                                       package: 'uiux_ekyc_flutter_sdk'),
//                                 )
//                               : Image.asset(
//                                   const AssetImage(
//                                           "assets/images/ic_capture_disabled.png")
//                                       .assetName,
//                                   package: 'uiux_ekyc_flutter_sdk'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
