import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ekyc_flutter_sdk/ekyc_flutter_sdk.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path_provider/path_provider.dart';

/// ImageUtils
class ImageUtils {
  /// Converts a [CameraImage] in YUV420 format to [imageLib.Image] in RGB format
  static imageLib.Image? convertCameraImage(CameraImage cameraImage) {
    if (cameraImage.format.group == ImageFormatGroup.yuv420) {
      return convertYUV420ToImage(cameraImage);
    } else if (cameraImage.format.group == ImageFormatGroup.bgra8888) {
      return convertBGRA8888ToImage(cameraImage);
    } else {
      return null;
    }
  }

  /// Converts a [CameraImage] in BGRA888 format to [imageLib.Image] in RGB format
  static imageLib.Image convertBGRA8888ToImage(CameraImage cameraImage) {
    imageLib.Image img = imageLib.Image.fromBytes(cameraImage.planes[0].width!,
        cameraImage.planes[0].height!, cameraImage.planes[0].bytes,
        format: imageLib.Format.bgra);
    return img;
  }

  /// Converts a [CameraImage] in YUV420 format to [imageLib.Image] in RGB format
  static imageLib.Image convertYUV420ToImage(CameraImage cameraImage) {
    final int width = cameraImage.width;
    final int height = cameraImage.height;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = imageLib.Image(width, height);

    for (int w = 0; w < width; w++) {
      for (int h = 0; h < height; h++) {
        final int uvIndex =
            uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final int index = h * width + w;

        final y = cameraImage.planes[0].bytes[index];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        image.data[index] = ImageUtils.yuv2rgb(y, u, v);
      }
    }
    return image;
  }

  /// Convert a single YUV pixel to RGB
  static int yuv2rgb(int y, int u, int v) {
    // Convert yuv pixel to rgb
    int r = (y + v * 1436 / 1024 - 179).round();
    int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    int b = (y + u * 1814 / 1024 - 227).round();

    // Clipping RGB values to be inside boundaries [ 0 , 255 ]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }

  static void saveImage(imageLib.Image image, [int i = 0]) async {
    List<int> jpeg = imageLib.JpegEncoder().encodeImage(image);
    final appDir = await getTemporaryDirectory();
    final appPath = appDir.path;
    final fileOnDevice = File('$appPath/out$i.jpg');
    await fileOnDevice.writeAsBytes(jpeg, flush: true);
  }

  static imageLib.Image cropImage(imageLib.Image img, SdkConfig sdkConfig) {
    late double _cardAreaLeftScale;
    late double _cardAreaTopScale;
    late double _cardAreaWidthScale;
    late double _cardAreaHeightScale;

    double sizeAspectRatio = sdkConfig.screenSize.aspectRatio;
    double imageAspectRatio = img.height / img.width;
    double scale = sizeAspectRatio * imageAspectRatio;

    if (scale < 1) {
      // image width fit screen width -> cut image width
      double realImageWidth =
          (sdkConfig.screenSize.height * img.width) / img.height;
      double marginWidth = realImageWidth - sdkConfig.screenSize.width;
      _cardAreaLeftScale =
          (sdkConfig.maskViewSize.left + marginWidth / 2) / realImageWidth;
      _cardAreaTopScale =
          sdkConfig.maskViewSize.top / sdkConfig.screenSize.height;
      _cardAreaWidthScale = sdkConfig.maskViewSize.width / realImageWidth;
      _cardAreaHeightScale =
          sdkConfig.maskViewSize.height / sdkConfig.screenSize.height;
    } else {
      // image height fit screen height -> cut image height
      double realImageHeight =
          (sdkConfig.screenSize.width * img.height) / img.width;
      double marginHeight = realImageHeight - sdkConfig.screenSize.height;

      _cardAreaLeftScale =
          sdkConfig.maskViewSize.left / sdkConfig.screenSize.width;
      _cardAreaTopScale =
          (sdkConfig.maskViewSize.top + marginHeight / 2) / realImageHeight;
      _cardAreaWidthScale =
          sdkConfig.maskViewSize.width / sdkConfig.screenSize.width;
      _cardAreaHeightScale = sdkConfig.maskViewSize.height / realImageHeight;
    }
    return imageLib.copyCrop(
        img,
        (_cardAreaLeftScale * img.width).round(),
        (_cardAreaTopScale * img.height).round(),
        (_cardAreaWidthScale * img.width).round(),
        (_cardAreaHeightScale * img.height).round());
  }
}

imageLib.Image convertYUV420(CameraImage cameraImage) {
  final int? width = cameraImage.width;
  final int? height = cameraImage.height;

  final int? uvRowStride = cameraImage.planes[1].bytesPerRow;
  final int? uvPixelStride = cameraImage.planes[1].bytesPerPixel;

  final image = imageLib.Image(width!, height!);

  for (int w = 0; w < width; w++) {
    for (int h = 0; h < height; h++) {
      final int uvIndex =
          uvPixelStride! * (w / 2).floor() + uvRowStride! * (h / 2).floor();
      final int index = h * width + w;

      final y = cameraImage.planes[0].bytes[index];
      final u = cameraImage.planes[1].bytes[uvIndex];
      final v = cameraImage.planes[2].bytes[uvIndex];

      image.data[index] = yuv2rgb(y, u, v);
    }
  }
  return image;
}

int yuv2rgb(int y, int u, int v) {
  // Convert yuv pixel to rgb
  int r = (y + v * 1436 / 1024 - 179).round();
  int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
  int b = (y + u * 1814 / 1024 - 227).round();

  // Clipping RGB values to be inside boundaries [ 0 , 255 ]
  r = r.clamp(0, 255);
  g = g.clamp(0, 255);
  b = b.clamp(0, 255);

  return 0xff000000 | ((b << 16) & 0xff0000) | ((g << 8) & 0xff00) | (r & 0xff);
}
