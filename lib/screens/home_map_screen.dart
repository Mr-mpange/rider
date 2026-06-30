import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
  GoogleMapController? _mapController;
  final _searchController = TextEditingController();

  static const _center = CameraPosition(
    target: LatLng(-6.7924, 39.2083),
    zoom: 12.5,
  );

  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('current'),
      position: LatLng(-6.7924, 39.2083),
      infoWindow: InfoWindow(title: 'You are here'),
    ),
    Marker(
      markerId: MarkerId('ubungo'),
      position: LatLng(-6.7911, 39.2077),
      infoWindow: InfoWindow(title: 'Ubungo'),
    ),
    Marker(
      markerId: MarkerId('mwenge'),
      position: LatLng(-6.7702, 39.2429),
      infoWindow: InfoWindow(title: 'Mwenge'),
    ),
    Marker(
      markerId: MarkerId('posta'),
      position: LatLng(-6.8167, 39.2877),
      infoWindow: InfoWindow(title: 'Posta Mpya'),
    ),
  };

  final Set<Polyline> _routes = {
    Polyline(
      polylineId: PolylineId('main-route'),
      points: [
        LatLng(-6.7911, 39.2077),
        LatLng(-6.7850, 39.2210),
        LatLng(-6.7785, 39.2350),
        LatLng(-6.7702, 39.2429),
      ],
      color: AppColors.primary,
      width: 6,
    ),
  };

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onNavTab(AppNavTab tab) {
    switch (tab) {
      case AppNavTab.home:
        break;
      case AppNavTab.saved:
        context.go(AppRoutes.savedPlaces);
      case AppNavTab.reports:
        context.go(AppRoutes.reports);
      case AppNavTab.profile:
        context.go(AppRoutes.profile);
    }
  }

  Future<void> _centerMap() async {
    await _mapController?.animateCamera(CameraUpdate.newCameraPosition(_center));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _center,
            onMapCreated: (controller) => _mapController = controller,
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
                  Colors.black.withValues(alpha: 0.26),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.12),
                ],
              ),
            ),
          ),
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
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _showDrawer(context),
                        icon: const Icon(Icons.menu, color: Colors.white),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'RIDER',
                          style: AppTypography.textTheme.headlineSmall?.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        onPressed: _centerMap,
                        icon: const Icon(Icons.my_location, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () => context.push(AppRoutes.destinationSearch),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.96),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Unaenda wapi?',
                                style: AppTypography.textTheme.bodyLarge?.copyWith(color: AppColors.onSurfaceVariant),
                              ),
                            ),
                            const Icon(Icons.mic, color: AppColors.onSurfaceVariant),
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
                  onTap: _centerMap,
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
            initialChildSize: 0.5,
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
                    const SizedBox(height: 10),
                    Container(
                      width: 40,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.outlineVariant,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile, vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Stendi za karibu', style: AppTypography.textTheme.headlineSmall),
                          TextButton(
                            onPressed: () => context.push(AppRoutes.savedPlaces),
                            child: const Text('Tazama zote'),
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
                          final stops = snapshot.data ?? const <BusStop>[];
                          if (stops.isEmpty) {
                            return const Center(child: Text('Hakuna stendi za karibu'));
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
                                opacity: 1,
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
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentTab: AppNavTab.home,
        onTabSelected: _onNavTab,
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
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Admin Dashboard'),
              onTap: () {
                Navigator.pop(ctx);
                context.push(AppRoutes.admin);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Sehemu Zilizohifadhiwa'),
              onTap: () {
                Navigator.pop(ctx);
                context.go(AppRoutes.savedPlaces);
              },
            ),
          ],
        ),
      ),
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
    return Material(
      color: primary ? AppColors.primary : AppColors.surface.withValues(alpha: 0.95),
      shape: const CircleBorder(),
      elevation: 8,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: small ? 44 : 52,
          height: small ? 44 : 52,
          child: Icon(icon, color: primary ? Colors.white : AppColors.primary),
        ),
      ),
    );
  }
}
