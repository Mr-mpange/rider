import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

class SecurityPrivacyScreen extends StatefulWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  State<SecurityPrivacyScreen> createState() => _SecurityPrivacyScreenState();
}

class _SecurityPrivacyScreenState extends State<SecurityPrivacyScreen> {
  bool biometric = true;
  bool tripVisibility = true;
  bool marketing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Security & Privacy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          SwitchListTile(
            value: biometric,
            onChanged: (v) => setState(() => biometric = v),
            title: const Text('Biometric unlock'),
            subtitle: const Text('Use Face ID or Touch ID to open the app'),
          ),
          SwitchListTile(
            value: tripVisibility,
            onChanged: (v) => setState(() => tripVisibility = v),
            title: const Text('Trip visibility'),
            subtitle: const Text('Let drivers and support see trip details'),
          ),
          SwitchListTile(
            value: marketing,
            onChanged: (v) => setState(() => marketing = v),
            title: const Text('Marketing messages'),
            subtitle: const Text('Receive product and promotion updates'),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
            ),
            child: Text(
              'These settings are stored locally for now. Backend persistence can be added later.',
              style: AppTypography.bodyMd,
            ),
          ),
        ],
      ),
    );
  }
}
