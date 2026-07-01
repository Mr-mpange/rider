import 'package:flutter/material.dart';
import '../core/constants/app_branding.dart';
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
import '../widgets/glass_card.dart';

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
        const SnackBar(content: Text('Choose a report type')),
      );
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Describe the issue')),
      );
      return;
    }

    final userId = context.read<AuthService>().currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first')),
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
          const SnackBar(content: Text('Report sent. Thank you!')),
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
              AppBranding.appName,
              style: AppTypography.textTheme.displayLarge?.copyWith(
                fontSize: 24,
                color: AppColors.primary,
              ),
            ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.help_outline, color: AppColors.primary),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report guidance is available in the support center.')),
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
                  Text('Reports & Feedback', style: AppTypography.headlineMdMobile),
                  const SizedBox(height: 8),
                  Text(
                    'Help us improve the service by reporting issues.',
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: context.read<FirestoreService>().watchReports(limit: 5),
                    builder: (context, snapshot) {
                      final reports = snapshot.data ?? const [];
                      return GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.inbox_outlined, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Live reports', style: AppTypography.labelMd),
                                  Text(
                                    '${reports.length} recent issue${reports.length == 1 ? '' : 's'} synced to Firestore.',
                                    style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'SELECT REPORT TYPE',
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
                      hintText: 'Briefly describe the issue you experienced...',
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
                    label: 'Submit Report',
                    onPressed: _submitting ? null : _submit,
                    enabled: !_submitting,
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: context.read<FirestoreService>().watchReports(limit: 3),
                    builder: (context, snapshot) {
                      final reports = snapshot.data ?? const [];
                      if (reports.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Recent submissions', style: AppTypography.labelMd),
                          const SizedBox(height: 10),
                          ...reports.map(
                            (report) => Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${report['type'] ?? 'Report'}', style: AppTypography.labelMd),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${report['description'] ?? ''}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
