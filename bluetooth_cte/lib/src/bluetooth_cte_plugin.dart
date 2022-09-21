import 'dart:async';

import 'package:bluetooth_cte/src/bluetooth_discovery_result.dart';
import 'package:flutter/services.dart';

import 'bluetooth_device.dart';

class BluetoothCTEPlugin {
  static const String pluginName = "bluetooth_cte_plugin";
  static const MethodChannel _channel = MethodChannel(pluginName);
  static const EventChannel _discoveryChannel =
      EventChannel("$pluginName/discovery");

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> openSetting() async {
    _channel.invokeMethod("openSetting");
  }

  static Future<String?> getName() async {
    return await _channel.invokeMethod("getName");
  }

  static Future<String?> getAddress() async {
    return await _channel.invokeMethod("getAddress");
  }

  static Future<void> requestDiscoverable(int durationInSeconds) async =>
      await _channel
          .invokeMethod("requestDiscoverable", {"duration": durationInSeconds});

  static Stream<BluetoothDiscoveryResult> startDiscovery() async* {
    late StreamSubscription subscription;
    StreamController controller;

    controller = StreamController(
      onCancel: () {
        // `cancelDiscovery` happens automaticly by platform code when closing event sink
        subscription.cancel();
      },
    );

    await _channel.invokeMethod('startDiscovery');

    subscription = _discoveryChannel.receiveBroadcastStream().listen(
          controller.add,
          onError: controller.addError,
          onDone: controller.close,
        );

    yield* controller.stream
        .map((map) => BluetoothDiscoveryResult.fromMap(map));
  }

  /// Returns list of bonded devices.
  static Future<List<BluetoothDevice>> getBondedDevices() async {
    final List list = await (_channel.invokeMethod('getBondedDevices'));
    return list.map((map) => BluetoothDevice.fromMap(map)).toList();
  }
}
