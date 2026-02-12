import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcare/core/constants/app_colors.dart';
import 'package:healthcare/core/routing/routes.dart';
import 'package:healthcare/core/widgets/text_form_feild.dart';
import 'package:healthcare/features/piConnection/data/datasource/pi_connection_datasource.dart';
import 'package:healthcare/features/piConnection/data/repository/pi_connection_repo_impl.dart';
import 'package:healthcare/features/piConnection/presentation/cubit/pi_connection_cubit.dart';
import 'package:healthcare/features/piConnection/presentation/widgets/connection_status_indicator.dart';
import 'package:healthcare/features/piConnection/presentation/widgets/connection_wave_background.dart';

class PiConnectionPage extends StatelessWidget {
  const PiConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PiConnectionCubit(
        repository: PiConnectionRepoImpl(
          dataSource: PiConnectionDataSourceImpl(),
        ),
      ),
      child: const PiConnectionView(),
    );
  }
}

class PiConnectionView extends StatefulWidget {
  const PiConnectionView({super.key});

  @override
  State<PiConnectionView> createState() => _PiConnectionViewState();
}

class _PiConnectionViewState extends State<PiConnectionView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _ipController = TextEditingController();
  final _portController = TextEditingController(text: '8080');
  final _deviceNameController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _deviceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PiConnectionCubit, PiConnectionState>(
      listener: (context, state) {
        if (state is PiConnected) {
          _showSuccessDialog(context, state);
        } else if (state is PiConnectionError) {
          _showErrorSnackbar(context, state.message);
        } else if (state is PiSavedDeviceLoaded) {
          _ipController.text = state.ipAddress;
          _portController.text = state.port.toString();
          if (state.deviceName != null) {
            _deviceNameController.text = state.deviceName!;
          }
        }
      },
      builder: (context, state) {
        final isConnected = state is PiConnected;
        final isConnecting = state is PiConnecting;
        final isScanning = state is PiScanning;

        return Scaffold(
          body: ConnectionWaveBackground(
            isConnected: isConnected,
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              ConnectionStatusIndicator(
                                isConnected: isConnected,
                                isConnecting: isConnecting || isScanning,
                                statusText: _getStatusText(state),
                              ),

                              const SizedBox(height: 32),

                              _buildConnectionForm(context, state),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String? _getStatusText(PiConnectionState state) {
    if (state is PiConnecting) return 'Connecting to ${state.ipAddress}...';
    if (state is PiScanning) return 'Scanning ${state.ipAddress}...';
    if (state is PiConnected) return 'Connected to ${state.ipAddress}';
    if (state is PiConnectionError) return 'Connection failed';
    return null;
  }

  Widget _buildConnectionForm(BuildContext context, PiConnectionState state) {
    final cubit = context.read<PiConnectionCubit>();
    final isLoading = state is PiConnecting || state is PiScanning;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.wifi_tethering,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Connection Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Connect to your Raspberry Pi device',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                CustomTextField(
                  controller: _ipController,
                  label: 'IP Address',
                  hint: '127.0.0.1',
                  prefixIcon: Icons.language,
                  keyboardType: TextInputType.number,
                  required: true,
                  validator: FieldValidators.validateIpAddress,
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: _portController,
                  label: 'Port',
                  hint: '8080',
                  prefixIcon: Icons.numbers,
                  keyboardType: TextInputType.number,
                  required: true,
                  validator: FieldValidators.validatePort,
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  cubit.connect(
                                    _ipController.text.trim(),
                                    int.parse(_portController.text.trim()),
                                    deviceName:
                                        _deviceNameController.text.isNotEmpty
                                        ? _deviceNameController.text.trim()
                                        : null,
                                  );
                                }
                              },
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.power_settings_new),
                        label: Text(isLoading ? 'Connecting...' : 'Connect'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.medicalBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: AppColors.medicalBlue.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, PiConnected state) {
    final serverUrl = 'http://${state.ipAddress}:${state.port}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Connected Successfully!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Connected to ${state.ipAddress}:${state.port}',
              style: const TextStyle(color: AppColors.textSecondaryLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  Navigator.pushNamed(
                    context,
                    Routes.serverInfo,
                    arguments: serverUrl,
                  );
                },
                icon: const Icon(Icons.info_outline),
                label: const Text('View Server Info'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.medicalBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Close',
                  style: TextStyle(color: AppColors.textSecondaryLight),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
