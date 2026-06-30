import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/router/app_router.dart';
import '../core/services/auth_service.dart';
import '../core/services/firestore_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/app_button.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String? _selectedType;
  final _descriptionController = TextEditingController();
  bool _submitting = false;

  static const _reportTypes = [
    ('wrong_route', 'Njia isiyo sahihi', Icons.alt_route),
    ('missing_stop', 'Stendi haipo hapa', Icons.location_off),
    ('color_changed', 'Rangi ya gari imebadilika', Icons.palette),
  ];

  Future<void> _submit() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chagua aina ya ripoti')),
      );
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Eleza tatizo')),
      );
      return;
    }

    final userId = context.read<AuthService>().currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingia kwanza')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await context.read<FirestoreService>().submitReport(
            userId: userId,
            type: _selectedType!,
            description: _descriptionController.text.trim(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ripoti imetumwa. Asante!')),
        );
        _descriptionController.clear();
        setState(() => _selectedType = null);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: () => context.go(AppRoutes.home),
            ),
            title: Text(
              'RIDER',
              style: AppTypography.textTheme.displayLarge?.copyWith(
                fontSize: 24,
                color: AppColors.primary,
              ),
            ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.help_outline, color: AppColors.primary),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report guidance is shown in the support center.')),
                  ),
                ),
              ],
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ripoti & Maoni', style: AppTypography.headlineMdMobile),
                  const SizedBox(height: 8),
                  Text(
                    'Tusaidie kuboresha huduma kwa kuripoti matatizo.',
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'CHAGUA AINA YA RIPOTI',
                    style: AppTypography.textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._reportTypes.map((type) {
                    final selected = _selectedType == type.$1;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => setState(() => _selectedType = type.$1),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primaryContainer.withValues(alpha: 0.1)
                                : AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.3),
                              width: selected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(type.$3, color: AppColors.primary),
                              const SizedBox(width: 16),
                              Text(type.$2, style: AppTypography.textTheme.labelLarge),
                              const Spacer(),
                              if (selected)
                                const Icon(Icons.check_circle, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  Text('Maelezo', style: AppTypography.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Elezea kwa ufupi tatizo ulilokutana nalo...',
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Camera upload is not wired in this build.')),
                    ),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Ongeza Picha'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.outlineVariant),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: 'Tuma Ripoti',
                    onPressed: _submitting ? null : _submit,
                    enabled: !_submitting,
                  ),
                ],
              ),
            ),
          ),
          AppBottomNavBar(
            currentTab: AppNavTab.reports,
            onTabSelected: (tab) {
              switch (tab) {
                case AppNavTab.home:
                  context.go(AppRoutes.home);
                case AppNavTab.saved:
                  context.go(AppRoutes.savedPlaces);
                case AppNavTab.reports:
                  break;
                case AppNavTab.profile:
                  context.go(AppRoutes.profile);
              }
            },
          ),
        ],
      ),
    );
  }
}
