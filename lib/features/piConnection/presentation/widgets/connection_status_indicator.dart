import 'package:flutter/material.dart';
import 'package:healthcare/core/constants/app_colors.dart';

class ConnectionStatusIndicator extends StatefulWidget {
  final bool isConnected;
  final bool isConnecting;
  final String? statusText;

  const ConnectionStatusIndicator({
    super.key,
    required this.isConnected,
    this.isConnecting = false,
    this.statusText,
  });

  @override
  State<ConnectionStatusIndicator> createState() =>
      _ConnectionStatusIndicatorState();
}

class _ConnectionStatusIndicatorState extends State<ConnectionStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0.8,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.isConnecting) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant ConnectionStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isConnecting && !oldWidget.isConnecting) {
      _controller.repeat();
    } else if (!widget.isConnecting && oldWidget.isConnecting) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _statusColor {
    if (widget.isConnecting) return AppColors.warning;
    if (widget.isConnected) return AppColors.success;
    return AppColors.gray400;
  }

  IconData get _statusIcon {
    if (widget.isConnecting) return Icons.sync;
    if (widget.isConnected) return Icons.check_circle;
    return Icons.circle_outlined;
  }

  String get _defaultStatusText {
    if (widget.isConnecting) return 'Connecting...';
    if (widget.isConnected) return 'Connected';
    return 'Disconnected';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (widget.isConnecting)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: 80 * _scaleAnimation.value,
                    height: 80 * _scaleAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _statusColor.withValues(
                        alpha: _opacityAnimation.value * 0.3,
                      ),
                    ),
                  );
                },
              ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _statusColor.withValues(alpha: 0.15),
                border: Border.all(color: _statusColor, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: _statusColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: widget.isConnecting
                  ? _buildRotatingIcon()
                  : Icon(_statusIcon, color: _statusColor, size: 40),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          widget.statusText ?? _defaultStatusText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _statusColor,
          ),
        ),
      ],
    );
  }

  Widget _buildRotatingIcon() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: Icon(Icons.sync, color: _statusColor, size: 40),
        );
      },
    );
  }
}
