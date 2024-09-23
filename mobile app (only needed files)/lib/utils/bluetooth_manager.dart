import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';

// all Bluetooth operations are handled in this class

class BluetoothManager {
  BluetoothConnection? connection;
  bool isConnected = false; // to handle state of bluetooth connection
  Function(double) onSpeedUpdate; // Callback to update UI with speed

  BluetoothManager({required this.onSpeedUpdate});

  // Method to connect to Bluetooth
  Future<void> connectToBluetooth(String mac, VoidCallback onConnect) async {
    try {
      BluetoothConnection.toAddress(mac).then((conn) {
        connection = conn;
        isConnected = true;
        onConnect(); // Trigger UI update on successful connection

        // Listen for incoming data
        connection!.input!.listen((data) {
          String receivedData = String.fromCharCodes(data);
          parseReceivedData(receivedData);
        }).onDone(() {
          isConnected = false;
        });
      }).catchError((error) {
        print(
            'Cannot connect, exception occurred: $error'); // for debugging reasons
      });
    } catch (e) {
      print('Error: $e'); // for debugging reasons
    }
  }

  // Method to disconnect from Bluetooth
  void disconnectFromBluetooth(VoidCallback onDisconnect) {
    if (isConnected) {
      connection?.close();
      isConnected = false;
      connection = null;
      onDisconnect(); // Trigger UI update on disconnect
    }
  }

  // Method to send commands over Bluetooth
  void sendCommand(String command) {
    if (isConnected) {
      final Uint8List commandBytes =
          Uint8List.fromList([command.codeUnitAt(0)]);
      connection!.output.add(commandBytes);
    }
  }

  // Method to parse received data
  void parseReceivedData(String data) {
    if (data.startsWith("SPEED:")) {
      String speedValue = data.substring(6).trim(); // Get value after "SPEED:"
      double currentSpeed = double.tryParse(speedValue) ?? 0.0;
      onSpeedUpdate(currentSpeed); // Update the UI with the current speed
    }
  }
}
