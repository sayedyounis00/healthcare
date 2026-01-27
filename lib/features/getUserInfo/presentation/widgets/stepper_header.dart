import 'package:flutter/material.dart';

class StepperHeader extends StatelessWidget {
  final int currentStep;
  final List<String> stepTitles;
  final List<IconData> stepIcons;
  const StepperHeader({
    super.key,
    required this.currentStep,
    required this.stepTitles,
    required this.stepIcons,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(stepTitles.length * 2 - 1, (i) {
        if (i.isEven) {
          final index = i ~/ 2;
          final isCompleted = index < currentStep;
          final isCurrent = index == currentStep;
          return Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFF4CAF50)
                        : isCurrent
                            ? const Color(0xFF2196F3)
                            : Colors.grey[200],
                    shape: BoxShape.circle,
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: const Color(0xFF2196F3),
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : stepIcons[index],
                    color: isCompleted || isCurrent
                        ? Colors.white
                        : Colors.grey[400],
                    size: 24,
                  ),
                ),
              ],
            ),
          );
        } else {
          final index = (i - 1) ~/ 2;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              height: 2,
              decoration: BoxDecoration(
                color: index < currentStep
                    ? const Color(0xFF4CAF50)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }
      }),
    );
  }
}
