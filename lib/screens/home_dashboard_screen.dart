import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/image_urls.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.menu, size: 20),
                    onPressed: () => context.push(AppRoutes.admin),
                  ),
                  const SizedBox(width: 8),
                  Text('RIDER', style: AppTypography.labelMd.copyWith(color: AppColors.primary)),
                  const Spacer(),
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: CachedNetworkImageProvider(ImageUrls.headerAvatar),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 4, AppSpacing.marginMobile, 110),
                children: [
                  Text('Good morning, Asha', style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 1.2)),
                  const SizedBox(height: 6),
                  Text('Where are you going today?', style: AppTypography.headlineMdMobile.copyWith(color: AppColors.onSurface)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 1.45,
                                child: CachedNetworkImage(imageUrl: ImageUrls.dashboardMap, fit: BoxFit.cover),
                              ),
                              Positioned(
                                left: 14,
                                top: 14,
                                child: _MiniCard(
                                  title: 'Closest Trip',
                                  subtitle: '3 min away',
                                  action: 'Request',
                                  onTap: () => context.push(AppRoutes.rideHailing),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('RIDER WALLET', style: AppTypography.caption.copyWith(color: Colors.white70)),
                              const SizedBox(height: 4),
                              Text('TSh 4,280.50', style: AppTypography.headlineMdMobile.copyWith(color: Colors.white)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.wallet),
                          child: const Text('Details', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Services', style: AppTypography.labelMd),
                      TextButton(onPressed: () => context.push(AppRoutes.cargo), child: const Text('See all')),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.96,
                    children: [
                      _ServiceTile(icon: Icons.directions_car, label: 'Ride', onTap: () => context.push(AppRoutes.rideHailing)),
                      _ServiceTile(icon: Icons.directions_bus, label: 'Bus Pool', onTap: () => context.push(AppRoutes.busPool)),
                      _ServiceTile(icon: Icons.local_shipping, label: 'Freight', onTap: () => context.push(AppRoutes.cargo)),
                      _ServiceTile(icon: Icons.ac_unit, label: 'Cold Cargo', onTap: () => context.push(AppRoutes.cargo)),
                      _ServiceTile(icon: Icons.map_outlined, label: 'Routes', onTap: () => context.push(AppRoutes.savedPlaces)),
                      _ServiceTile(icon: Icons.smart_toy_outlined, label: 'Copilot', onTap: () => context.push(AppRoutes.copilot)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Activity', style: AppTypography.labelMd),
                      TextButton(onPressed: () => context.push(AppRoutes.savedPlaces), child: const Text('View all')),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _ActivityCard(title: 'Freight Shipment', subtitle: 'Sent to Dar Port', status: 'In Transit', statusColor: AppColors.secondary),
                  const SizedBox(height: 12),
                  _ActivityCard(title: 'Ride History', subtitle: 'December 26, 2024', status: 'COMPLETED', statusColor: AppColors.primary),
                  const SizedBox(height: 12),
                  _ActivityCard(title: 'Cold Storage', subtitle: 'Delivered on time', status: 'ON TIME', statusColor: AppColors.tertiary),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.copilot),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
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
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppTypography.labelMd),
        Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: onTap, child: Text(action)),
        ),
      ]),
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
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: AppTypography.caption),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.title, required this.subtitle, required this.status, required this.statusColor});
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 16, backgroundColor: AppColors.surfaceContainerLow, child: Icon(Icons.local_shipping_outlined, size: 16, color: AppColors.primary)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: AppTypography.labelMd),
              Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
            child: Text(status, style: AppTypography.caption.copyWith(color: statusColor)),
          ),
        ],
      ),
    );
  }
}
