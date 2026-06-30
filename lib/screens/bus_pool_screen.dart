import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/app_bottom_nav_bar.dart';

class BusPoolScreen extends StatelessWidget {
  const BusPoolScreen({super.key});

  static const CameraPosition _darEsSalaam = CameraPosition(
    target: LatLng(-6.7924, 39.2083),
    zoom: 12.6,
  );

  static final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('ubungo'),
      position: LatLng(-6.7911, 39.2077),
      infoWindow: InfoWindow(title: 'Ubungo Terminal'),
    ),
    Marker(
      markerId: MarkerId('mwenge'),
      position: LatLng(-6.7702, 39.2429),
      infoWindow: InfoWindow(title: 'Mwenge Stand'),
    ),
    Marker(
      markerId: MarkerId('posta'),
      position: LatLng(-6.8167, 39.2877),
      infoWindow: InfoWindow(title: 'Posta Mpya'),
    ),
  };

  static final Set<Polyline> _routes = {
    Polyline(
      polylineId: PolylineId('pool-route'),
      points: [
        LatLng(-6.7911, 39.2077),
        LatLng(-6.7855, 39.2230),
        LatLng(-6.7785, 39.2350),
        LatLng(-6.7702, 39.2429),
      ],
      color: AppColors.primary,
      width: 6,
    ),
  };

  void _onNavTab(BuildContext context, AppNavTab tab) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _darEsSalaam,
            markers: _markers,
            polylines: _routes,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.16),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.14),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Text('BUS POOL', style: AppTypography.labelMd.copyWith(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Shared ride for commuters', style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant)),
                        const SizedBox(height: 6),
                        Text('Ubungo to Posta corridor', style: AppTypography.headlineMdMobile.copyWith(fontSize: 22)),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Expanded(child: _PoolStat(label: 'Seats', value: '18')),
                            Expanded(child: _PoolStat(label: 'Fare', value: 'TSh 1,800')),
                            Expanded(child: _PoolStat(label: 'ETA', value: '14 min')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 42,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.outlineVariant,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text('Available pool routes', style: AppTypography.headlineMdMobile.copyWith(fontSize: 18)),
                        const SizedBox(height: 12),
                        const _PoolRouteCard(
                          title: 'Ubungo Express Pool',
                          subtitle: 'Leaves every 12 mins',
                          price: 'TSh 1,800',
                          seats: '6 seats left',
                        ),
                        const SizedBox(height: 12),
                        const _PoolRouteCard(
                          title: 'Mwenge Connector',
                          subtitle: 'Stops at Mwenge and Posta',
                          price: 'TSh 2,200',
                          seats: '4 seats left',
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.push(AppRoutes.destinationSearch),
                            child: const Text('Book Bus Pool Seat'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentTab: AppNavTab.home,
        onTabSelected: (tab) => _onNavTab(context, tab),
      ),
    );
  }
}

class _PoolStat extends StatelessWidget {
  const _PoolStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.labelMd),
      ],
    );
  }
}

class _PoolRouteCard extends StatelessWidget {
  const _PoolRouteCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.seats,
  });

  final String title;
  final String subtitle;
  final String price;
  final String seats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryContainer,
            child: Icon(Icons.directions_bus, color: AppColors.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelMd),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.caption),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: AppTypography.labelMd.copyWith(color: AppColors.primary)),
              const SizedBox(height: 2),
              Text(seats, style: AppTypography.caption),
            ],
          ),
        ],
      ),
    );
  }
}
