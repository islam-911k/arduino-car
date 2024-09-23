
class LightControls {
  // state of lights
  bool isFrontLightOn = false;
  bool isRearLightOn = false;

  // function to handel command
  final Function(String) sendCommand;

  LightControls({required this.sendCommand});

  // front light
  void toggleFrontLight() {
    isFrontLightOn = !isFrontLightOn;
    sendCommand(isFrontLightOn ? 'H' : 'J');
  }

  // rear light
  void toggleRearLight() {
    isRearLightOn = !isRearLightOn;
    sendCommand(isRearLightOn ? 'N' : 'M');
  }
}
