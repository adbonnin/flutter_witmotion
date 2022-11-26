import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_witmotion/application/bluetooth_devices_provider.dart';
import 'package:flutter_witmotion/application/bluetooth_state_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BluetoothApp(),
    );
  }
}

class BluetoothApp extends ConsumerWidget {
  const BluetoothApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bluetoothState = ref.watch(bluetoothStateProvider);
    final bluetoothDevices = ref.watch(bluetoothDevicesProvider);

    return Scaffold(
      body: Column(
        children: [
          Text(bluetoothState.toString()),
          Text(bluetoothDevices.toString()),
        ],
      ),
    );
  }
}

// Future<void> _updatePairedDevices(BluetoothState bluetoothState) async {
//   final bluetoothAppState = await _enableBluetooth(bluetoothState);
//   if (!mounted) {
//     return;
//   }
//
//   state = bluetoothAppState;
//
//   if (!bluetoothAppState.bluetoothEnable) {
//     return;
//   }
//
//   var devices = <BluetoothDevice>[];
//   try {
//     devices = await _bluetooth.getBondedDevices();
//   } //
//   on PlatformException {
//     print("Error");
//   }
//
//   if (!mounted) {
//     return;
//   }
//
//   setState(() => _devices = devices);
// }
