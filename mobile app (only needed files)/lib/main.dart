import 'package:bcar2/constants/app_colors.dart';
import 'package:bcar2/utils/lights_control.dart';
import 'package:bcar2/utils/permision_handling.dart';
import 'package:bcar2/utils/bluetooth_manager.dart';
import 'package:bcar2/widgets/action_button.dart';
import 'package:bcar2/widgets/corner_button.dart';
import 'package:bcar2/widgets/joystick.dart';
import 'package:bcar2/widgets/pad_button.dart';
import 'package:bcar2/widgets/touch_pad_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock the device orientation to landscape mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothControlScreen(),
    );
  }
}

class BluetoothControlScreen extends StatefulWidget {
  @override
  _BluetoothControlScreenState createState() => _BluetoothControlScreenState();
}

class _BluetoothControlScreenState extends State<BluetoothControlScreen> {
  // BluetoothManager instance to handle Bluetooth communications
  late BluetoothManager bluetoothManager;

  BluetoothConnection? connection;
  bool isConnected = false;
  // Replace with your Bluetooth module MAC address
  String mac = '00:21:13:00:7C:15';

  late LightControls lightControls;

  double speedValue = 0; // Default speed display
  double currentSpeed = 0.0; // Initialize with 0

  @override
  void initState() {
    super.initState();
    checkPermissions();
    bluetoothManager = BluetoothManager(onSpeedUpdate: updateSpeedDisplay);
    lightControls = LightControls(sendCommand: sendCommand);
  }

  // Call the sendCommand method
  void sendCommand(String command) {
    bluetoothManager.sendCommand(command);
  }

