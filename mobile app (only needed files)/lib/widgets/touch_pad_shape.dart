import 'package:bcar2/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TouchpadShape extends StatelessWidget {
  final Color strokeColor; // Required color for the stroke connected and disconnected indicator
  final double width;
  final double height;
  // Constructor requiring strokeColor
  TouchpadShape({required this.strokeColor, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Container (Stroke)
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: AppColors.grayColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: strokeColor, // Use the required strokeColor
                width: 5,
              ),
            ),
          ),

        ],
      ),
    );
  }
}

