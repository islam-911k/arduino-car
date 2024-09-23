import 'package:flutter/material.dart';


/// Main widget that holds all buttons for the D-pad

Widget buildDPad({
  required Color color,
  required Color shadowColor,
  required double size,
  required Widget leftWidget,
  required Widget topWidget,
  required Widget rightWidget,
  required Widget bottomWidget
}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          blurRadius: 4,
          spreadRadius: 4,
          offset: Offset(0, 0),
        ),
      ],
    ),
    child: Stack(
      children: [
        leftWidget,
        topWidget,
        rightWidget,
        bottomWidget
      ],
    ),
  );
}


/// Reusable button for the D-pad
Widget buildDPadButton({
  required GestureTapDownCallback onPressed,
  required GestureTapUpCallback onReleased,
  required IconData buttonIcon,
  required double leftPosition,
  required double bottomPosition,
  Color iconColor = Colors.white, // Default to white but can be overridden
}) {
  return Positioned(
    left: leftPosition,
    bottom: bottomPosition,
    child: GestureDetector(
      onTapDown: onPressed, // Trigger when button is pressed down
      onTapUp: onReleased,   // Trigger when button is released
      child: Icon(
        buttonIcon,
        color: iconColor,
        size: 60,
      ),
    ),
  );
}
