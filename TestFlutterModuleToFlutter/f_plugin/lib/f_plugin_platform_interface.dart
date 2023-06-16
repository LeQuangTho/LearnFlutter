import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'f_plugin_method_channel.dart';

abstract class FPluginPlatform extends PlatformInterface {
  /// Constructs a FPluginPlatform.
  FPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FPluginPlatform _instance = MethodChannelFPlugin();

  /// The default instance of [FPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFPlugin].
  static FPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FPluginPlatform] when
  /// they register themselves.
  static set instance(FPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
