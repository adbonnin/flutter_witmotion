import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_witmotion/src/features/bluetooth/presentation/device_details/bluetooth_service_expansion_tile.dart';

class BluetoothDeviceDetailsView extends StatefulWidget {
  const BluetoothDeviceDetailsView({
    Key? key,
    required this.device,
    required this.services,
    required this.onStateChanged,
  }) : super(key: key);

  final BluetoothDevice device;
  final List<BluetoothService> services;
  final ValueChanged<BluetoothDeviceState> onStateChanged;

  @override
  State<BluetoothDeviceDetailsView> createState() => _BluetoothDeviceDetailsViewState();
}

class _BluetoothDeviceDetailsViewState extends State<BluetoothDeviceDetailsView> {
  late StreamSubscription<BluetoothDeviceState> _stateSubscription;

  @override
  void initState() {
    super.initState();
    _stateSubscription = widget.device.state.listen(_handleDeviceState);
  }

  @override
  void dispose() {
    _stateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemBuilder: _buildServiceItem,
      itemCount: widget.services.length,
    );
  }

  Widget _buildServiceItem(BuildContext _, int index) {
    final service = widget.services[index];

    return BluetoothServiceTile(
      service: service,
    );
  }

  void _handleDeviceState(BluetoothDeviceState state) {
    widget.onStateChanged(state);
  }
}