  // Update the UI with the received speed
  void updateSpeedDisplay(double speed) {
    setState(() {
      currentSpeed = speed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.deepGrayColor, AppColors.deepBlueColor],
            begin: Alignment.topLeft,
            end: Alignment.centerLeft,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: screenWidth * 0.23,
              height: screenHeight,
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  ///  LT button
                  Row(
                    children: [
                      cornerButton(
                          label: 'LT',
                          color: AppColors.deepRedColor,
                          size: 80,
                          onPressed: () {
                            setState(() {
                              lightControls.toggleFrontLight();
                            });
                          },
                          shadowColor: lightControls.isFrontLightOn
                              ? AppColors.whiteColor
                              : AppColors.redColor)
                    ],
                  ),

                  ///  LB button
                  Row(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.1,
                      ),
                      cornerButton(
                          label: 'LB',
                          color: AppColors.deepRedColor,
                          size: 60,
                          onPressed: () {},
                          shadowColor: AppColors.redColor)
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.09,
                  ),
                  // LRUD
                  Row(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.04,
                        height: screenHeight * 0.01,
                      ),
                      buildDPad(
                        color: AppColors.deepRedColor,
                        shadowColor: AppColors.redColor,
                        size: 130,
                        leftWidget: buildDPadButton(
                          onPressed: (_) => sendCommand(
                              "A"), // Sends 'l' when the button is pressed
                          onReleased: (_) =>
                              sendCommand("S"), // Sends 'Q' on release

                          buttonIcon:
                              Icons.keyboard_arrow_left, // Left arrow icon
                          leftPosition: screenWidth *
                              (-16 / screenWidth), // Adjust position as needed
                          bottomPosition:
                              screenHeight * 0.11, // Adjust position as needed
                        ),
                        topWidget: buildDPadButton(
                          onPressed: (_) =>
                              sendCommand("W"), // Start moving forward
                          onReleased: (_) =>
                              sendCommand("S"), // Stop when released
                          buttonIcon: Icons.keyboard_arrow_up,
                          leftPosition: screenWidth * 0.045, // Adjust as needed
                          bottomPosition:
                              screenHeight * 0.23, // Adjust as needed
                        ),
                        rightWidget: buildDPadButton(
                          onPressed: (_) => sendCommand("D"),
                          onReleased: (_) => sendCommand("S"),
                          buttonIcon: Icons.keyboard_arrow_right,
                          leftPosition: screenWidth * 0.11, // Adjust as needed
                          bottomPosition:
                              screenHeight * 0.11, // Adjust as needed
                        ),
                        bottomWidget: buildDPadButton(
                          onPressed: (_) => sendCommand("Y"),
                          onReleased: (_) => sendCommand("S"),
                          buttonIcon: Icons.keyboard_arrow_down,
                          leftPosition: screenWidth * 0.045, // Adjust as needed
                          bottomPosition: screenHeight *
                              (-16 / screenHeight), // Adjust as needed
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 400,
                    height: 180,
                    child: Stack(children: [
                      TouchpadShape(
                        strokeColor: bluetoothManager.isConnected
                            ? AppColors.greenColor
                            : AppColors.deepRedColor,
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 180,
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight:
                                      35, // Adjust the track thickness (width of slider)

                                  // Colors
                                  activeTrackColor: AppColors
                                      .deepRedColor, // Color of the track to the left of the thumb
                                  inactiveTrackColor: AppColors.grayColor,
                                  thumbColor: AppColors
                                      .deepRedColor, // Color of the thumb (circle that you slide)
                                  overlayColor: Colors.red.withAlpha(
                                      32), // Color of the overlay around the thumb when interacting
                                  valueIndicatorColor: AppColors
                                      .deepRedColor, // Color of the pop-up that shows the current value
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius:
                                        1.0, // Adjust the overlay radius when interacting with slider
                                  ),
                                ),
                                child: Slider(
                                  value: speedValue,
                                  min: 0,
                                  max: 7,
                                  divisions: 6,
                                  label:
                                      "Speed: ${speedValue.toInt()}", // Value label
                                  onChanged: (newValue) {
                                    setState(() {
                                      speedValue = newValue;
                                      sendCommand(speedValue
                                          .toInt()
                                          .toString()); // Send speed level to Arduino
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),

                          // Slider for speed control
                          SizedBox(
                            width: 20,
                            height: 180,
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight:
                                      35, // Adjust the track thickness (width of slider)

                                  // Colors
                                  activeTrackColor: AppColors
                                      .deepRedColor, // Color of the track to the left of the thumb
                                  inactiveTrackColor: AppColors.grayColor, // Color of the track to the right of the thumb
                                  thumbColor: AppColors
                                      .deepRedColor, // Color of the thumb (circle that you slide)
                                  overlayColor: Colors.red.withAlpha(
                                      32), // Color of the overlay around the thumb when interacting
                                  valueIndicatorColor: AppColors
                                      .deepRedColor, // Color of the pop-up that shows the current value
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius:
                                        1.0, // Adjust the overlay radius when interacting with slider
                                  ),
                                ),
                                child: Slider(
                                  value: speedValue,
                                  min: 0,
                                  max: 7,
                                  divisions: 6,
                                  label:
                                      "Speed: ${speedValue.toInt()}", // Value label
                                  onChanged: (newValue) {
                                    setState(() {
                                      speedValue = newValue;
                                      sendCommand(speedValue
                                          .toInt()
                                          .toString()); // Send speed A to Arduino
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Speed: ${currentSpeed.toStringAsFixed(2)} M/s',
                              style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(blurRadius: 10, color: Colors.black)
                                  ]),
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      JoystickController(
                        sendCommand:
                            sendCommand, // Send command based on joystick input
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              bluetoothManager.connectToBluetooth(mac, () {
                                print('Connected');
                                setState(() {}); // Update UI after connection
                              });
                            }, // Disable button if null
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.transparent, // Background color
                              shape: const CircleBorder(), // Circular shape

                              shadowColor: AppColors.purpleColor,
                            ),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: AppColors.deepRedColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.purpleColor,
                                    blurRadius:
                                        4,
                                    spreadRadius:
                                        4,
                                    offset: Offset(
                                        0, 0),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  bluetoothManager.isConnected
                                      ? Icons.bluetooth_connected
                                      : Icons.bluetooth,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          )
                        ],
                      ),
                      JoystickController(
                        sendCommand:
                            sendCommand, // Send command based on joystick input
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Container(
              width: screenWidth * 0.23,
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  /// RT button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      cornerButton(
                          label: 'RT',
                          color: AppColors.deepRedColor,
                          size: 80,
                          onPressed: () {
                            setState(() {
                              lightControls.toggleRearLight();
                            });
                          },
                          shadowColor: lightControls.isRearLightOn
                              ? AppColors.whiteColor
                              : AppColors.redColor)
                    ],
                  ),

                  Row(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.04,
                      ),
                      cornerButton(
                          label: 'RB',
                          color: AppColors.deepRedColor,
                          size: 60,
                          onPressed: () => sendCommand("O"),
                          shadowColor: AppColors.redColor),
                    ],
                  ),

                  SizedBox(
                    height: screenHeight * 0.07,
                  ),

                  /// X, Y, B, A Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      actionButton(
                        label: 'B',
                        color: AppColors.deepRedColor,
                        size: 55,
                        onPressed: (_) => sendCommand("C"),
                        onReleased: (_) =>
                            sendCommand("S"),
                        shadowColor: AppColors.redColor,
                      ),
                      Column(
                        children: [
                          actionButton(
                            label: 'Y',
                            color: AppColors.deepRedColor,
                            size: 55,
                            onPressed: (_) => sendCommand("U"),
                            onReleased: (_) =>
                                sendCommand("S"),
                            shadowColor: AppColors.redColor,
                          ),
                          SizedBox(
                            height: screenHeight * 0.09,
                          ),
                          actionButton(
                            label: 'A',
                            color: AppColors.deepRedColor,
                            size: 55,
                            onPressed: (_) => sendCommand("Z"),
                            onReleased: (_) =>
                                sendCommand("S"),
                            shadowColor: AppColors.redColor,
                          ),
                        ],
                      ),
                      actionButton(
                        label: 'X',
                        color: AppColors.deepRedColor,
                        size: 55,
                        onPressed: (_) => sendCommand("Q"),
                        onReleased: (_) =>
                            sendCommand("S"),
                        shadowColor: AppColors.redColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
