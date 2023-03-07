import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_sdk_flutter/sample_sdk_flutter_method_channel.dart';

void main() {
  MethodChannelSampleSdkFlutter platform = MethodChannelSampleSdkFlutter();
  const MethodChannel channel = MethodChannel('sample_sdk_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
