import 'package:flutter/material.dart';

import '../constants/app_colors.dart';


/// A custom joystick widget to control movement directions.
/// Sends specific commands ('F', 'B', 'L', 'R', 'S') based on joystick position.

class JoystickController extends StatefulWidget {
  final Function(String) sendCommand;
  final double joystickRadius; // Default joystick size
  final double thumbRadius; // Default thumb size

  JoystickController({
    required this.sendCommand,
    this.joystickRadius = 60.0,
    this.thumbRadius = 30.0,
  });

  @override
  _JoystickControllerState createState() => _JoystickControllerState();
}

class _JoystickControllerState extends State<JoystickController> {
  Offset _position = Offset.zero;  // Tracks the thumb position relative to the center of the joystick

  @override
  Widget build(BuildContext context) {
    return Center(
      // Build joystick with current position and drag updates
      child: _buildJoystick(
        _position,
            (details) {
          setState(() {
            // Calculate the new position based on drag movement
            Offset newPosition = details.localPosition -
                Offset(widget.joystickRadius, widget.joystickRadius);

            // Constrain the position within joystick boundaries
            _position = Offset(
              newPosition.dx.clamp(
                -(widget.joystickRadius - widget.thumbRadius),
                widget.joystickRadius - widget.thumbRadius,
              ),
              newPosition.dy.clamp(
                -(widget.joystickRadius - widget.thumbRadius),
                widget.joystickRadius - widget.thumbRadius,
              ),
            );

            _updateMovementDirection(); // Update movement based on joystick position
          });
        },
        onEnd: () {
          setState(() {
            _position = Offset.zero; // Reset position
            widget.sendCommand('S'); // Send stop command immediately
          });
        },
      ),
    );
  }

  /// Builds the joystick with thumb based on the current position and drag events.
  Widget _buildJoystick(
      Offset position, Function(DragUpdateDetails) onUpdate, {required Function() onEnd}) {
    return GestureDetector(
      onPanUpdate: onUpdate, // Called when the user drags the joystick
      onPanEnd: (details) => onEnd(), // Called when the drag ends
      child: Container(
        width: widget.joystickRadius * 2,
        height: widget.joystickRadius * 2,
        decoration: BoxDecoration(
          color: AppColors.deepGrayColor,
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Positioned(
              left: position.dx + widget.joystickRadius - widget.thumbRadius,
              top: position.dy + widget.joystickRadius - widget.thumbRadius,
              child: Container(
                width: widget.thumbRadius * 2,
                height: widget.thumbRadius * 2,
                decoration: BoxDecoration(
                  color: _getThumbColor(position),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Update movement direction based on joystick position
  void _updateMovementDirection() {
    if (_position.dy < -20) {
      widget.sendCommand('F'); // Forward
    } else if (_position.dy > 20) {
      widget.sendCommand('B'); // Backward
    } else if (_position.dx < -20) {
      widget.sendCommand('L'); // Left
    } else if (_position.dx > 20) {
      widget.sendCommand('R'); // Right
    } else {
      widget.sendCommand('S'); // Stop when joystick is centered
    }
  }

  // Change thumb color based on direction
  Color _getThumbColor(Offset position) {
    if (position.dx < -20 || position.dy < -20) return AppColors.redColor;    // Moving in left or forward direction
    if (position.dx > 20 || position.dy > 20) return AppColors.greenColor;    // Moving in right or backward direction
    return AppColors.deepRedColor; // Default
  }
}
