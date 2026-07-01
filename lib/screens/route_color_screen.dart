import 'package:flutter/material.dart';
import '../core/constants/app_branding.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/router/app_router.dart';
import '../core/services/auth_service.dart';
import '../core/services/firestore_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/app_button.dart';

class RouteColorScreen extends StatelessWidget {
  const RouteColorScreen({
    super.key,
    required this.routeColor,
    required this.destination,
    required this.routeId,
  });

  final String routeColor;
  final String destination;
  final String routeId;

  Future<void> _confirmTrip(BuildContext context) async {
    final userId = context.read<AuthService>().currentUser?.uid;
    if (userId != null) {
      await context.read<FirestoreService>().startTrip(
            userId: userId,
            routeId: routeId,
            destination: destination,
            routeColor: routeColor,
          );
    }
    if (context.mounted) {
      context.push(
        AppRoutes.activeTrip,
        extra: {'destination': destination, 'routeId': routeId},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppBranding.appName,
          style: AppTypography.headlineMdMobile.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Colors.white],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  border: Border.all(color: AppColors.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Rangi ya njia: $routeColor',
                textAlign: TextAlign.center,
                style: AppTypography.textTheme.displayLarge?.copyWith(
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Hakikisha unapanda gari lenye rangi hii kabla ya kuanza safari yako kwenda $destination.',
                textAlign: TextAlign.center,
                style: AppTypography.textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tahadhari ya Usalama',
                            style: AppTypography.textTheme.labelLarge?.copyWith(
                              color: AppColors.onErrorContainer,
                            ),
                          ),
                          Text(
                            'Usipande gari lenye rangi tofauti. Angalia vizuri kabla ya kupanda.',
                            style: AppTypography.textTheme.bodyMedium?.copyWith(
                              color: AppColors.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AppButton(
                label: 'Nimeelewa, anza safari',
                icon: Icons.directions_bus,
                onPressed: () => _confirmTrip(context),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Rudi nyuma',
                  style: AppTypography.textTheme.labelLarge?.copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
