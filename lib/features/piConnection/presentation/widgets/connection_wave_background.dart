  import 'package:flutter/material.dart';
import 'package:healthcare/core/constants/app_colors.dart';

/// Animated wave background for the connection screen
class ConnectionWaveBackground extends StatefulWidget {
  final Widget child;
  final bool isConnected;

  const ConnectionWaveBackground({
    super.key,
    required this.child,
    this.isConnected = false,
  });

  @override
  State<ConnectionWaveBackground> createState() =>
      _ConnectionWaveBackgroundState();
}

class _ConnectionWaveBackgroundState extends State<ConnectionWaveBackground>
    with TickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.isConnected
                  ? [
                      AppColors.mintGreen.withValues(alpha: 0.3),
                      AppColors.backgroundLight,
                    ]
                  : [
                      AppColors.skyBlue.withValues(alpha: 0.5),
                      AppColors.backgroundLight,
                    ],
            ),
          ),
        ),
        // Animated waves
        AnimatedBuilder(
          animation: _waveController,
          builder: (context, child) {
            return CustomPaint(
              painter: WavePainter(
                animationValue: _waveController.value,
                isConnected: widget.isConnected,
              ),
              size: Size.infinite,
            );
          },
        ),
        // Main content
        widget.child,
      ],
    );
  }
}

/// Custom painter for wave animation
class WavePainter extends CustomPainter {
  final double animationValue;
  final bool isConnected;

  WavePainter({required this.animationValue, required this.isConnected});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // First wave
    paint.color = (isConnected ? AppColors.healingGreen : AppColors.medicalBlue)
        .withValues(alpha: 0.1);
    _drawWave(canvas, size, paint, 0.6, animationValue, 50);

    // Second wave
    paint.color = (isConnected ? AppColors.medicalGreen : AppColors.deepBlue)
        .withValues(alpha: 0.08);
    _drawWave(canvas, size, paint, 0.65, animationValue + 0.3, 40);

    // Third wave
    paint.color = (isConnected ? AppColors.lightGreen : AppColors.lightBlue)
        .withValues(alpha: 0.06);
    _drawWave(canvas, size, paint, 0.7, animationValue + 0.6, 30);
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    Paint paint,
    double heightPercent,
    double offset,
    double amplitude,
  ) {
    final path = Path();
    final height = size.height * heightPercent;

    path.moveTo(0, height);

    for (double i = 0; i <= size.width; i++) {
      final y =
          height +
          amplitude *
              _sin((i / size.width * 2 * 3.14159) + (offset * 2 * 3.14159));
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  double _sin(double value) {
    // Simple sine approximation
    return (value % (2 * 3.14159)) < 3.14159
        ? 4 * (value % 3.14159) / 3.14159 -
              4 * (value % 3.14159) * (value % 3.14159) / (3.14159 * 3.14159)
        : -(4 * ((value - 3.14159) % 3.14159) / 3.14159 -
              4 *
                  ((value - 3.14159) % 3.14159) *
                  ((value - 3.14159) % 3.14159) /
                  (3.14159 * 3.14159));
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isConnected != isConnected;
  }
}
