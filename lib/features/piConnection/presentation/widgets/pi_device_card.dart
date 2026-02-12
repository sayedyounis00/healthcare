// import 'package:flutter/material.dart';
// import 'package:healthcare/core/constants/app_colors.dart';

// class PiDeviceCard extends StatefulWidget {
//   final String ipAddress;
//   final int port;
//   final String? deviceName;
//   final bool isConnected;
//   final bool isSaved;
//   final VoidCallback? onTap;
//   final VoidCallback? onConnect;
//   final VoidCallback? onDelete;

//   const PiDeviceCard({
//     super.key,
//     required this.ipAddress,
//     required this.port,
//     this.deviceName,
//     this.isConnected = false,
//     this.isSaved = false,
//     this.onTap,
//     this.onConnect,
//     this.onDelete,
//   });

//   @override
//   State<PiDeviceCard> createState() => _PiDeviceCardState();
// }

// class _PiDeviceCardState extends State<PiDeviceCard>
//     // with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _glowAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     );

//     _glowAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     if (widget.isConnected) {
//       _controller.repeat(reverse: true);
//     }
//   }

//   @override
//   void didUpdateWidget(covariant PiDeviceCard oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.isConnected && !oldWidget.isConnected) {
//       _controller.repeat(reverse: true);
//     } else if (!widget.isConnected && oldWidget.isConnected) {
//       _controller.stop();
//       _controller.reset();
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _glowAnimation,
//       builder: (context, child) {
//         return Container(
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: widget.isConnected
//                   ? [AppColors.mintGreen, AppColors.surfaceLight]
//                   : [AppColors.surfaceLight, AppColors.gray100],
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: widget.isConnected
//                     ? AppColors.success.withValues(
//                         alpha: 0.2 + _glowAnimation.value * 0.15,
//                       )
//                     : AppColors.shadow,
//                 blurRadius: widget.isConnected
//                     ? 15 + _glowAnimation.value * 10
//                     : 10,
//                 spreadRadius: widget.isConnected ? _glowAnimation.value * 2 : 0,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: widget.onTap,
//               borderRadius: BorderRadius.circular(20),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Row(
//                   children: [
//                     _buildDeviceIcon(),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   widget.deviceName ?? 'Raspberry Pi',
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: AppColors.textPrimaryLight,
//                                   ),
//                                 ),
//                               ),
//                               if (widget.isSaved)
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 4,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: AppColors.medicalBlue.withValues(
//                                       alpha: 0.1,
//                                     ),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: const Text(
//                                     'Saved',
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w600,
//                                       color: AppColors.medicalBlue,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           const SizedBox(height: 6),
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.router,
//                                 size: 14,
//                                 color: AppColors.textSecondaryLight,
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 '${widget.ipAddress}:${widget.port}',
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: AppColors.textSecondaryLight,
//                                   fontFamily: 'monospace',
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           _buildStatusBadge(),
//                         ],
//                       ),
//                     ),
//                     _buildActions(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDeviceIcon() {
//     return Container(
//       width: 64,
//       height: 64,
//       decoration: BoxDecoration(
//         gradient: widget.isConnected
//             ? AppColors.healthGradient
//             : LinearGradient(colors: [AppColors.gray300, AppColors.gray400]),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: (widget.isConnected ? AppColors.success : AppColors.gray400)
//                 .withValues(alpha: 0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: const Icon(Icons.developer_board, size: 32, color: Colors.white),
//     );
//   }

//   Widget _buildStatusBadge() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: widget.isConnected
//             ? AppColors.success.withValues(alpha: 0.15)
//             : AppColors.gray300.withValues(alpha: 0.5),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: widget.isConnected ? AppColors.success : AppColors.gray400,
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: widget.isConnected ? AppColors.success : AppColors.gray400,
//               boxShadow: widget.isConnected
//                   ? [
//                       BoxShadow(
//                         color: AppColors.success.withValues(alpha: 0.5),
//                         blurRadius: 4,
//                         spreadRadius: 1,
//                       ),
//                     ]
//                   : null,
//             ),
//           ),
//           const SizedBox(width: 6),
//           Text(
//             widget.isConnected ? 'Online' : 'Offline',
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: widget.isConnected ? AppColors.success : AppColors.gray600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActions() {
//     return Column(
//       children: [
//         if (!widget.isConnected && widget.onConnect != null)
//           IconButton(
//             onPressed: widget.onConnect,
//             icon: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: AppColors.medicalBlue.withValues(alpha: 0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.power_settings_new,
//                 color: AppColors.medicalBlue,
//                 size: 20,
//               ),
//             ),
//           ),
//         if (widget.onDelete != null)
//           IconButton(
//             onPressed: widget.onDelete,
//             icon: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: AppColors.error.withValues(alpha: 0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.delete_outline,
//                 color: AppColors.error,
//                 size: 20,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
