import 'package:flutter/material.dart';
import 'package:healthcare/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed, required this.text, required this.width});
  final VoidCallback onPressed;
  final String text;
  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:width,
      height: 54,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              8,
            ),
          ),
          backgroundColor: AppColors.infoDark,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style:  Theme .of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}