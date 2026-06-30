import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/image_urls.dart';
import '../core/models/route_recommendation.dart';
import '../core/router/app_router.dart';
import '../core/services/firestore_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/app_button.dart';
import '../widgets/shimmer_loading.dart';

class RouteRecommendationScreen extends StatelessWidget {
  const RouteRecommendationScreen({
    super.key,
    required this.origin,
    required this.destination,
  });

  final String origin;
  final String destination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.menu, color: AppColors.primary),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'RIDER',
              style: AppTypography.textTheme.displayLarge?.copyWith(
                fontSize: 20,
                color: AppColors.primary,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.primary),
                onPressed: () => context.push(AppRoutes.destinationSearch),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<RouteRecommendation?>(
              future: context.read<FirestoreService>().getRouteForDestination(
                    origin: origin,
                    destination: destination,
                  ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSpacing.marginMobile),
                    child: ShimmerLoading(count: 2),
                  );
                }

                final route = snapshot.data;
                if (route == null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.marginMobile),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.route, size: 48, color: AppColors.outline),
                          const SizedBox(height: 16),
                          Text(
                            'Hakuna njia iliyopatikana',
                            style: AppTypography.headlineMdMobile,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Hakuna njia iliyosajiliwa kutoka $origin hadi $destination.',
                            style: AppTypography.textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          AppButton(
                            label: 'Tafuta tena',
                            onPressed: () => context.push(AppRoutes.destinationSearch),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return _RouteContent(route: route);
              },
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
        context.go(AppRoutes.savedPlaces);
      case AppNavTab.reports:
        context.go(AppRoutes.reports);
      case AppNavTab.profile:
        context.go(AppRoutes.profile);
    }
  }
}

class _RouteContent extends StatelessWidget {
  const _RouteContent({required this.route});

  final RouteRecommendation route;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MapPreview(),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Njia inayopendekezwa', style: AppTypography.headlineMdMobile),
                const SizedBox(height: 16),
                _RouteCard(
                  origin: route.origin,
                  destination: route.destination,
                  routeColor: route.routeColor,
                  durationMinutes: route.durationMinutes,
                  distanceKm: route.distanceKm,
                  stopsCount: route.stopsCount,
                  onStart: () => context.push(
                    AppRoutes.routeColor,
                    extra: {
                      'routeColor': route.routeColor,
                      'destination': route.destination,
                      'routeId': route.id,
                    },
                  ),
                ),
                if (route.alternatives.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Njia mbadala',
                    style: AppTypography.textTheme.labelLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...route.alternatives.map(
                    (alt) => _AltRouteCard(
                      name: alt.name,
                      duration: alt.durationMinutes,
                      distance: alt.distanceKm,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 265,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(imageUrl: ImageUrls.dashboardMap, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.background.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.marginMobile,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Inapendekezwa',
                style: AppTypography.textTheme.labelLarge?.copyWith(
                  color: AppColors.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.origin,
    required this.destination,
    required this.routeColor,
    required this.durationMinutes,
    required this.distanceKm,
    required this.stopsCount,
    required this.onStart,
  });

  final String origin;
  final String destination;
  final String routeColor;
  final int durationMinutes;
  final double distanceKm;
  final int stopsCount;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$origin kwenda $destination',
                      style: AppTypography.textTheme.headlineSmall?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2563EB), Colors.white],
                            ),
                            border: Border.all(color: AppColors.outlineVariant),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Rangi: $routeColor',
                          style: AppTypography.textTheme.labelLarge?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'DAKIKA',
                      style: AppTypography.textTheme.labelSmall?.copyWith(
                        color: AppColors.onSecondaryContainer,
                      ),
                    ),
                    Text(
                      '$durationMinutes',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _StatBox(icon: Icons.straighten, label: 'Umbali', value: '${distanceKm}km')),
              const SizedBox(width: 16),
              Expanded(child: _StatBox(icon: Icons.directions_bus, label: 'Vituo', value: '$stopsCount stops')),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                  Container(width: 2, height: 48, color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StopLabel(label: 'Anzia hapa', value: origin),
                    const SizedBox(height: 20),
                    _StopLabel(label: 'Mwisho', value: destination),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Anza safari',
            icon: Icons.arrow_forward,
            onPressed: onStart,
            variant: AppButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StopLabel extends StatelessWidget {
  const _StopLabel({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
        Text(value, style: AppTypography.textTheme.labelLarge),
      ],
    );
  }
}

class _AltRouteCard extends StatelessWidget {
  const _AltRouteCard({
    required this.name,
    required this.duration,
    required this.distance,
  });

  final String name;
  final int duration;
  final double distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.alt_route, color: AppColors.secondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.textTheme.labelLarge),
                Text(
                  'Dakika $duration • ${distance}km',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
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
