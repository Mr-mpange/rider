import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_branding.dart';
import '../core/constants/image_urls.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/rider_bottom_nav_bar.dart';

class RideHailingScreen extends StatefulWidget {
  const RideHailingScreen({super.key});

  @override
  State<RideHailingScreen> createState() => _RideHailingScreenState();
}

class _RideHailingScreenState extends State<RideHailingScreen> {
  int _selectedCategory = 2;

  static const _categories = [
    _VehicleCategory(icon: Icons.directions_car, label: 'Economy'),
    _VehicleCategory(icon: Icons.airport_shuttle_outlined, label: 'Comfort'),
    _VehicleCategory(icon: Icons.grade, label: 'Premium Black'),
    _VehicleCategory(icon: Icons.electric_car_outlined, label: 'SUV XL'),
    _VehicleCategory(icon: Icons.two_wheeler, label: 'Moto Swift'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(imageUrl: ImageUrls.mapNightLagos, fit: BoxFit.cover),
          ),
          Container(color: AppColors.primary.withValues(alpha: 0.12)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.menu, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Text(AppBranding.appName, style: AppTypography.labelMd.copyWith(color: Colors.white, letterSpacing: 2)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text('Destination: Market St.', style: AppTypography.caption.copyWith(color: AppColors.primary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.my_location, size: 18, color: AppColors.primary),
                            Container(width: 2, height: 28, color: AppColors.outlineVariant),
                            const Icon(Icons.location_on, size: 18, color: AppColors.secondaryContainer),
                          ],
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PICKUP', style: TextStyle(fontSize: 11, color: AppColors.outline, letterSpacing: 1)),
                              SizedBox(height: 2),
                              Text('Grand Central Terminal', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                              SizedBox(height: 12),
                              Divider(height: 1),
                              SizedBox(height: 12),
                              Text('DESTINATION', style: TextStyle(fontSize: 11, color: AppColors.outline, letterSpacing: 1)),
                              SizedBox(height: 2),
                              Text('Market St.', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => context.push(AppRoutes.destinationSearch),
                          icon: const Icon(Icons.layers_outlined, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 16, AppSpacing.marginMobile, 88),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(999)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('VEHICLE CATEGORIES', style: AppTypography.caption.copyWith(letterSpacing: 1.2, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 96,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final item = _categories[index];
                            final selected = index == _selectedCategory;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedCategory = index),
                              child: Container(
                                width: 108,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: selected ? AppColors.primary : AppColors.surfaceContainerLowest,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: selected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(item.icon, color: selected ? Colors.white : AppColors.primary, size: 22),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.label,
                                      textAlign: TextAlign.center,
                                      style: AppTypography.caption.copyWith(
                                        color: selected ? Colors.white : AppColors.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(14),
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
                          onPressed: () => context.push(AppRoutes.activeTrip),
                          icon: const Icon(Icons.trending_flat),
                          label: Text('Confirm ${_categories[_selectedCategory].label}'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Positioned(left: 0, right: 0, bottom: 0, child: RiderBottomNavBar(currentTab: RiderNavTab.home)),
        ],
      ),
    );
  }
}

class _VehicleCategory {
  const _VehicleCategory({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
