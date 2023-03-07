import 'package:flutter/material.dart';
import './mask_view.dart';
import 'package:camera/camera.dart';

enum ValidationStep { CARDFRONT, CARDBACK, FACE }

class SdkConfig {
  Size screenSize;
  MaskView maskViewSize;
  ValidationStep step;
  CameraDescription cameraDescription;
  SdkConfig(
      this.screenSize, this.maskViewSize, this.step, this.cameraDescription);
}
