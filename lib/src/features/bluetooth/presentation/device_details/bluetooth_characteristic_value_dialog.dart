import 'package:flutter/material.dart';

Future<String?> showBluetoothCharacteristicValueDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => const BluetoothCharacteristicValueDialog(),
  );
}

class BluetoothCharacteristicValueDialog extends StatefulWidget {
  const BluetoothCharacteristicValueDialog({Key? key}) : super(key: key);

  @override
  State<BluetoothCharacteristicValueDialog> createState() => _BluetoothCharacteristicValueDialogState();
}

class _BluetoothCharacteristicValueDialogState extends State<BluetoothCharacteristicValueDialog> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text("Write"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text("Send"),
          onPressed: () {
            Navigator.pop(context, _textController.value.text);
          },
        ),
        ElevatedButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
