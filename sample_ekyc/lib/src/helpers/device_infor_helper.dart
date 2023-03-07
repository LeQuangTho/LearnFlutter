import 'dart:io';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:hdsaison_signing/src/helpers/firebase_helper.dart';
import 'package:hdsaison_signing/src/repositories/local/user_local_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../BLOC/user_remote/models/forms/esign_get_proposal_form.dart';
import '../BLOC/user_remote/models/forms/esign_put_proposal_form.dart';
import '../BLOC/user_remote/models/forms/esign_request_signing_form.dart';
import 'package:dio/dio.dart';

class DeviceInforHelper {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  static Map<String, dynamic> deviceInfor = {};
  Future<void> initPlatformState() async {
    try {
      if (kIsWeb) {
        deviceInfor =
            _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
        return;
      } else {
        if (Platform.isAndroid) {
          deviceInfor =
              _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
          return;
        } else if (Platform.isIOS) {
          deviceInfor = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
          return;
        } else if (Platform.isLinux) {
          deviceInfor = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
          return;
        } else if (Platform.isMacOS) {
          deviceInfor = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
          return;
        } else if (Platform.isWindows) {
          deviceInfor =
              _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
          return;
        }
      }
    } on PlatformException {
      deviceInfor = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    return;
  }

  Future<String> getIP() async {
    String ipV4 = '0.0.0.0';
    try{
      ipV4  = await Ipify.ipv4();
      return ipV4;
    }catch(e){
    Response response =  await Dio().get('https://ipinfo.io/json');
    if(response.statusCode==200){
      ipV4 = response.data['ip'];
      return ipV4;
    }
    return ipV4;
  }
  }

  Future<String> getAppVersion() async {
    final PackageInfo _infor = await PackageInfo.fromPlatform();
    final String version = _infor.version;
    return version;
  }

  Future<String> getAppBundleId() async {
    final PackageInfo _infor = await PackageInfo.fromPlatform();
    final String packageName = _infor.packageName;
    return packageName;
  }

  Future<String> getAppName() async {
    final PackageInfo _infor = await PackageInfo.fromPlatform();
    final String name = _infor.appName;
    return name;
  }

  Future<Map<dynamic, dynamic>> getDeviceInfor() async {
    Map<dynamic, dynamic> _deviceInfo = {};
    String ip = '';
    ip = await getIP();
    try {
      final String? firebaseToken = await FirebaseHelper().getToken();
      String versionApp = await getAppVersion();
      if (kIsWeb) {
        return {};
      } else {
        if (Platform.isAndroid) {
          _deviceInfo = {
            "device_id": deviceInfor['androidId'],
            "name": deviceInfor['brand'] + "-" + deviceInfor['model'],
            "os": deviceInfor['version.release'],
            "os_version": deviceInfor['version.previewSdkInt'].toString(),
            "firebase_token": firebaseToken,
            "is_physical": true,
            "ip": ip,
            "version_app": versionApp,
          };
          UserLocalRepository().saveDeviceInfor(_deviceInfo);
        } else if (Platform.isIOS) {
          _deviceInfo = {
            "device_id": deviceInfor['identifierForVendor'],
            "name": deviceInfor['name'],
            "os": deviceInfor['systemName'],
            "os_version": deviceInfor['systemVersion'],
            "firebase_token": firebaseToken,
            "is_physical": true,
            "ip": ip,
            "version_app": versionApp,
          };
          UserLocalRepository().saveDeviceInfor(_deviceInfo);
        } else if (Platform.isLinux) {
        } else if (Platform.isMacOS) {
        } else if (Platform.isWindows) {}
        print(_deviceInfo.toString());
        return _deviceInfo;
      }
    } catch (e) {
      print(">>>>>>> $e");
      return _deviceInfo;
    }
  }

  Future<ESignDeviceInfo?> getDeviceInforForPostEsign() async {
    final ESignDeviceInfo? _deviceInfo;

    if (kIsWeb) {
      return null;
    } else {
      if (Platform.isAndroid) {
        _deviceInfo = ESignDeviceInfo(
          deviceType: deviceInfor['version.release'],
          deviceId: deviceInfor['androidId'],
          deviceName: deviceInfor['board'],
        );
        return _deviceInfo;
      } else if (Platform.isIOS) {
        _deviceInfo = ESignDeviceInfo(
          deviceType: deviceInfor['systemName'],
          deviceId: deviceInfor['identifierForVendor'],
          deviceName: deviceInfor['name'],
        );
        return _deviceInfo;
      } else if (Platform.isLinux) {
        return null;
      } else if (Platform.isMacOS) {
        return null;
      } else if (Platform.isWindows) {
        return null;
      }
    }
    return null;
  }

  Future<ESignPutFormDeviceInfo?> getDeviceInforForPutEsign() async {
    final ESignPutFormDeviceInfo? _deviceInfo;

    if (kIsWeb) {
      return null;
    } else {
      if (Platform.isAndroid) {
        _deviceInfo = ESignPutFormDeviceInfo(
          appCodeName: '',
          appName: '',
          appVersion: '',
          language: '',
          deviceType: deviceInfor['version.release'],
          deviceId: deviceInfor['androidId'],
          deviceName: deviceInfor['board'],
        );
        return _deviceInfo;
      } else if (Platform.isIOS) {
        _deviceInfo = ESignPutFormDeviceInfo(
          appCodeName: '',
          appName: '',
          appVersion: '',
          language: '',
          deviceType: deviceInfor['systemName'],
          deviceId: deviceInfor['identifierForVendor'],
          deviceName: deviceInfor['name'],
        );
        return _deviceInfo;
      } else if (Platform.isLinux) {
        return null;
      } else if (Platform.isMacOS) {
        return null;
      } else if (Platform.isWindows) {
        return null;
      }
    }
    return null;
  }

  Future<ESignRequestDeviceInfo?> getDeviceInforForRequestSigning() async {
    final ESignRequestDeviceInfo? _deviceInfo;

    if (kIsWeb) {
      return null;
    } else {
      if (Platform.isAndroid) {
        _deviceInfo = ESignRequestDeviceInfo(
          appCodeName: await getAppBundleId(),
          appName: await getAppName(),
          appVersion: await getAppVersion(),
          language: Intl.getCurrentLocale(),
          appType: 'string',
          deviceType: deviceInfor['version.release'],
          deviceId: deviceInfor['androidId'],
          deviceName: deviceInfor['board'],
        );
        return _deviceInfo;
      } else if (Platform.isIOS) {
        _deviceInfo = ESignRequestDeviceInfo(
          appCodeName: await getAppBundleId(),
          appName: await getAppName(),
          appVersion: await getAppVersion(),
          language: Intl.getCurrentLocale(),
          appType: 'string',
          deviceType: deviceInfor['systemName'],
          deviceId: deviceInfor['identifierForVendor'],
          deviceName: deviceInfor['name'],
        );
        return _deviceInfo;
      } else if (Platform.isLinux) {
        return null;
      } else if (Platform.isMacOS) {
        return null;
      } else if (Platform.isWindows) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      // 'version.securityPatch': build.version.securityPatch,
      // 'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      // 'version.incremental': build.version.incremental,
      // 'version.codename': build.version.codename,
      // 'version.baseOS': build.version.baseOS,
      'board': build.board,
      // 'bootloader': build.bootloader,
      'brand': build.brand,
      // 'device': build.device,
      'display': build.display,
      // 'fingerprint': build.fingerprint,
      // 'hardware': build.hardware,
      // 'host': build.host,
      // 'id': build.id,
      // 'manufacturer': build.manufacturer,
      'model': build.model,
      // 'product': build.product,
      // 'supported32BitAbis': build.supported32BitAbis,
      // 'supported64BitAbis': build.supported64BitAbis,
      // 'supportedAbis': build.supportedAbis,
      // 'tags': build.tags,
      // 'type': build.type,
      // 'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.id,
      // 'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      // 'model': data.model,
      // 'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      // 'isPhysicalDevice': data.isPhysicalDevice,
      // 'utsname.sysname:': data.utsname.sysname,
      // 'utsname.nodename:': data.utsname.nodename,
      // 'utsname.release:': data.utsname.release,
      // 'utsname.version:': data.utsname.version,
      // 'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      // 'name': data.name,
      // 'version': data.version,
      // 'id': data.id,
      // 'idLike': data.idLike,
      // 'versionCodename': data.versionCodename,
      // 'versionId': data.versionId,
      // 'prettyName': data.prettyName,
      // 'buildId': data.buildId,
      // 'variant': data.variant,
      // 'variantId': data.variantId,
      // 'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      // 'browserName': describeEnum(data.browserName),
      // 'appCodeName': data.appCodeName,
      // 'appName': data.appName,
      // 'appVersion': data.appVersion,
      // 'deviceMemory': data.deviceMemory,
      // 'language': data.language,
      // 'languages': data.languages,
      // 'platform': data.platform,
      // 'product': data.product,
      // 'productSub': data.productSub,
      // 'userAgent': data.userAgent,
      // 'vendor': data.vendor,
      // 'vendorSub': data.vendorSub,
      // 'hardwareConcurrency': data.hardwareConcurrency,
      // 'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      // 'computerName': data.computerName,
      // 'hostName': data.hostName,
      // 'arch': data.arch,
      // 'model': data.model,
      // 'kernelVersion': data.kernelVersion,
      // 'osRelease': data.osRelease,
      // 'activeCPUs': data.activeCPUs,
      // 'memorySize': data.memorySize,
      // 'cpuFrequency': data.cpuFrequency,
      // 'systemGUID': data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      // 'numberOfCores': data.numberOfCores,
      // 'computerName': data.computerName,
      // 'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
    };
  }
}
