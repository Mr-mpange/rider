import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/image_urls.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/rider_bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 8, AppSpacing.marginMobile, 110),
          children: [
            Row(
              children: [
                Text('Profile', style: AppTypography.headlineMdMobile),
                const Spacer(),
                IconButton(
                  onPressed: () => context.push(AppRoutes.admin),
                  icon: const Icon(Icons.settings_outlined, color: AppColors.primary),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  CircleAvatar(radius: 34, backgroundImage: CachedNetworkImageProvider(ImageUrls.profileAvatar)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kwame Mensah', style: AppTypography.headlineMdMobile.copyWith(fontSize: 18)),
                        Text('Tier 1 Member', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.secondaryContainer.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
                          child: Text('Verified Rider', style: AppTypography.caption.copyWith(color: AppColors.secondary)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _ProfileTile(icon: Icons.history, title: 'Trip History'),
            _ProfileTile(icon: Icons.payment, title: 'Payment Methods', onTap: () => context.push(AppRoutes.wallet)),
            _ProfileTile(icon: Icons.security, title: 'Security & Privacy', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Security settings are not yet wired.')))),
            _ProfileTile(icon: Icons.help_outline, title: 'Support Center', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Support is available from the admin panel.')))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.go(AppRoutes.home),
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: Text('Back to Home', style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const RiderBottomNavBar(currentTab: RiderNavTab.profile),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.icon, required this.title, this.onTap});
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: AppTypography.bodyMd)),
              const Icon(Icons.chevron_right, color: AppColors.outline),
            ],
          ),
        ),
      ),
    );
  }
}
