import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_witmotion/src/features/bluetooth/presentation/device_list/bluetooth_device_list_item.dart';

class BluetoothDeviceListView extends StatelessWidget {
  const BluetoothDeviceListView({
    Key? key,
    required this.devices,
    required this.onDevicePressed,
  }) : super(key: key);

  final List<BluetoothDevice> devices;
  final ValueChanged<BluetoothDevice> onDevicePressed;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: devices.length,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildItem(BuildContext _, int index) {
    final device = devices[index];

    return BluetoothDeviceListItem(
      device: device,
      onPressed: () => onDevicePressed.call(device),
    );
  }
}
