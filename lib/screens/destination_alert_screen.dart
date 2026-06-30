import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/image_urls.dart';
import '../core/router/app_router.dart';
import '../core/services/auth_service.dart';
import '../core/services/firestore_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/app_button.dart';

class DestinationAlertScreen extends StatefulWidget {
  const DestinationAlertScreen({super.key, required this.destination});

  final String destination;

  @override
  State<DestinationAlertScreen> createState() => _DestinationAlertScreenState();
}

class _DestinationAlertScreenState extends State<DestinationAlertScreen>
    with TickerProviderStateMixin {
  late final AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
    _triggerVibration();
  }

  Future<void> _triggerVibration() async {
    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  Future<void> _dismissed() async {
    final userId = context.read<AuthService>().currentUser?.uid;
    if (userId != null) {
      await context.read<FirestoreService>().endTrip(userId);
    }
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: ImageUrls.dashboardMap,
            fit: BoxFit.cover,
          ),
          Container(color: AppColors.onSurface.withValues(alpha: 0.2)),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(color: Colors.transparent),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 32,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 96,
                            height: 96,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _ringController,
                                  builder: (context, child) {
                                    return Container(
                                      width: 96 * (0.5 + _ringController.value * 0.5),
                                      height: 96 * (0.5 + _ringController.value * 0.5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary.withValues(
                                          alpha: 0.2 * (1 - _ringController.value),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.notifications_active,
                                    color: AppColors.onPrimaryContainer,
                                    size: 32,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Unakaribia kushuka!',
                            textAlign: TextAlign.center,
                            style: AppTypography.headlineMdMobile,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on, color: AppColors.secondary, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  widget.destination,
                                  style: AppTypography.textTheme.labelLarge?.copyWith(
                                    color: AppColors.onSecondaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _StatusChip(icon: Icons.vibration, label: 'Inatetema'),
                              Container(
                                width: 1,
                                height: 16,
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                color: AppColors.outlineVariant,
                              ),
                              _StatusChip(icon: Icons.volume_up, label: 'Sauti'),
                            ],
                          ),
                          const SizedBox(height: 32),
                          AppButton(
                            label: 'Nimeshuka',
                            icon: Icons.check_circle,
                            onPressed: _dismissed,
                          ),
                          const SizedBox(height: 12),
                          AppButton(
                            label: 'Endelea kunikumbusha',
                            variant: AppButtonVariant.ghost,
                            onPressed: () => context.pop(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text.rich(
                            TextSpan(
                              text: 'Mita ',
                              style: AppTypography.textTheme.labelSmall,
                              children: const [
                                TextSpan(
                                  text: '350',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.onSurface),
                                ),
                                TextSpan(text: ' zimebaki kufika kituoni'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label.toUpperCase(),
          style: AppTypography.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
