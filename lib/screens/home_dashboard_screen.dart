import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/image_urls.dart';
import '../core/router/app_router.dart';
import '../core/services/auth_service.dart';
import '../core/services/firestore_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/glass_card.dart';
import '../widgets/rider_bottom_nav_bar.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 16, AppSpacing.marginMobile, 8),
              child: RiiderHeader(
                onMenu: () => context.push(AppRoutes.admin),
                trailing: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: ImageUrls.headerAvatar,
                    width: 28,
                    height: 28,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 28,
                      height: 28,
                      color: AppColors.surfaceContainerLow,
                      child: const Icon(Icons.person, size: 16, color: AppColors.primary),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 28,
                      height: 28,
                      color: AppColors.surfaceContainerLow,
                      child: const Icon(Icons.person, size: 16, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 8, AppSpacing.marginMobile, 118),
                children: [
                  Text(
                    'Good morning, Alex',
                    style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Where are you going today?',
                    style: AppTypography.headlineMdMobile.copyWith(color: AppColors.onSurface),
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 1.45,
                            child: CachedNetworkImage(imageUrl: ImageUrls.dashboardMap, fit: BoxFit.cover),
                          ),
                          Positioned(
                            left: 16,
                            top: 16,
                            child: _MiniCard(
                              title: 'Closest Ride',
                              subtitle: '3 mins away',
                              action: 'Request',
                              onTap: () => context.push(AppRoutes.rideHailing),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: context.read<FirestoreService>().watchActiveTrips(
                          userId: context.read<AuthService>().currentUser?.uid,
                        ),
                    builder: (context, snapshot) {
                      final trips = snapshot.data ?? const [];
                      if (trips.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      final trip = trips.first;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          onTap: () => context.push(
                            AppRoutes.activeTrip,
                            extra: {
                              'destination': trip['destination'] ?? 'Live destination',
                              'routeId': trip['routeId'] ?? 'live-route',
                            },
                          ),
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.directions_car_rounded, color: Colors.white),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Active Trip', style: AppTypography.caption.copyWith(color: Colors.white70)),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${trip['driverName'] ?? 'Live driver'} • ETA ${trip['etaMinutes'] ?? 0} min',
                                        style: AppTypography.labelMd.copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  InkWell(
                    onTap: () => context.push(AppRoutes.wallet),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppColors.walletGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.account_balance_wallet, color: Colors.white),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('RIIDER Wallet', style: AppTypography.caption.copyWith(color: Colors.white70)),
                                const SizedBox(height: 4),
                                Text('TSh 4,280.50', style: AppTypography.headlineMdMobile.copyWith(color: Colors.white)),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => context.push(AppRoutes.wallet),
                            icon: const Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Our Services', style: AppTypography.labelMd.copyWith(letterSpacing: 1.2)),
                      TextButton(onPressed: () => context.push(AppRoutes.cargo), child: const Text('See all')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.95,
                    children: [
                      _ServiceTile(icon: Icons.directions_car, label: 'Ride', onTap: () => context.push(AppRoutes.rideHailing)),
                      _ServiceTile(icon: Icons.directions_bus, label: 'Bus Pool', onTap: () => context.push(AppRoutes.busPool)),
                      _ServiceTile(icon: Icons.local_shipping, label: 'Freight', onTap: () => context.push(AppRoutes.freight)),
                      _ServiceTile(icon: Icons.ac_unit, label: 'Cold Cargo', onTap: () => context.push(AppRoutes.coldChain)),
                      _ServiceTile(icon: Icons.inventory_2_outlined, label: 'Logistics', onTap: () => context.push(AppRoutes.cargo)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Activity', style: AppTypography.labelMd.copyWith(letterSpacing: 1.2)),
                      TextButton(onPressed: () => context.push(AppRoutes.tripHistory), child: const Text('View all')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _ActivityCard(
                    icon: Icons.inventory_2_outlined,
                    title: 'Freight Shipment #8821',
                    subtitle: 'Sent to Los Angeles Distribution',
                    status: 'In Transit',
                    statusColor: AppColors.secondaryContainer,
                    meta: 'Estimated: 2h',
                  ),
                  const SizedBox(height: 12),
                  _ActivityCard(
                    icon: Icons.history,
                    title: 'Ride History',
                    subtitle: 'Downtown Corporate Hub',
                    status: 'Completed',
                    statusColor: AppColors.primary,
                    meta: 'May 14, 2024',
                  ),
                  const SizedBox(height: 12),
                  _ActivityCard(
                    icon: Icons.ac_unit,
                    title: 'Cold Storage #4490',
                    subtitle: 'Pharmaceutical Delivery',
                    status: 'Pending',
                    statusColor: AppColors.tertiary,
                    meta: 'Scheduled: 4 PM',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const RiderBottomNavBar(currentTab: RiderNavTab.home),
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.title, required this.subtitle, required this.action, required this.onTap});
  final String title;
  final String subtitle;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.labelMd),
          Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: onTap, child: Text(action)),
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.03),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(label, textAlign: TextAlign.center, style: AppTypography.caption),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
    required this.meta,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.surfaceContainerLow,
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelMd),
                Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 2),
                Text(meta, style: AppTypography.caption.copyWith(color: AppColors.outline)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(status, style: AppTypography.caption.copyWith(color: statusColor)),
          ),
        ],
      ),
    );
  }
}
