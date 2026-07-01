import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/services/auth_service.dart';
import '../core/services/app_preferences.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<AppPreferences>();
    final auth = context.read<AuthService>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Language'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          Text('Choose the app language', style: AppTypography.bodyMd),
          const SizedBox(height: 16),
          _LanguageTile(
            title: 'English',
            selected: prefs.localeCode == 'en',
            onTap: () async {
              await prefs.setLocaleCode('en');
              await auth.updateSettings(localeCode: 'en');
            },
          ),
          const SizedBox(height: 12),
          _LanguageTile(
            title: 'Swahili',
            selected: prefs.localeCode == 'sw',
            onTap: () async {
              await prefs.setLocaleCode('sw');
              await auth.updateSettings(localeCode: 'sw');
            },
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Expanded(child: Text(title, style: AppTypography.labelMd)),
            if (selected) const Icon(Icons.check, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
