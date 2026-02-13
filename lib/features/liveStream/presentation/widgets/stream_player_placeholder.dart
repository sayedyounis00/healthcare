import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:healthcare/core/constants/app_colors.dart';

/// Displays the camera stream content inside a 16:9 container.
///
/// • When [imageBytes] is provided → renders the live JPEG frame.
/// • When [imageBytes] is null and [isConnecting] is true → shows a spinner.
/// • Otherwise → shows the idle / disconnected placeholder.
class StreamPlayerPlaceholder extends StatelessWidget {
  final Uint8List? imageBytes;
  final bool isConnecting;

  const StreamPlayerPlaceholder({
    super.key,
    this.imageBytes,
    this.isConnecting = false,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.gray900,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: imageBytes != null
              ? _buildFrame(imageBytes!)
              : Stack(
                  children: [
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.2,
                          colors: [AppColors.gray800, AppColors.gray900],
                        ),
                      ),
                    ),
                    // Grid pattern overlay for visual depth
                    _buildGridOverlay(),
                    // Center content
                    Center(
                      child: isConnecting
                          ? _buildConnectingState()
                          : _buildIdleState(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // ─── Live frame ────────────────────────────────────────────

  Widget _buildFrame(Uint8List bytes) {
    return Image.memory(
      bytes,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      // Prevents flicker between consecutive frames:
      gaplessPlayback: true,
    );
  }

  // ─── Connecting spinner ────────────────────────────────────

  Widget _buildConnectingState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.medicalBlue.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.medicalBlue.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.videocam_outlined,
            color: AppColors.medicalBlue,
            size: 40,
          ),
        ),
        const SizedBox(height: 20),
        const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.medicalBlue,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Waiting for stream...',
          style: TextStyle(
            color: AppColors.gray400,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Make sure the robot camera is active',
          style: TextStyle(color: AppColors.gray600, fontSize: 12),
        ),
      ],
    );
  }

  // ─── Idle / disconnected ───────────────────────────────────

  Widget _buildIdleState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.gray700.withValues(alpha: 0.4),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.gray600.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.videocam_off_outlined,
            color: AppColors.gray500,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Stream Offline',
          style: TextStyle(
            color: AppColors.gray300,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tap to retry connection',
          style: TextStyle(color: AppColors.gray500, fontSize: 12),
        ),
      ],
    );
  }

  // ─── Grid overlay ──────────────────────────────────────────

  Widget _buildGridOverlay() {
    return Opacity(
      opacity: 0.05,
      child: CustomPaint(
        size: const Size(double.infinity, double.infinity),
        painter: _GridPainter(),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5;

    const spacing = 20.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
