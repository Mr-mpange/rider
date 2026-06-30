import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/image_urls.dart';
import '../core/router/app_router.dart';
import '../core/services/app_preferences.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  final _steps = const [
    _Step(ImageUrls.dashboardMap, 'Book rides instantly', 'Experience the future of urban mobility with premium on-demand vehicles.'),
    _Step(ImageUrls.mapNightLagos, 'Move freight smoothly', 'Ship cargo, manage route color checks, and monitor logistics in one place.'),
    _Step(ImageUrls.dashboardMap, 'Track everything live', 'Stay on top of your trip, wallet, and route intelligence with live control.'),
  ];

  Future<void> _skip() async {
    await context.read<AppPreferences>().completeOnboarding();
    if (mounted) context.go(AppRoutes.home);
  }

  void _next() {
    if (_page < _steps.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    } else {
      _skip();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile),
          child: Column(
            children: [
              Row(
                children: [
                  Text('RIDER', style: AppTypography.textTheme.labelLarge?.copyWith(color: AppColors.primary)),
                  const Spacer(),
                  TextButton(onPressed: _skip, child: const Text('Skip')),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _steps.length,
                  onPageChanged: (v) => setState(() => _page = v),
                  itemBuilder: (context, index) => _OnboardingPage(step: _steps[index]),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_steps.length, (i) {
                  final active = i == _page;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              AppButton(label: 'Continue', onPressed: _next, icon: Icons.arrow_forward, height: 56),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step {
  const _Step(this.image, this.title, this.description);
  final String image;
  final String title;
  final String description;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.step});
  final _Step step;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: AspectRatio(
            aspectRatio: 1,
            child: CachedNetworkImage(
              imageUrl: step.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(step.title, textAlign: TextAlign.center, style: AppTypography.displayLg.copyWith(fontSize: 24, color: AppColors.onSurface)),
        const SizedBox(height: 12),
        Text(step.description, textAlign: TextAlign.center, style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
      ],
    );
  }
}
