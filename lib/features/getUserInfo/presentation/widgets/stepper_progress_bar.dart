import 'package:flutter/material.dart';

class StepperProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  const StepperProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: (currentStep + 1) / totalSteps,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color(0xFF2196F3),
          ),
          minHeight: 6,
        ),
      ),
    );
  }
}
