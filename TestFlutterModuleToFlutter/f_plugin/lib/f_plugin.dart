
import 'f_plugin_platform_interface.dart';

class FPlugin {
  Future<String?> getPlatformVersion() {
    return FPluginPlatform.instance.getPlatformVersion();
  }
}
