import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/services/auth_service.dart';
import '../core/services/firestore_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthService>().currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Trip History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: userId == null
          ? const Center(child: Text('Log in first to see trip history'))
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: context.read<FirestoreService>().watchTripHistory(userId: userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final trips = snapshot.data ?? const [];
                if (trips.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.marginMobile),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.history, size: 48, color: AppColors.outline),
                          const SizedBox(height: 16),
                          Text('No trips yet', style: AppTypography.labelMd),
                          const SizedBox(height: 8),
                          Text(
                            'Your completed trips will appear here once they are recorded in Firestore.',
                            textAlign: TextAlign.center,
                            style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    return Container(
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
                                Text('${trip['title'] ?? 'Trip'}', style: AppTypography.labelMd),
                                const SizedBox(height: 4),
                                Text('${trip['subtitle'] ?? trip['destination'] ?? ''}', style: AppTypography.caption),
                              ],
                            ),
                          ),
                          Text(
                            '${trip['fare'] != null ? 'TSh ${trip['fare']}' : (trip['status'] ?? 'Active')}',
                            style: AppTypography.labelMd.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemCount: trips.length,
                );
              },
            ),
    );
  }
}
