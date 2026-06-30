import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

enum RiderNavTab { home, trips, cargo, wallet, profile }

class RiderBottomNavBar extends StatelessWidget {
  const RiderBottomNavBar({
    super.key,
    required this.currentTab,
    this.onTabSelected,
  });

  final RiderNavTab currentTab;
  final ValueChanged<RiderNavTab>? onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.4))),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                selected: currentTab == RiderNavTab.home,
                onTap: () => _go(context, RiderNavTab.home),
              ),
              _NavItem(
                icon: Icons.directions_transit,
                label: 'Trips',
                selected: currentTab == RiderNavTab.trips,
                onTap: () => _go(context, RiderNavTab.trips),
              ),
              _NavItem(
                icon: Icons.local_shipping_outlined,
                label: 'Cargo',
                selected: currentTab == RiderNavTab.cargo,
                onTap: () => _go(context, RiderNavTab.cargo),
              ),
              _NavItem(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Wallet',
                selected: currentTab == RiderNavTab.wallet,
                onTap: () => _go(context, RiderNavTab.wallet),
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                selected: currentTab == RiderNavTab.profile,
                onTap: () => _go(context, RiderNavTab.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _go(BuildContext context, RiderNavTab tab) {
    onTabSelected?.call(tab);
    switch (tab) {
      case RiderNavTab.home:
        context.go(AppRoutes.home);
      case RiderNavTab.trips:
        context.go(AppRoutes.rideHailing);
      case RiderNavTab.cargo:
        context.go(AppRoutes.cargo);
      case RiderNavTab.wallet:
        context.go(AppRoutes.wallet);
      case RiderNavTab.profile:
        context.go(AppRoutes.profile);
    }
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: selected
            ? BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(label, style: AppTypography.caption.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
