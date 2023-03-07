import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sample_sdk_flutter_method_channel.dart';

abstract class SampleSdkFlutterPlatform extends PlatformInterface {
  /// Constructs a SampleSdkFlutterPlatform.
  SampleSdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static SampleSdkFlutterPlatform _instance = MethodChannelSampleSdkFlutter();

  /// The default instance of [SampleSdkFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelSampleSdkFlutter].
  static SampleSdkFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SampleSdkFlutterPlatform] when
  /// they register themselves.
  static set instance(SampleSdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
