import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_witmotion/src/features/bluetooth/presentation/device_details/bluetooth_characteristic_value_dialog.dart';

class BluetoothCharacteristicListItem extends StatefulWidget {
  const BluetoothCharacteristicListItem({
    Key? key,
    required this.characteristic,
  }) : super(key: key);

  final BluetoothCharacteristic characteristic;

  @override
  State<BluetoothCharacteristicListItem> createState() => _BluetoothCharacteristicListItemState();
}

class _BluetoothCharacteristicListItemState extends State<BluetoothCharacteristicListItem> {
  late StreamSubscription<List<int>> _valueSubscription;
  var _value = <int>[];
  var _canValidate = true;

  @override
  void initState() {
    super.initState();
    _valueSubscription = widget.characteristic.value.listen(_handleValue);
  }

  @override
  void dispose() {
    _valueSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final properties = widget.characteristic.properties;
    final uuid = widget.characteristic.uuid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('uuid: $uuid'),
        Text('value: $_value'),
        Row(
          children: [
            if (properties.read)
              OutlinedButton(
                onPressed: _onReadPressed,
                child: const Text("READ"),
              ),
            if (properties.write)
              OutlinedButton(
                onPressed: _onWritePressed,
                child: const Text("WRITE"),
              ),
            if (properties.notify)
              OutlinedButton(
                onPressed: _canValidate ? _onNotifyPressed : null,
                child: const Text("NOTIFY"),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _onReadPressed() {
    return widget.characteristic.read();
  }

  Future<void> _onWritePressed() async {
    final value = await showBluetoothCharacteristicValueDialog(context);

    if (value != null) {
      widget.characteristic.write(utf8.encode(value));
    }
  }

  Future<void> _onNotifyPressed() async {
    try {
      await widget.characteristic.setNotifyValue(!widget.characteristic.isNotifying);
    } //
    catch (e) {
      if (mounted) {
        setState(() {
          _canValidate = false;
        });
      }
    }
  }

  void _handleValue(List<int> value) {
    if (mounted) {
      setState(() {
        _value = value;
      });
    }
  }
}
