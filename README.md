# Arduino Car Control App

## IMPORTANT
This project is mainly for individuals with some experience in Flutter and Arduino, allowing them to make adjustments or improvements.

## INTRO
A Flutter app to control an Arduino car over Bluetooth. The app is running 10/10 on Android 9.

## COMPONENTS

### Classes and Functions

#### LOGIC
- **AppColors class**: Contains all colors used in the app.
- **BluetoothManager class**: Manages all Bluetooth operations.
- **checkPermissions function**: Handles all necessary permissions.
- **LightControls class**: Logic to turn front and rear lights on and off.

#### UI
- **ActionButton widget**: Builds the "A, Y, X, B" buttons.
- **CornerButton widget**: Builds the "LT, BT, RT, RB" buttons.
- **JoystickController class**: Builds the joystick button.
- **buildDPad / buildDPadButton class**: Builds the directional pad ("L, R, U, D") buttons.
- **TouchpadShape class**: Indicates if the app is connected to the car and enhances overall design.

## DEPENDENCIES
- **flutter_bluetooth_serial**: ^0.4.0 - to enable Bluetooth functionality.
- **permission_handler**: ^10.2.0 - to manage permissions.

## PERMISSIONS
Path to add permissions: `android/app/src/main/AndroidManifest.xml`

```xml
<!-- Permissions for Bluetooth and Location -->
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />

<!-- Bluetooth Low Energy support -->
<uses-feature android:name="android.hardware.bluetooth_le" android:required="false" />
