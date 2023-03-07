part of sizer;

class SizerUtil {
  /// Device's BoxConstraints
  static late BoxConstraints boxConstraints;

  /// Device's Orientation
  static late Orientation orientation;

  /// Type of Device
  ///
  /// This can either be mobile or tablet
  static late DeviceType deviceType;

  /// Device's Height
  static late double height;

  /// Device's Width
  static late double width;

  /// Sets the Screen's size and Device's Orientation,
  /// BoxConstraints, Height, and Width
  static void setScreenSize(
      BoxConstraints constraints, Orientation currentOrientation) {
    // Sets boxconstraints and orientation
    boxConstraints = constraints;
    orientation = currentOrientation;

    // Sets screen width and height
    if (orientation == Orientation.portrait) {
      width = boxConstraints.maxWidth;
      height = boxConstraints.maxHeight;
    } else {
      width = boxConstraints.maxHeight;
      height = boxConstraints.maxWidth;
    }

    // Sets ScreenType
    if (kIsWeb) {
      deviceType = DeviceType.web;
    } else if (Platform.isAndroid || Platform.isIOS) {
      if ((orientation == Orientation.portrait && width < 600) ||
          (orientation == Orientation.landscape && height < 600)) {
        deviceType = DeviceType.mobile;
      } else {
        deviceType = DeviceType.tablet;
      }
    } else if (Platform.isMacOS) {
      deviceType = DeviceType.mac;
    } else if (Platform.isWindows) {
      deviceType = DeviceType.windows;
    } else if (Platform.isLinux) {
      deviceType = DeviceType.linux;
    } else {
      deviceType = DeviceType.fuchsia;
    }
  }

  //for responsive web
  static getWebResponsiveSize({smallSize, mediumSize, largeSize}) {
    return width < 600
        ? smallSize //'phone'
        : width >= 600 && width <= 1024
            ? mediumSize //'tablet'
            : largeSize; //'desktop';
  }
}

/// Type of Device
///
/// This can be either mobile or tablet
enum DeviceType { mobile, tablet, web, mac, windows, linux, fuchsia }

String checkKey(String key) {
  String value = '';
  switch (key) {
    case 'SO_HD':
      return value = 'Mã hợp đồng';
    case 'HDS_HAN_MUC_TIN_DUNG':
      return value = 'Hạn mức tín dụng';
    case 'HDS_HIEU_LUC_THE':
      return value = 'Hiệu lực thẻ';
    case 'HDS_HO_TEN_TREN_THE':
      return value = 'Chủ thẻ';
    case 'CMND_CCCD_HC':
      return value = 'Số CCCD/CMND';
  }
  return value;
}

String checkStatus(num status) {
  String value = '';
  switch (status) {
    case 1:
      value = 'Chờ tôi ký';
      break;
    case 4:
      value = 'Chờ phê duyệt';
      break;
    case 3:
      value = 'Đã hoàn thành';
      break;
    case 2:
      value = 'Đã từ chối';
      break;
    default:
      value = "";
  }
  return value;
}
