import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcare/core/constants/app_colors.dart';
import 'package:healthcare/features/liveStream/presentation/cubit/live_stream_cubit.dart';
import 'package:healthcare/features/liveStream/presentation/widgets/stream_player_placeholder.dart';
import 'package:healthcare/features/liveStream/presentation/widgets/stream_controls_overlay.dart';

class LiveStreamView extends StatefulWidget {
  const LiveStreamView({super.key});

  @override
  State<LiveStreamView> createState() => _LiveStreamViewState();
}

class _LiveStreamViewState extends State<LiveStreamView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for LIVE badge & connection indicator
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start the real Supabase Broadcast connection
    context.read<LiveStreamCubit>().connect();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // ─── Helpers to derive booleans from cubit state ───────────

  bool _isLive(LiveStreamState state) => state is LiveStreamConnected;

  bool _isConnecting(LiveStreamState state) => state is LiveStreamConnecting;

  bool _isError(LiveStreamState state) => state is LiveStreamError;

  Uint8List? _imageBytes(LiveStreamState state) =>
      state is LiveStreamConnected ? state.imageBytes : null;

  String _statusLabel(LiveStreamState state) {
    if (state is LiveStreamConnected) return 'Online';
    if (state is LiveStreamConnecting) return 'Connecting';
    if (state is LiveStreamError) return 'Error';
    return 'Offline';
  }

  // ─── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: BlocBuilder<LiveStreamCubit, LiveStreamState>(
          builder: (context, state) {
            final isLive = _isLive(state);
            final isConnecting = _isConnecting(state);

            return CustomScrollView(
              slivers: [
                // Custom AppBar
                SliverToBoxAdapter(
                  child: _buildAppBar(context, isLive, isConnecting, state),
                ),

                // Stream Player
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: GestureDetector(
                      onTap: () {
                        if (!isLive && !isConnecting) {
                          context.read<LiveStreamCubit>().connect();
                        }
                      },
                      child: Stack(
                        children: [
                          StreamPlayerPlaceholder(
                            imageBytes: _imageBytes(state),
                            isConnecting: isConnecting,
                          ),

                          Positioned(
                            top: 12,
                            left: 12,
                            child: _buildLiveBadge(isLive),
                          ),
                          // Timestamp
                          Positioned(
                            top: 12,
                            right: 12,
                            child: _buildTimestamp(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (_isError(state))
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: _buildErrorBanner(
                        (state as LiveStreamError).message,
                      ),
                    ),
                  ),

                // Controls
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: const StreamControlsOverlay(),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: _buildTipsCard(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ───────────────────────── App Bar ─────────────────────────

  Widget _buildAppBar(
    BuildContext context,
    bool isLive,
    bool isConnecting,
    LiveStreamState state,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.textPrimaryLight,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Live Camera',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  'Robot Camera Feed',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          _buildConnectionIndicator(isLive, isConnecting, state),
        ],
      ),
    );
  }

  Widget _buildConnectionIndicator(
    bool isLive,
    bool isConnecting,
    LiveStreamState state,
  ) {
    final color = isLive ? AppColors.success : AppColors.warning;
    final darkColor = isLive ? AppColors.successDark : AppColors.warningDark;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: isLive ? _pulseAnimation.value : 0.5,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: isLive
                        ? [
                            BoxShadow(
                              color: AppColors.success.withValues(alpha: 0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _statusLabel(state),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: darkColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLiveBadge(bool isLive) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isLive
                ? AppColors.error.withValues(alpha: 0.9)
                : AppColors.gray600.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(6),
            boxShadow: isLive
                ? [
                    BoxShadow(
                      color: AppColors.error.withValues(
                        alpha: _pulseAnimation.value * 0.5,
                      ),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLive)
                Opacity(
                  opacity: _pulseAnimation.value,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              if (isLive) const SizedBox(width: 5),
              Text(
                isLive ? 'LIVE' : 'OFFLINE',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimestamp() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '00:00:00',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.read<LiveStreamCubit>().connect(),
            child: const Text('Retry', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.medicalBlue.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: AppColors.medicalBlue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tips',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ensure the robot is powered on and connected to the same network for the best streaming experience.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.deepBlue.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
