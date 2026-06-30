import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Payment Methods'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          _MethodTile(
            title: 'Mobile Money',
            subtitle: 'Add your preferred mobile wallet',
            icon: Icons.phone_android,
            action: 'Add',
          ),
          const SizedBox(height: 12),
          _MethodTile(
            title: 'Bank Card',
            subtitle: 'Use a debit or credit card',
            icon: Icons.credit_card,
            action: 'Link',
          ),
          const SizedBox(height: 12),
          _MethodTile(
            title: 'Rider Wallet',
            subtitle: 'Fund trips from your wallet balance',
            icon: Icons.account_balance_wallet,
            action: 'View',
          ),
        ],
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.action,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelMd),
                Text(subtitle, style: AppTypography.caption),
              ],
            ),
          ),
          Text(action, style: AppTypography.labelMd.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}
