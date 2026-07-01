import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_branding.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/app_dialogs.dart';
import '../widgets/glass_card.dart';

enum _BusPoolTab { home, pooling, wallet, profile }

class BusPoolScreen extends StatelessWidget {
  const BusPoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 16, AppSpacing.marginMobile, 112),
          children: [
            Row(
              children: [
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.menu, color: AppColors.primary)),
                const SizedBox(width: 8),
                Text(AppBranding.appName, style: AppTypography.labelMd.copyWith(color: AppColors.primary, letterSpacing: 2)),
                const Spacer(),
                IconButton(
                  onPressed: () => AppDialogs.showInfoSheet(context, title: 'Notifications', body: 'Route and seat alerts appear here.', cta: 'Close'),
                  icon: const Icon(Icons.notifications_outlined, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _TopTab(label: 'Ride Hailing', onTap: () => context.push(AppRoutes.rideHailing)),
                  const SizedBox(width: 8),
                  _TopTab(label: 'Bus Pooling', selected: true),
                  const SizedBox(width: 8),
                  _TopTab(label: 'Freight', onTap: () => context.push(AppRoutes.freight)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Community Routes', style: AppTypography.headlineMdMobile),
            const SizedBox(height: 6),
            Text(
              'Shared corporate shuttles for your daily commute.',
              style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.schedule, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(child: Text('Morning Peak', style: AppTypography.labelMd)),
                  const Icon(Icons.keyboard_arrow_down, color: AppColors.outline),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Active Fleet', style: AppTypography.labelMd.copyWith(letterSpacing: 1)),
            const SizedBox(height: 10),
            const _RouteCard(
              title: 'Main Corridor Route',
              subtitle: 'High frequency peak-hour service',
              from: 'Tech District Express',
              to: 'Grand Central Terminal',
              seats: '18 / 24 Seats Filled',
            ),
            const SizedBox(height: 12),
            const _RouteCard(
              title: 'Financial Loop',
              subtitle: 'North Gate to Main Hub',
              from: 'North Gate Entrance',
              to: 'Main Hub Platform 4',
              seats: '6 / 24 Seats Filled',
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recommended for You', style: AppTypography.labelMd.copyWith(letterSpacing: 1)),
                TextButton(
                  onPressed: () => AppDialogs.showInfoSheet(context, title: 'Recommended Routes', body: 'View all suggested community shuttle routes.', cta: 'View'),
                  child: const Text('See all'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const _RecommendTile(icon: Icons.work_outline, title: 'Office To Gym', subtitle: 'Daily • 5:15 PM'),
            const _RecommendTile(icon: Icons.home_outlined, title: 'Downtown Shuttle', subtitle: 'Weekdays • 8:00 AM'),
            const _RecommendTile(icon: Icons.flight_outlined, title: 'Airport Link', subtitle: 'Every 30 mins'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => AppDialogs.showInfoSheet(context, title: 'Suggest Route', body: 'Submit a new community shuttle route for review.', cta: 'Submit'),
                    icon: const Icon(Icons.add_road),
                    label: const Text('Suggest Route'),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () => AppDialogs.showInfoSheet(context, title: 'Refresh', body: 'Fleet availability refreshed.', cta: 'Close'),
                  icon: const Icon(Icons.refresh, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BusPoolBottomNav(
        current: _BusPoolTab.pooling,
        onSelect: (tab) {
          switch (tab) {
            case _BusPoolTab.home:
              context.go(AppRoutes.home);
            case _BusPoolTab.pooling:
              break;
            case _BusPoolTab.wallet:
              context.go(AppRoutes.wallet);
            case _BusPoolTab.profile:
              context.go(AppRoutes.profile);
          }
        },
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({required this.label, this.selected = false, this.onTap});
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(label, style: AppTypography.caption.copyWith(color: selected ? Colors.white : AppColors.onSurface)),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.title, required this.subtitle, required this.from, required this.to, required this.seats});
  final String title;
  final String subtitle;
  final String from;
  final String to;
  final String seats;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.labelMd),
          Text(subtitle, style: AppTypography.caption),
          const SizedBox(height: 12),
          Row(children: [const Icon(Icons.near_me, size: 16, color: AppColors.primary), const SizedBox(width: 6), Expanded(child: Text(from, style: AppTypography.caption))]),
          const SizedBox(height: 6),
          Row(children: [const Icon(Icons.timer_outlined, size: 16, color: AppColors.outline), const SizedBox(width: 6), Expanded(child: Text(to, style: AppTypography.caption))]),
          const SizedBox(height: 12),
          Text('Seat Occupancy', style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(seats, style: AppTypography.labelMd.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _RecommendTile extends StatelessWidget {
  const _RecommendTile({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: AppTypography.labelMd),
              Text(subtitle, style: AppTypography.caption),
            ]),
          ),
          const Icon(Icons.chevron_right, color: AppColors.outline),
        ],
      ),
    );
  }
}

class _BusPoolBottomNav extends StatelessWidget {
  const _BusPoolBottomNav({required this.current, required this.onSelect});
  final _BusPoolTab current;
  final ValueChanged<_BusPoolTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.4))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Item(icon: Icons.home_rounded, label: 'Home', selected: current == _BusPoolTab.home, onTap: () => onSelect(_BusPoolTab.home)),
              _Item(icon: Icons.directions_bus, label: 'Pooling', selected: current == _BusPoolTab.pooling, onTap: () => onSelect(_BusPoolTab.pooling)),
              _Item(icon: Icons.account_balance_wallet_outlined, label: 'Wallet', selected: current == _BusPoolTab.wallet, onTap: () => onSelect(_BusPoolTab.wallet)),
              _Item(icon: Icons.person_outline, label: 'Profile', selected: current == _BusPoolTab.profile, onTap: () => onSelect(_BusPoolTab.profile)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.icon, required this.label, required this.selected, required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(icon, color: color, size: 22), const SizedBox(height: 2), Text(label, style: AppTypography.caption.copyWith(color: color))],
        ),
      ),
    );
  }
}
