** IMPORTANT **
this project is mainly for some have some experience in flutter and Arduino
so that he can make adjustments or improvements

** INTRO **

// A flutter App to control the arduino car over Bluetooth
// app is running 10/10 on Android 9


** COMPONENTS **

// Classes and Functions//

    LOGIC
  * AppColors class: where you can find all colors used in the app
  * BluetoothManager class: where you can find logic to handel all Bluetooth operations
  * checkPermissions function : where all needed permissions are handled
  * LightControls class: where logic to turn front and rear lights On and OFF

    UI
  * ActionButton widget: where "A,Y,X,B" Buttons are built
  * cornerButton widget: where "LT,BT,RT,RB" Buttons are built
  * JoystickController class: where joystick Button are built
  * buildDPad/buildDPadButton class: where Pad "L,R,U,D" Buttons are built
  * TouchpadShape class: basically is for showing if connected to car or not, and to improve overall design looking

   DEPENDENCIES
  * flutter_bluetooth_serial: ^0.4.0 : to allow use of Bluetooth
  * permission_handler: ^10.2.0 : to hand permissions overhead

  PERMISSIONS
  // path to add permissions : android/app/src/main/AndroidManifest.xml
  * <!-- Permissions for Bluetooth and Location -->
  * <uses-permission android:name="android.permission.BLUETOOTH" />
  * <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
  * <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  * <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
  * <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />

  * <!-- Bluetooth Low Energy support -->
  * <uses-feature android:name="android.hardware.bluetooth_le" android:required="false" />

