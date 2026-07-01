import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../core/theme/app_colors.dart';

class ActiveTripScreen extends StatefulWidget {
  const ActiveTripScreen({super.key});

  @override
  State<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends State<ActiveTripScreen> {
  final MapController _mapController = MapController();

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
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
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
                    child: const Icon(Icons.circle, color: Colors.green, size: 18),
                  ),
                  Marker(
                    point: _driver,
                    width: 52,
                    height: 52,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Icon(Icons.directions_car, color: Colors.white, size: 24),
                    ),
                  ),
                  Marker(
                    point: _dropoff,
                    width: 42,
                    height: 42,
                    child: const Icon(Icons.location_on, color: Colors.deepOrange, size: 30),
                  ),
                ],
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.18),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.10),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height * 0.28,
            child: FloatingActionButton.small(
              heroTag: 'center_trip_map',
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              onPressed: () => _mapController.move(_driver, 14.5),
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
