import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_branding.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/app_dialogs.dart';
import '../core/utils/navigation_utils.dart';

enum RiderNavTab { home, tracking, wallet, profile }

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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                selected: currentTab == RiderNavTab.home,
                onTap: () => _go(context, RiderNavTab.home),
              ),
              _NavItem(
                icon: Icons.location_on_outlined,
                label: 'Tracking',
                selected: currentTab == RiderNavTab.tracking,
                onTap: () => _go(context, RiderNavTab.tracking),
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
      case RiderNavTab.tracking:
        context.go(AppRoutes.activeTrip);
      case RiderNavTab.wallet:
        context.go(AppRoutes.wallet);
      case RiderNavTab.profile:
        context.go(AppRoutes.profile);
    }
  }
}

class RiiderHeader extends StatelessWidget {
  const RiiderHeader({
    super.key,
    this.onMenu,
    this.onNotifications,
    this.trailing,
    this.showBrand = true,
  });

  final VoidCallback? onMenu;
  final VoidCallback? onNotifications;
  final Widget? trailing;
  final bool showBrand;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onMenu != null)
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.menu, size: 22, color: AppColors.primary),
            onPressed: onMenu ?? () => popOrGoHome(context),
          ),
        if (onMenu != null) const SizedBox(width: 8),
        if (showBrand)
          Text(
            AppBranding.appName,
            style: AppTypography.labelMd.copyWith(color: AppColors.primary, letterSpacing: 2),
          ),
        const Spacer(),
        trailing ?? const SizedBox.shrink(),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.notifications_outlined, color: AppColors.primary, size: 22),
          onPressed: onNotifications ??
              () => AppDialogs.showInfoSheet(
                    context,
                    title: 'Notifications',
                    body: 'Trip updates, wallet alerts, and shipment status appear here.',
                  ),
        ),
      ],
    );
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
    final color = selected ? Colors.white : AppColors.onSurfaceVariant;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.14),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: color,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
