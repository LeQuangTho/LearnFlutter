import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:ffi/ffi.dart';
import 'package:image/image.dart' as imglib;

typedef convert_func = Pointer<Uint32> Function(
    Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, Int32, Int32, Int32, Int32);
typedef Convert = Pointer<Uint32> Function(
    Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, int, int, int, int);

class ImageConverter {
  DynamicLibrary convertImageLib = Platform.isAndroid
      ? DynamicLibrary.open("libconvertImage.so")
      : DynamicLibrary.process();
  late Convert conv;

  ImageConverter() {
    conv = convertImageLib
        .lookup<NativeFunction<convert_func>>('convertImage')
        .asFunction<Convert>();
  }

  imglib.Image convertYuvToRGBByC(CameraImage _savedImage) {
    int startCalloc = DateTime.now().millisecondsSinceEpoch;
    Pointer<Uint8> p = calloc(_savedImage.planes[0].bytes.length);
    Pointer<Uint8> p1 = calloc(_savedImage.planes[1].bytes.length);
    Pointer<Uint8> p2 = calloc(_savedImage.planes[2].bytes.length);
    print(
        "Processing calloc time = ${DateTime.now().millisecondsSinceEpoch - startCalloc}");

    int startGetPointerList = DateTime.now().millisecondsSinceEpoch;
    // Assign the planes data to the pointers of the image
    Uint8List pointerList = p.asTypedList(_savedImage.planes[0].bytes.length);
    Uint8List pointerList1 = p1.asTypedList(_savedImage.planes[1].bytes.length);
    Uint8List pointerList2 = p2.asTypedList(_savedImage.planes[2].bytes.length);
    print(
        "Processing startGetPointerList = ${DateTime.now().millisecondsSinceEpoch - startGetPointerList}");

    int setRange = DateTime.now().millisecondsSinceEpoch;
    pointerList.setRange(
        0, _savedImage.planes[0].bytes.length, _savedImage.planes[0].bytes);
    pointerList1.setRange(
        0, _savedImage.planes[1].bytes.length, _savedImage.planes[1].bytes);
    pointerList2.setRange(
        0, _savedImage.planes[2].bytes.length, _savedImage.planes[2].bytes);
    print(
        "Processing setRange = ${DateTime.now().millisecondsSinceEpoch - setRange}");

    int a4 = DateTime.now().millisecondsSinceEpoch;
    // Call the convertImage function and convert the YUV to RGB
    Pointer<Uint32> imgP = conv(
        p,
        p1,
        p2,
        _savedImage.planes[1].bytesPerRow,
        _savedImage.planes[1].bytesPerPixel!,
        _savedImage.planes[0].bytesPerRow,
        _savedImage.height);
    print("Processing convert time = " +
        (DateTime.now().millisecondsSinceEpoch - a4).toString());

    int a = DateTime.now().millisecondsSinceEpoch;
    // Get the pointer of the data returned from the function to a List
    List<int> imgData = imgP
        .asTypedList((_savedImage.planes[0].bytesPerRow * _savedImage.height));
    // Generate image from the converted data
    imglib.Image img = imglib.Image.fromBytes(
        _savedImage.height, _savedImage.planes[0].bytesPerRow, imgData);
    print("Processing convert to RGB time = " +
        (DateTime.now().millisecondsSinceEpoch - a).toString());

    // Free the memory space allocated
    // from the planes and the converted data
    int a2 = DateTime.now().millisecondsSinceEpoch;
    calloc.free(p);
    calloc.free(p1);
    calloc.free(p2);
    calloc.free(imgP);
    print("Processing free time =" +
        (DateTime.now().millisecondsSinceEpoch - a2).toString());

    return img;
  }

  List<int> convertYuvToRGBByteListByC(CameraImage _savedImage) {
    int startCalloc = DateTime.now().millisecondsSinceEpoch;
    Pointer<Uint8> p = calloc(_savedImage.planes[0].bytes.length);
    Pointer<Uint8> p1 = calloc(_savedImage.planes[1].bytes.length);
    Pointer<Uint8> p2 = calloc(_savedImage.planes[2].bytes.length);
    print(
        "Processing calloc time = ${DateTime.now().millisecondsSinceEpoch - startCalloc}");

    int startGetPointerList = DateTime.now().millisecondsSinceEpoch;
    // Assign the planes data to the pointers of the image
    Uint8List pointerList = p.asTypedList(_savedImage.planes[0].bytes.length);
    Uint8List pointerList1 = p1.asTypedList(_savedImage.planes[1].bytes.length);
    Uint8List pointerList2 = p2.asTypedList(_savedImage.planes[2].bytes.length);
    print(
        "Processing startGetPointerList = ${DateTime.now().millisecondsSinceEpoch - startGetPointerList}");

    int setRange = DateTime.now().millisecondsSinceEpoch;
    pointerList.setRange(
        0, _savedImage.planes[0].bytes.length, _savedImage.planes[0].bytes);
    pointerList1.setRange(
        0, _savedImage.planes[1].bytes.length, _savedImage.planes[1].bytes);
    pointerList2.setRange(
        0, _savedImage.planes[2].bytes.length, _savedImage.planes[2].bytes);
    print(
        "Processing setRange = ${DateTime.now().millisecondsSinceEpoch - setRange}");

    int a4 = DateTime.now().millisecondsSinceEpoch;
    // Call the convertImage function and convert the YUV to RGB
    Pointer<Uint32> imgP = conv(
        p,
        p1,
        p2,
        _savedImage.planes[1].bytesPerRow,
        _savedImage.planes[1].bytesPerPixel!,
        _savedImage.planes[0].bytesPerRow,
        _savedImage.height);
    print("Processing convert time = " +
        (DateTime.now().millisecondsSinceEpoch - a4).toString());

    int a = DateTime.now().millisecondsSinceEpoch;
    // Get the pointer of the data returned from the function to a List
    List<int> imgData = imgP
        .asTypedList((_savedImage.planes[0].bytesPerRow * _savedImage.height));

    // Free the memory space allocated
    // from the planes and the converted data
    int a2 = DateTime.now().millisecondsSinceEpoch;
    calloc.free(p);
    calloc.free(p1);
    calloc.free(p2);
    calloc.free(imgP);
    print("Processing free time =" +
        (DateTime.now().millisecondsSinceEpoch - a2).toString());

    return imgData;
  }
}
