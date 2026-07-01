import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../core/constants/app_branding.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/navigation_utils.dart';
import 'active_trip_screen.dart';
import '../widgets/rider_bottom_nav_bar.dart';

class RideHailingScreen extends StatefulWidget {
  const RideHailingScreen({super.key});

  @override
  State<RideHailingScreen> createState() => _RideHailingScreenState();
}

class _RideHailingScreenState extends State<RideHailingScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _pickupController = TextEditingController(text: 'Grand Central Terminal');
  final TextEditingController _destinationController = TextEditingController(text: 'Market St.');
  int _selectedCategory = 2;

  static const _pickup = LatLng(-6.7924, 39.2083);
  static const _destination = LatLng(-6.7768, 39.2431);
  static const _driver = LatLng(-6.7872, 39.2174);

  static const _categories = [
    _VehicleCategory(icon: Icons.directions_car_rounded, label: 'Economy'),
    _VehicleCategory(icon: Icons.airport_shuttle_outlined, label: 'Comfort'),
    _VehicleCategory(icon: Icons.star_rounded, label: 'Premium Black'),
    _VehicleCategory(icon: Icons.electric_car_outlined, label: 'SUV XL'),
    _VehicleCategory(icon: Icons.two_wheeler_rounded, label: 'Moto Swift'),
  ];

  void _confirmRide() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 420),
        reverseTransitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (_, animation, secondaryAnimation) => const ActiveTripScreen(),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          final slide = Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
          final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
          return FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slide, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(-6.786, 39.220),
                initialZoom: 13.1,
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
                      points: [_pickup, LatLng(-6.7900, 39.2140), _destination],
                      strokeWidth: 5,
                      color: AppColors.primary.withValues(alpha: 0.85),
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _pickup,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.my_location, color: AppColors.primary, size: 28),
                    ),
                    Marker(
                      point: _driver,
                      width: 52,
                      height: 52,
          child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: const Icon(Icons.directions_car_rounded, color: Colors.white, size: 24),
                      ),
                    ),
                    Marker(
                      point: _destination,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_pin, color: AppColors.secondary, size: 34),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            top: MediaQuery.of(context).padding.top + 74,
            child: _EtaBadge(
              eta: 'Driver ETA 4 min',
              sublabel: '2.1 km away',
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.08),
                  Colors.black.withValues(alpha: 0.22),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  _RoundButton(
                    icon: Icons.menu_rounded,
                    onTap: () => popOrGoHome(context),
                  ),
                  const SizedBox(width: 12),
                  Text(AppBranding.appName, style: AppTypography.labelMd.copyWith(color: Colors.white, letterSpacing: 2)),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: MediaQuery.of(context).padding.top + 58,
            child: _RouteEditCard(
              pickup: _pickupController.text,
              destination: _destinationController.text,
              onPickupTap: _pickPickup,
              onDestinationTap: _pickDestination,
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.38,
            minChildSize: 0.24,
            maxChildSize: 0.78,
            builder: (context, scrollController) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 12 + MediaQuery.of(context).padding.bottom),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: Container(
                        color: AppColors.surface,
                        child: SafeArea(
                          top: false,
                          child: SingleChildScrollView(
                            controller: scrollController,
                            padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 14, AppSpacing.marginMobile, 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 42,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: AppColors.outlineVariant.withValues(alpha: 0.8),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'Live ride setup',
                                  style: AppTypography.labelMd.copyWith(letterSpacing: 1.1),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.28)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _RouteRow(
                                        title: 'PICKUP',
                                        value: _pickupController.text,
                                        icon: Icons.my_location,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                        child: Divider(height: 1),
                                      ),
                                      _RouteRow(
                                        title: 'DESTINATION',
                                        value: _destinationController.text,
                                        icon: Icons.location_on,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Vehicle Categories',
                                  style: AppTypography.caption.copyWith(letterSpacing: 1.2, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 96,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _categories.length,
                                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                                    itemBuilder: (context, index) {
                                      final item = _categories[index];
                                      final isSelected = index == _selectedCategory;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() => _selectedCategory = index);
                                          _confirmRide();
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 180),
                                          width: 92,
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: isSelected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.4),
                                            ),
                                            boxShadow: isSelected
                                                ? [
                                                    BoxShadow(
                                                      color: AppColors.primary.withValues(alpha: 0.16),
                                                      blurRadius: 18,
                                                      offset: const Offset(0, 8),
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(item.icon, color: isSelected ? Colors.white : AppColors.primary, size: 20),
                                              const SizedBox(height: 6),
                                              Text(
                                                item.label,
                                                textAlign: TextAlign.center,
                                                style: AppTypography.caption.copyWith(
                                                  color: isSelected ? Colors.white : AppColors.onSurface,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.credit_card, color: AppColors.primary),
                                      const SizedBox(width: 10),
                                      Text('VISA', style: AppTypography.labelMd),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () => context.push(AppRoutes.paymentMethods),
                                        child: const Text('Change'),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _confirmRide,
                                    icon: const Icon(Icons.trending_flat),
                                    label: const Text('Start live tracking'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const Positioned(left: 0, right: 0, bottom: 0, child: RiderBottomNavBar(currentTab: RiderNavTab.home)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _pickDestination() async {
    final selected = await context.push<String>(
      AppRoutes.destinationSearch,
      extra: {
        'returnSelection': true,
        'origin': 'Kituo cha Ubungo',
      },
    );
    if (selected != null && selected.isNotEmpty) {
      setState(() => _destinationController.text = selected);
    }
  }

  Future<void> _pickPickup() async {
    final selected = await context.push<String>(
      AppRoutes.destinationSearch,
      extra: {
        'returnSelection': true,
        'origin': _destinationController.text,
        'selectionLabel': 'pickup',
      },
    );
    if (selected != null && selected.isNotEmpty) {
      setState(() => _pickupController.text = selected);
    }
  }
}

class _VehicleCategory {
  const _VehicleCategory({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
      ),
    );
  }
}

class _RouteEditCard extends StatelessWidget {
  const _RouteEditCard({
    required this.pickup,
    required this.destination,
    required this.onPickupTap,
    required this.onDestinationTap,
  });

  final String pickup;
  final String destination;
  final VoidCallback onPickupTap;
  final VoidCallback onDestinationTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onPickupTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RouteLine(
                title: 'PICKUP',
                value: pickup,
                icon: Icons.my_location_rounded,
                onTap: onPickupTap,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1),
              ),
              _RouteLine(
                title: 'DESTINATION',
                value: destination,
                icon: Icons.location_on_rounded,
                onTap: onDestinationTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteLine extends StatelessWidget {
  const _RouteLine({
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.caption.copyWith(
                    letterSpacing: 1,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMd.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _EtaBadge extends StatelessWidget {
  const _EtaBadge({required this.eta, required this.sublabel});

  final String eta;
  final String sublabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            eta,
            style: AppTypography.labelMd.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
          Text(
            sublabel,
            style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Icon(icon, size: 18, color: title == 'PICKUP' ? AppColors.primary : AppColors.secondaryContainer),
            Container(width: 2, height: 22, color: AppColors.outlineVariant),
            Icon(Icons.location_on, size: 18, color: AppColors.secondaryContainer),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.caption.copyWith(letterSpacing: 1)),
              const SizedBox(height: 4),
              Text(value, style: AppTypography.labelMd.copyWith(fontSize: 18)),
            ],
          ),
        ),
      ],
    );
  }
}
