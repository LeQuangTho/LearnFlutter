import 'package:next_ble/next_ble.dart';
import 'package:next_ble_example/src/ble/reactive_state.dart';

class BleStatusMonitor implements ReactiveState<BleStatus?> {
  const BleStatusMonitor(this._ble);

  final NextBle _ble;

  @override
  Stream<BleStatus?> get state => _ble.statusStream;
}
