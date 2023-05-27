import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothDeviceListItem extends StatelessWidget {
  const BluetoothDeviceListItem({
    Key? key,
    required this.device,
    required this.onPressed,
  }) : super(key: key);

  final BluetoothDevice device;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(device.name == '' ? '(unknown device)' : device.name),
              Text(device.id.toString()),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text('Connect'),
        ),
      ],
    );
  }
}
