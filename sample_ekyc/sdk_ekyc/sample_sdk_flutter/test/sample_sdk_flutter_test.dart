import 'package:flutter_test/flutter_test.dart';
import 'package:sample_sdk_flutter/sample_sdk_flutter.dart';
import 'package:sample_sdk_flutter/sample_sdk_flutter_platform_interface.dart';
import 'package:sample_sdk_flutter/sample_sdk_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSampleSdkFlutterPlatform 
    with MockPlatformInterfaceMixin
    implements SampleSdkFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SampleSdkFlutterPlatform initialPlatform = SampleSdkFlutterPlatform.instance;

  test('$MethodChannelSampleSdkFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSampleSdkFlutter>());
  });

  // test('getPlatformVersion', () async {
  //   SampleSdkFlutter sampleSdkFlutterPlugin = SampleSdkFlutter();
  //   MockSampleSdkFlutterPlatform fakePlatform = MockSampleSdkFlutterPlatform();
  //   SampleSdkFlutterPlatform.instance = fakePlatform;
  
  //   expect(await sampleSdkFlutterPlugin.getPlatformVersion(), '42');
  // });
}
