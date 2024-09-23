import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// A reusable action button widget that can be pressed and released.
/// The button is circular with customizable color, size, and label.

Widget actionButton({
  required String label,
  required Color color,
  required Color shadowColor,
  required double size,
  required GestureTapDownCallback onPressed,
  required GestureTapUpCallback onReleased,
}) {
  return GestureDetector(
    onTapDown: onPressed, // Trigger when button is pressed down
    onTapUp: onReleased,   // Trigger when button is released
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        // colors around the button
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 4,
            spreadRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: size / 3, // Size adapts to button size
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

