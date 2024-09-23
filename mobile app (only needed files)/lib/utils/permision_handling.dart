

import 'package:permission_handler/permission_handler.dart';

// permission to handel bluetooth to avoid overhead
Future<void> checkPermissions() async {
  await Permission.bluetooth.request();
  await Permission.location.request();
  await Permission.bluetoothScan.request();
  await Permission.bluetoothConnect.request();
}