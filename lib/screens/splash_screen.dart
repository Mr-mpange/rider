import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/router/app_router.dart';
import '../core/services/app_preferences.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    final prefs = context.read<AppPreferences>();
    if (!prefs.initialized) await prefs.init();
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    context.go(prefs.onboardingComplete ? AppRoutes.home : AppRoutes.onboarding);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryContainer.withValues(alpha: 0.2 + _glowController.value * 0.3),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.directions_car_filled, size: 64, color: AppColors.primary.withValues(alpha: 0.9)),
              const SizedBox(height: 24),
              Text('RIDER', style: AppTypography.displayLg.copyWith(fontSize: 36)),
              const SizedBox(height: 8),
              Text(
                'Premium mobility platform',
                style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
