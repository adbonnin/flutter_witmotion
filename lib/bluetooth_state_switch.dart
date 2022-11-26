import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_witmotion/application/bluetooth_state_provider.dart';

class BluetoothStateSwitch extends ConsumerWidget {
  const BluetoothStateSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBluetoothState = ref.watch(bluetoothStateProvider);


    return asyncBluetoothState.when(
      data: data, error: (error, _) =>, loading: () => const Switch(value: false, onChanged: null),);
  }


}
