import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Trip History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              const CircleAvatar(child: Icon(Icons.history)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ride ${index + 1}', style: AppTypography.labelMd),
                    const SizedBox(height: 4),
                    Text('Ubungo to Posta Mpya', style: AppTypography.caption),
                  ],
                ),
              ),
              Text('TSh 4,200', style: AppTypography.labelMd.copyWith(color: AppColors.primary)),
            ],
          ),
        ),
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemCount: 6,
      ),
    );
  }
}
