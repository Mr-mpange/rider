import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../core/services/auth_service.dart';
import '../core/services/firestore_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/navigation_utils.dart';
import '../core/utils/transparent_image.dart';

class ActiveTripScreen extends StatefulWidget {
  const ActiveTripScreen({super.key});

  @override
  State<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends State<ActiveTripScreen> {
  final MapController _mapController = MapController();
  bool _mapOffline = false;

  static const _center = LatLng(-6.7924, 39.2083);
  static const _driver = LatLng(-6.7858, 39.2148);
  static const _pickup = LatLng(-6.8015, 39.2012);
  static const _dropoff = LatLng(-6.7739, 39.2386);

  final List<LatLng> _route = const [
    LatLng(-6.8015, 39.2012),
    LatLng(-6.7974, 39.2050),
    LatLng(-6.7930, 39.2095),
    LatLng(-6.7890, 39.2122),
    LatLng(-6.7858, 39.2148),
    LatLng(-6.7810, 39.2212),
    LatLng(-6.7772, 39.2290),
    LatLng(-6.7739, 39.2386),
  ];

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthService>().currentUser?.uid;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: _mapOffline
                ? _OfflineMapFallback(
                    route: _route,
                    driver: _driver,
                    pickup: _pickup,
                    dropoff: _dropoff,
                  )
                : FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _center,
                      initialZoom: 13.5,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.usafir.rider',
                        errorImage: MemoryImage(transparentPngBytes()),
                        errorTileCallback: (tile, error, stackTrace) {
                          if (!_mapOffline && mounted) {
                            setState(() => _mapOffline = true);
                          }
                        },
                      ),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _route,
                            strokeWidth: 6,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _pickup,
                            width: 42,
                            height: 42,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.secondaryContainer, width: 4),
                              ),
                              child: const Icon(Icons.storefront_rounded, color: AppColors.secondary, size: 18),
                            ),
                          ),
                          Marker(
                            point: _driver,
                            width: 68,
                            height: 68,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 5),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.30),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.directions_car_rounded, color: Colors.white, size: 30),
                            ),
                          ),
                          Marker(
                            point: _dropoff,
                            width: 42,
                            height: 42,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.secondaryContainer, width: 4),
                              ),
                              child: const Icon(Icons.flag_rounded, color: AppColors.secondary, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.02),
                      Colors.black.withValues(alpha: 0.06),
                      Colors.black.withValues(alpha: 0.24),
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
          ),
          if (_mapOffline)
            Positioned(
              left: 16,
              right: 16,
              top: MediaQuery.of(context).padding.top + 68,
              child: _OfflineBanner(
                title: 'Map offline',
                body: 'Showing the trip layout while live map tiles reconnect.',
              ),
            ),
          if (userId != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 92,
              child: StreamBuilder<Map<String, dynamic>?>(
                stream: context.read<FirestoreService>().watchActiveTrip(userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const _TripStateBanner(
                      icon: Icons.error_outline,
                      title: 'Trip status unavailable',
                      body: 'Firestore could not load the active trip right now.',
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const _TripStateBanner(
                      icon: Icons.watch_later_outlined,
                      title: 'Loading trip',
                      body: 'Checking your active trip in Firestore.',
                    );
                  }
                  final trip = snapshot.data;
                  if (trip == null) {
                    return const _TripStateBanner(
                      icon: Icons.trip_origin,
                      title: 'No active trip',
                      body: 'Start a trip from Home to see live tracking here.',
                    );
                  }
                  return _TripStateBanner(
                    icon: Icons.local_taxi_rounded,
                    title: '${trip['status'] ?? 'Live'} trip',
                    body: '${trip['destination'] ?? 'Unknown destination'} • ETA ${trip['etaMinutes'] ?? 4} min',
                  );
                },
              ),
            ),
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: 14,
                  top: 10,
                  child: _RoundIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => popOrGoHome(context),
                  ),
                ),
                Positioned(
                  left: 72,
                  right: 14,
                  top: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.72),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.45)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on_rounded, size: 18, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Destination: Market St.',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TripStateBanner extends StatelessWidget {
  const _TripStateBanner({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: AppTypography.labelMd),
                    const SizedBox(height: 4),
                    Text(body, style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OfflineMapFallback extends StatelessWidget {
  const _OfflineMapFallback({
    required this.route,
    required this.driver,
    required this.pickup,
    required this.dropoff,
  });

  final List<LatLng> route;
  final LatLng driver;
  final LatLng pickup;
  final LatLng dropoff;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEFF4F8), Color(0xFFDCE7F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.map_outlined, size: 44, color: AppColors.primary),
              const SizedBox(height: 12),
              Text('Live map offline', style: AppTypography.labelMd),
              const SizedBox(height: 6),
              Text(
                'Route markers and trip status are still available while tiles reconnect.',
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.78),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const Icon(Icons.wifi_off_rounded, color: AppColors.secondary, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(body, style: AppTypography.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.94),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: AppColors.primary),
        ),
      ),
    );
  }
}
