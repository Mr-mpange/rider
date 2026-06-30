import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/image_urls.dart';
import '../core/models/bus_stop.dart';
import '../core/router/app_router.dart';
import '../core/services/firestore_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/stand_card.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key});

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  final _searchController = TextEditingController();
  final double _sheetExtent = 0.5;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onNavTab(AppNavTab tab) {
    switch (tab) {
      case AppNavTab.home:
        break;
      case AppNavTab.saved:
        context.go(AppRoutes.savedPlaces);
        break;
      case AppNavTab.reports:
        context.go(AppRoutes.reports);
        break;
      case AppNavTab.profile:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: ImageUrls.mapNightLagos,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.surfaceVariant),
              errorWidget: (context, url, error) => Container(color: AppColors.surfaceVariant),
            ),
          ),
          const _MapMarkers(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.marginMobile,
                16,
                AppSpacing.marginMobile,
                0,
              ),
              child: Column(
                children: [
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => _showDrawer(context),
                          icon: const Icon(Icons.menu, color: AppColors.primary),
                        ),
                        Expanded(
                          child: Text(
                            'RIDER',
                            textAlign: TextAlign.center,
                            style: AppTypography.textTheme.headlineSmall?.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.profile),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primaryContainer, width: 2),
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: ImageUrls.headerAvatar,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: () => context.push(AppRoutes.destinationSearch),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.outlineVariant.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 48,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.search, color: AppColors.primary),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Unaenda wapi?',
                                        style: AppTypography.textTheme.bodyLarge?.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 24,
                                      color: AppColors.outlineVariant,
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.mic, color: AppColors.onSurfaceVariant),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: AppSpacing.marginMobile,
            bottom: MediaQuery.of(context).size.height * 0.52,
            child: Column(
              children: [
                _FabButton(
                  icon: Icons.my_location,
                  small: true,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Location centering is not yet connected.')),
                  ),
                ),
                const SizedBox(height: 12),
                _FabButton(
                  icon: Icons.directions,
                  primary: true,
                  onTap: () => context.push(AppRoutes.destinationSearch),
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: _sheetExtent,
            minChildSize: 0.2,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.outlineVariant,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Stendi za karibu', style: AppTypography.textTheme.headlineSmall),
                          TextButton(
                            onPressed: () => context.push(AppRoutes.savedPlaces),
                            child: Text(
                              'Tazama zote',
                              style: AppTypography.textTheme.labelLarge?.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<List<BusStop>>(
                        stream: context.read<FirestoreService>().watchNearbyStops(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(AppSpacing.marginMobile),
                              child: ShimmerLoading(),
                            );
                          }
                          final stops = snapshot.data ?? [];
                          if (stops.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.location_off, size: 48, color: AppColors.outline),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Hakuna stendi za karibu',
                                      style: AppTypography.textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Jaribu kutafuta kituo kingine',
                                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return ListView.separated(
                            controller: scrollController,
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.marginMobile,
                              0,
                              AppSpacing.marginMobile,
                              100,
                            ),
                            itemCount: stops.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final stop = stops[index];
                              return StandCard(
                                stop: stop,
                                opacity: index == stops.length - 1 ? 0.8 : 1.0,
                                onTap: () => context.push(
                                  AppRoutes.routeRecommendation,
                                  extra: {
                                    'origin': stop.name,
                                    'destination': 'Posta Mpya',
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNavBar(
              currentTab: AppNavTab.home,
              onTabSelected: _onNavTab,
            ),
          ),
        ],
      ),
    );
  }

  void _showDrawer(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Admin Dashboard'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push(AppRoutes.admin);
                },
              ),
            ),
            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.bookmark),
                title: const Text('Sehemu Zilizohifadhiwa'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.go(AppRoutes.savedPlaces);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapMarkers extends StatelessWidget {
  const _MapMarkers();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned(
              left: constraints.maxWidth * 0.48,
              top: constraints.maxHeight * 0.45,
              child: _UserLocationMarker(),
            ),
            Positioned(
              left: constraints.maxWidth * 0.55,
              top: constraints.maxHeight * 0.40,
              child: const _StopMarker(label: 'Mwenge'),
            ),
            Positioned(
              left: constraints.maxWidth * 0.30,
              top: constraints.maxHeight * 0.55,
              child: const _StopMarker(label: 'Ubungo'),
            ),
          ],
        );
      },
    );
  }
}

class _UserLocationMarker extends StatefulWidget {
  @override
  State<_UserLocationMarker> createState() => _UserLocationMarkerState();
}

class _UserLocationMarkerState extends State<_UserLocationMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 48 * _controller.value,
                height: 48 * _controller.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.4 * (1 - _controller.value)),
                ),
              );
            },
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8),
              ],
            ),
            child: Center(
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StopMarker extends StatelessWidget {
  const _StopMarker({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8),
            ],
          ),
          child: const Icon(Icons.directions_bus, color: AppColors.onPrimaryContainer, size: 20),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Text(label, style: AppTypography.textTheme.labelSmall),
        ),
      ],
    );
  }
}

class _FabButton extends StatelessWidget {
  const _FabButton({
    required this.icon,
    required this.onTap,
    this.small = false,
    this.primary = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool small;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final size = small ? 48.0 : 56.0;
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(primary ? 16 : 12),
      color: primary ? AppColors.secondaryContainer : AppColors.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(primary ? 16 : 12),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            color: primary ? AppColors.onSecondaryContainer : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
