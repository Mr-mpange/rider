import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_branding.dart';
import '../core/constants/image_urls.dart';
import '../core/router/app_router.dart';
import '../core/services/auth_service.dart';
import '../core/models/user_profile.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/app_dialogs.dart';
import '../widgets/glass_card.dart';
import '../widgets/rider_bottom_nav_bar.dart';
import '../widgets/settings_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final profile = auth.currentUser;
    final tripsCompleted = profile?.tripCount ?? 0;
    final ratingBadge = tripsCompleted >= 25 ? 'Top Rated' : tripsCompleted >= 10 ? 'Rising Star' : 'New Rider';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 16, AppSpacing.marginMobile, 118),
          children: [
            RiiderHeader(onMenu: () => context.push(AppRoutes.admin)),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: ImageUrls.profileAvatar,
                      width: 68,
                      height: 68,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 68,
                        height: 68,
                        color: AppColors.surfaceContainerLow,
                        child: const Icon(Icons.person, size: 32, color: AppColors.primary),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 68,
                        height: 68,
                        color: AppColors.surfaceContainerLow,
                        child: const Icon(Icons.person, size: 32, color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile?.displayName ?? 'Rider User', style: AppTypography.headlineMdMobile.copyWith(fontSize: 18)),
                        Text(
                          profile?.email.isNotEmpty == true ? profile!.email : 'Enterprise Logistics Admin',
                          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _Badge(
                              label: profile?.isVerified == true ? 'Verified' : 'Unverified',
                              color: profile?.isVerified == true ? AppColors.secondary : AppColors.outline,
                              icon: profile?.isVerified == true ? Icons.verified : Icons.info_outline,
                            ),
                            _Badge(label: ratingBadge, color: AppColors.primary),
                            _Badge(label: '$tripsCompleted trips', color: AppColors.secondaryContainer),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SectionHeader('Account & Compliance'),
            SettingsTile(
              icon: Icons.person_outline,
              title: 'Personal Info',
              subtitle: 'Contact details and identity',
              onTap: () => context.push(AppRoutes.securityPrivacy),
            ),
            SettingsTile(
              icon: Icons.description_outlined,
              title: 'Documents',
              subtitle: 'Licenses, Insurance, Permits',
              badge: '1 Expiring',
              onTap: () => AppDialogs.showInfoSheet(
                context,
                title: 'Documents',
                body: 'Review licenses, insurance, and permit documents.',
                cta: 'Open Documents',
              ),
            ),
            const SectionHeader('App Preferences'),
            SettingsTile(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'English (US)',
              onTap: () => context.push(AppRoutes.language),
            ),
            SettingsTile(
              icon: Icons.dark_mode_outlined,
              title: 'Theme',
              subtitle: 'Switch between Light and Dark mode',
              onTap: () => AppDialogs.showInfoSheet(
                context,
                title: 'Theme',
                body: 'RIIDER currently follows the approved light enterprise theme.',
                cta: 'Close',
              ),
            ),
            SettingsTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Alerts, updates, and messages',
              onTap: () => AppDialogs.showInfoSheet(
                context,
                title: 'Notifications',
                body: 'Manage trip, wallet, and logistics notification preferences.',
                cta: 'Open Settings',
              ),
            ),
            const SectionHeader('Privacy & Security'),
            SettingsTile(
              icon: Icons.security,
              title: 'Security',
              subtitle: 'Passwords, 2FA, Biometrics',
              onTap: () => context.push(AppRoutes.securityPrivacy),
            ),
            const SectionHeader('Payments'),
            GlassCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_outlined, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text('RIIDER Wallet', style: AppTypography.labelMd),
                      const Spacer(),
                      TextButton(onPressed: () => context.go(AppRoutes.wallet), child: const Text('Details')),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Current Balance', style: AppTypography.caption),
                  const SizedBox(height: 4),
                  StreamBuilder<UserProfile?>(
                    stream: auth.watchUserProfile(),
                    builder: (context, snapshot) {
                      final balance = snapshot.data?.balanceTzs ?? profile?.balanceTzs ?? 0;
                      return Text('TSh ${balance.toStringAsFixed(2)}', style: AppTypography.headlineMdMobile.copyWith(fontSize: 22));
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.go(AppRoutes.wallet),
                          child: const Text('Withdraw'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SettingsTile(
              icon: Icons.credit_card,
              title: 'Linked cards',
              subtitle: 'Manage wallet funding sources',
              onTap: () => context.push(AppRoutes.paymentMethods),
            ),
            SettingsTile(
              icon: Icons.payments_outlined,
              title: 'Payment profile',
              subtitle: profile?.phoneNumber.isNotEmpty == true ? profile!.phoneNumber : 'Add email for payouts',
              onTap: () => context.push(AppRoutes.paymentMethods),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await context.read<AuthService>().signOut();
                  if (context.mounted) context.go(AppRoutes.login);
                },
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: Text('Logout', style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
              ),
            ),
            const SizedBox(height: 12),
            Center(child: Text('${AppBranding.appName} v4.12.0', style: AppTypography.caption)),
          ],
        ),
      ),
      bottomNavigationBar: const RiderBottomNavBar(currentTab: RiderNavTab.profile),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color, this.icon});
  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 12, color: color), const SizedBox(width: 4)],
          Text(label, style: AppTypography.caption.copyWith(color: color)),
        ],
      ),
    );
  }
}
