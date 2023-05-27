import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_witmotion/src/features/bluetooth/presentation/device_details/bluetooth_device_details_view.dart';
import 'package:flutter_witmotion/src/features/bluetooth/presentation/device_list/bluetooth_device_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'Flutter Demo Home Page',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final flutterBlue = FlutterBluePlus.instance;

  var _devices = <BluetoothDevice>{};
  BluetoothDevice? _connectedDevice;
  var _connectedServices = <BluetoothService>[];

  @override
  void initState() {
    super.initState();

    flutterBlue.connectedDevices.then(_addDeviceToList);
    flutterBlue.scanResults.listen((r) => _addDeviceToList(r.map((e) => e.device)));
    flutterBlue.startScan();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _connectedDevice != null //
          ? BluetoothDeviceDetailsView(
              device: _connectedDevice!,
              services: _connectedServices,
              onStateChanged: _onStateChanged,
            )
          : BluetoothDeviceListView(
              devices: _devices.toList(),
              onDevicePressed: _onDevicePressed,
            ),
    );
  }

  void _addDeviceToList(Iterable<BluetoothDevice> updatedDevices) {
    setState(() {
      _devices = {
        ..._devices,
        ...updatedDevices,
      };
    });
  }

  void _onStateChanged(BluetoothDeviceState deviceState) {
    final isDisconnected = deviceState == BluetoothDeviceState.disconnecting || //
        deviceState == BluetoothDeviceState.disconnected;

    if (isDisconnected) {
      setState(() {
        _connectedDevice = null;
        _connectedServices = const [];
      });
    }
  }

  Future<void> _onDevicePressed(BluetoothDevice device) async {
    flutterBlue.stopScan();

    try {
      await device.connect(timeout: const Duration(seconds: 4));
    } //
    on PlatformException catch (e) {
      if (e.code != 'already_connected') {
        return;
      }
    } //
    catch (e) {
      return;
    }

    final services = await device.discoverServices();

    setState(() {
      _connectedDevice = device;
      _connectedServices = services;
    });
  }
}
