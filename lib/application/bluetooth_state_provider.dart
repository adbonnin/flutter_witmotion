import 'dart:async';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final bluetoothStateProvider = StateNotifierProvider<BluetoothStateNotifier, AsyncValue<BluetoothAppState>>((ref) => //
    BluetoothStateNotifier(FlutterBluetoothSerial.instance));

class BluetoothStateNotifier extends StateNotifier<AsyncValue<BluetoothAppState>> {
  BluetoothStateNotifier(this.bluetooth) : super(const AsyncValue.loading()) {
    stateSubscription = bluetooth.onStateChanged().listen(_onStateChanged);
    bluetooth.state.then(_onStateChanged);
  }

  final FlutterBluetoothSerial bluetooth;
  late StreamSubscription<BluetoothState> stateSubscription;

  @override
  void dispose() {
    stateSubscription.cancel();
    super.dispose();
  }

  Future<void> _onStateChanged(BluetoothState bluetoothState) async {
    final bluetoothAppState = await _bluetoothState(bluetoothState);

    if (mounted) {
      state = AsyncValue.data(bluetoothAppState);
    }
  }

  Future<BluetoothAppState> _bluetoothState(BluetoothState bluetoothState) async {
    if (await Permission.bluetoothConnect.isPermanentlyDenied) {
      return BluetoothAppState.permissionPermanentlyDenied;
    }

    if (await Permission.bluetoothConnect.isDenied) {
      return BluetoothAppState.permissionDenied;
    }

    if (bluetoothState != BluetoothState.STATE_OFF) {
      return BluetoothAppState.enabled;
    } //
    else {
      return BluetoothAppState.disabled;
    }
  }

  Future<void> requestTo(bool enable) async {
    state = const AsyncValue.loading();

    final bluetoothAppState = await AsyncValue.guard(() => _doRequestTo(true));
    if (!mounted) {
      return;
    }

    state = bluetoothAppState;
  }

  Future<BluetoothAppState> _doRequestTo(bool enable) async {
    final alreadyEnabled = await bluetooth.state != BluetoothState.STATE_OFF;

    if (enable && alreadyEnabled) {
      return BluetoothAppState.enabled;
    } //
    else if (!enable && !alreadyEnabled) {
      return BluetoothAppState.disabled;
    }

    if (await Permission.bluetoothConnect.isPermanentlyDenied) {
      openAppSettings();
      return BluetoothAppState.permissionPermanentlyDenied;
    }

    final permission = await Permission.bluetoothConnect.request();
    if (!permission.isGranted) {
      return permission.isPermanentlyDenied //
          ? BluetoothAppState.permissionPermanentlyDenied
          : BluetoothAppState.permissionDenied;
    }

    if (enable) {
      final result = await bluetooth.requestEnable() ?? false;
      return result ? BluetoothAppState.enabled : BluetoothAppState.disabled;
    } //
    else {
      final result = await bluetooth.requestDisable() ?? false;
      return result ? BluetoothAppState.disabled : BluetoothAppState.enabled;
    }
  }
}

enum BluetoothAppState {
  permissionPermanentlyDenied(false),
  permissionDenied(false),
  disabled(false),
  enabled(true);

  const BluetoothAppState(this.bluetoothEnable);

  final bool bluetoothEnable;
}
