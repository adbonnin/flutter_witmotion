import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_witmotion/src/features/bluetooth/presentation/device_details/bluetooth_characteristic_list_item.dart';

class BluetoothServiceTile extends StatelessWidget {
  const BluetoothServiceTile({
    Key? key,
    required this.service,
  }) : super(key: key);

  final BluetoothService service;

  @override
  Widget build(BuildContext context) {
    final characteristics = service.characteristics;
    final title = service.uuid.toString();

    return Card(
      child: characteristics.isEmpty
          ? ListTile(
              title: Text(title),
            )
          : ExpansionTile(
              title: Text(title),
              shape: const Border(
                top: BorderSide(color: Colors.transparent),
                bottom: BorderSide(color: Colors.transparent),
              ),
              expandedAlignment: Alignment.centerLeft,
              childrenPadding: const EdgeInsets.all(8),
              children: [
                for (final characteristic in characteristics) //
                  BluetoothCharacteristicListItem(
                    characteristic: characteristic,
                  ),
              ],
            ),
    );
  }
}
