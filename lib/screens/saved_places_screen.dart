import 'package:flutter/material.dart';
import '../core/constants/app_branding.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/models/saved_place.dart';
import '../core/router/app_router.dart';
import '../core/services/auth_service.dart';
import '../core/services/firestore_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/navigation_utils.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/app_button.dart';
import '../widgets/glass_card.dart';
import '../widgets/shimmer_loading.dart';

class SavedPlacesScreen extends StatelessWidget {
  const SavedPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthService>().currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
              onPressed: () => popOrGoHome(context),
            ),
            title: Text(
              AppBranding.appName,
              style: AppTypography.textTheme.displayLarge?.copyWith(
                fontSize: 24,
                color: AppColors.primary,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.primary),
                onPressed: () => _showAddPlaceDialog(context),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saved Places', style: AppTypography.headlineMdMobile),
                  const SizedBox(height: 8),
                  Text(
                    'Save places you visit often for quick access.',
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  StreamBuilder<List<SavedPlace>>(
                    stream: userId == null
                        ? Stream<List<SavedPlace>>.value(const [])
                        : context.read<FirestoreService>().watchSavedPlaces(userId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: _StateCard(
                            icon: Icons.error_outline,
                            title: 'Saved places unavailable',
                            body: 'Could not load your Firestore places right now.',
                          ),
                        );
                      }
                      final count = snapshot.data?.length ?? 0;
                      return GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.bookmark_outline, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Saved places sync', style: AppTypography.labelMd),
                                  Text(
                                    userId == null
                                        ? 'Sign in to sync your places to Firestore.'
                                        : '$count places synced to your account.',
                                    style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    label: 'Add New Place',
                    icon: Icons.add_location_alt,
                    onPressed: () => _showAddPlaceDialog(context),
                  ),
                  const SizedBox(height: 24),
                  if (userId == null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const Icon(Icons.lock_outline, size: 40, color: AppColors.outline),
                            const SizedBox(height: 12),
                            Text('Log in first to see your places', style: AppTypography.labelMd),
                          ],
                        ),
                      ),
                    )
                  else
                    StreamBuilder<List<SavedPlace>>(
                      stream: context.read<FirestoreService>().watchSavedPlaces(userId),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const _StateCard(
                            icon: Icons.error_outline,
                            title: 'Saved places error',
                            body: 'Try again after reconnecting to Firestore.',
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const ShimmerLoading();
                        }
                        final places = snapshot.data ?? [];
                        if (places.isEmpty) {
                          return _EmptySavedPlaces(onAdd: () => _showAddPlaceDialog(context));
                        }
                        return Column(
                          children: places.map((p) => _SavedPlaceCard(place: p)).toList(),
                        );
                      },
                    ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nearby Service',
                          style: AppTypography.textTheme.labelLarge?.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'We suggest places based on your recent trips.',
                          style: AppTypography.textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppBottomNavBar(
            currentTab: AppNavTab.saved,
            onTabSelected: (tab) => _nav(context, tab),
          ),
        ],
      ),
    );
  }

  void _nav(BuildContext context, AppNavTab tab) {
    switch (tab) {
      case AppNavTab.home:
        context.go(AppRoutes.home);
      case AppNavTab.saved:
        break;
      case AppNavTab.reports:
        context.go(AppRoutes.reports);
      case AppNavTab.profile:
        context.go(AppRoutes.profile);
    }
  }

  void _showAddPlaceDialog(BuildContext context) {
    final labelController = TextEditingController();
    final addressController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Place'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: labelController, decoration: const InputDecoration(labelText: 'Label')),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final userId = context.read<AuthService>().currentUser?.uid;
              if (userId != null && labelController.text.isNotEmpty) {
                await context.read<FirestoreService>().addSavedPlace(
                      userId,
                      SavedPlace(
                        id: '',
                        label: labelController.text,
                        address: addressController.text,
                        icon: 'place',
                      ),
                    );
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelMd),
                const SizedBox(height: 4),
                Text(body, style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySavedPlaces extends StatelessWidget {
  const _EmptySavedPlaces({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(Icons.bookmark_border, size: 52, color: AppColors.outline),
            const SizedBox(height: 16),
            Text('No saved places yet', style: AppTypography.textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(
              'Add Home, Work, or any frequent stop to keep them in Firestore.',
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            AppButton(label: 'Add Place', onPressed: onAdd),
          ],
        ),
      ),
    );
  }
}

class _SavedPlaceCard extends StatelessWidget {
  const _SavedPlaceCard({required this.place});

  final SavedPlace place;

  IconData get _icon {
    switch (place.icon) {
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      case 'school':
        return Icons.school;
      default:
        return Icons.place;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(place.label, style: AppTypography.textTheme.labelLarge),
                Text(
                  place.isConfigured ? place.address : 'Weka sasa',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Synced to Firestore',
                  style: AppTypography.caption.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.outline),
        ],
      ),
    );
  }
}
