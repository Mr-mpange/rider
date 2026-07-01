import 'package:flutter/material.dart';
import '../core/constants/app_branding.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

enum AppNavTab { home, saved, reports, profile }

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  final AppNavTab currentTab;
  final ValueChanged<AppNavTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: _NavItem(
                icon: Icons.home,
                label: 'Nyumbani',
                selected: currentTab == AppNavTab.home,
                filled: currentTab == AppNavTab.home,
                onTap: () => onTabSelected(AppNavTab.home),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: Icons.bookmark,
                label: 'Iliyohifadhiwa',
                selected: currentTab == AppNavTab.saved,
                filled: currentTab == AppNavTab.saved,
                onTap: () => onTabSelected(AppNavTab.saved),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: Icons.report_outlined,
                label: 'Ripoti',
                selected: currentTab == AppNavTab.reports,
                onTap: () => onTabSelected(AppNavTab.reports),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: Icons.person_outline,
                label: 'Wasifu',
                selected: currentTab == AppNavTab.profile,
                onTap: () => onTabSelected(AppNavTab.profile),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = selected;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: active && filled
            ? const EdgeInsets.symmetric(horizontal: 18, vertical: 2)
            : EdgeInsets.zero,
        decoration: active && filled
            ? BoxDecoration(
                color: AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(999),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: active && filled
                  ? AppColors.onSecondaryContainer
                  : AppColors.onSurfaceVariant,
              size: 22,
            ),
            const SizedBox(height: 1),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTypography.textTheme.labelSmall?.copyWith(
                    height: 1.0,
                    color: active && filled
                        ? AppColors.onSecondaryContainer
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    this.showMenu = true,
    this.showSearch = false,
    this.onMenuTap,
    this.onSearchTap,
    this.onBackTap,
    this.trailing,
    this.titleSize = 32,
  });

  final bool showMenu;
  final bool showSearch;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onBackTap;
  final Widget? trailing;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (onBackTap != null)
            IconButton(
              onPressed: onBackTap,
              icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
            )
          else if (showMenu)
            IconButton(
              onPressed: onMenuTap,
              icon: const Icon(Icons.menu, color: AppColors.primary),
            ),
          Expanded(
            child: Text(
              AppBranding.appName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.textTheme.displayLarge?.copyWith(
                fontSize: titleSize,
                color: AppColors.primary,
                letterSpacing: -0.5,
              ),
            ),
          ),
          trailing ?? const SizedBox.shrink(),
          if (showSearch)
            IconButton(
              onPressed: onSearchTap,
              icon: const Icon(Icons.search, color: AppColors.primary),
            ),
        ],
      ),
    );
  }
}
