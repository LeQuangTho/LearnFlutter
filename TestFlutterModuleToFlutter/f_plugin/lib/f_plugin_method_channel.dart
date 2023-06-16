import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'f_plugin_platform_interface.dart';

/// An implementation of [FPluginPlatform] that uses method channels.
class MethodChannelFPlugin extends FPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('f_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
