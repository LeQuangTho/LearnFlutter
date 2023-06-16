import 'package:flutter_test/flutter_test.dart';
import 'package:f_plugin/f_plugin.dart';
import 'package:f_plugin/f_plugin_platform_interface.dart';
import 'package:f_plugin/f_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFPluginPlatform
    with MockPlatformInterfaceMixin
    implements FPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FPluginPlatform initialPlatform = FPluginPlatform.instance;

  test('$MethodChannelFPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFPlugin>());
  });

  test('getPlatformVersion', () async {
    FPlugin fPlugin = FPlugin();
    MockFPluginPlatform fakePlatform = MockFPluginPlatform();
    FPluginPlatform.instance = fakePlatform;

    expect(await fPlugin.getPlatformVersion(), '42');
  });
}
