import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_witmotion/application/bluetooth_state_provider.dart';

final bluetoothDevicesProvider = FutureProvider.autoDispose<List<BluetoothDevice>>((ref) async {
  final asyncBluetoothState = ref.watch(bluetoothStateProvider);

  return asyncBluetoothState.maybeWhen(
    data: (value) => value.bluetoothEnable //
        ? FlutterBluetoothSerial.instance.getBondedDevices()
        : Future.value([]),
    orElse: () => [],
  );
});

