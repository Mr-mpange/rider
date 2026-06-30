import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/image_urls.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/live_tracking_card.dart';
import '../widgets/rider_bottom_nav_bar.dart';

class RideHailingScreen extends StatelessWidget {
  const RideHailingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(imageUrl: ImageUrls.mapNightLagos, fit: BoxFit.cover),
          ),
          Container(color: AppColors.primary.withValues(alpha: 0.15)),
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
                      Text('RIDER', style: AppTypography.labelMd.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                            Container(width: 2, height: 28, color: AppColors.outlineVariant),
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
                          ],
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('From', style: TextStyle(fontSize: 12, color: AppColors.outline)),
                              SizedBox(height: 2),
                              Text('Kariakoo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                              SizedBox(height: 10),
                              Divider(height: 1),
                              SizedBox(height: 10),
                              Text('To', style: TextStyle(fontSize: 12, color: AppColors.outline)),
                              SizedBox(height: 2),
                              Text('Ubungo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 16, AppSpacing.marginMobile, 0),
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
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(14)),
                            child: const Icon(Icons.directions_car, color: AppColors.primary),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dar Direct', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                SizedBox(height: 2),
                                Text('4 min away', style: TextStyle(fontSize: 12, color: AppColors.secondary)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('TSh 4,200', style: AppTypography.headlineMdMobile.copyWith(fontSize: 18)),
                              Text('Estimated Total', style: AppTypography.caption),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 118,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: const [
                            _RideOptionCard(title: 'Executive', price: 'TSh 7,500', selected: true, badge: 'BEST'),
                            SizedBox(width: 12),
                            _RideOptionCard(title: 'Standard', price: 'TSh 4,200'),
                            SizedBox(width: 12),
                            _RideOptionCard(title: 'Transit XL', price: 'TSh 6,800', badge: 'XL'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      const LiveTrackingCard(
                        title: 'Live ride tracking',
                        subtitle: 'Vehicle is being assigned from Kariakoo',
                        distance: '2.1 km',
                        eta: '4 min',
                        status: 'LIVE',
                        progress: 0.42,
                        primaryActionLabel: 'Call Driver',
                        secondaryActionLabel: 'Share Trip',
                      ),
                      const SizedBox(height: 14),
                      _DriverCard(),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.bolt, color: AppColors.tertiary, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'High demand: prices are slightly higher than usual',
                                style: AppTypography.caption.copyWith(color: AppColors.tertiary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.push(AppRoutes.activeTrip),
                          child: const Text('Confirm Rider Executive'),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Positioned(left: 0, right: 0, bottom: 0, child: RiderBottomNavBar(currentTab: RiderNavTab.trips)),
        ],
      ),
    );
  }
}

class _RideOptionCard extends StatelessWidget {
  const _RideOptionCard({required this.title, required this.price, this.badge, this.selected = false});
  final String title;
  final String price;
  final String? badge;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: selected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: selected ? Colors.white : AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(999)),
              child: Text(badge!, style: AppTypography.caption.copyWith(color: selected ? AppColors.primary : AppColors.primary)),
            ),
          const Spacer(),
          Text(title, style: AppTypography.labelMd.copyWith(color: selected ? Colors.white : AppColors.onSurface)),
          const SizedBox(height: 2),
          Text(price, style: AppTypography.labelMd.copyWith(color: selected ? Colors.white70 : AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _DriverCard extends StatelessWidget {
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
          CircleAvatar(radius: 22, backgroundImage: CachedNetworkImageProvider(ImageUrls.driverAvatar)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Asha M.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text('4.9 • Toyota Premio', style: TextStyle(fontSize: 12, color: AppColors.outline)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.message, color: AppColors.primary),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
