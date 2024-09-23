import 'package:bcar2/constants/app_colors.dart';
import 'package:flutter/material.dart';


/// A reusable circular button widget typically used for corner buttons.
/// The button has a customizable label, color, shadow, size, and tap functionality.

Widget cornerButton({
  required String label,
  required Color color,
  required Color shadowColor,
  required double size,
  required VoidCallback onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
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