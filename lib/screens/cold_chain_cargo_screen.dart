import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/live_tracking_card.dart';

class ColdChainCargoScreen extends StatelessWidget {
  const ColdChainCargoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cold Chain Cargo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          const LiveTrackingCard(
            title: 'Cold truck CLD-118',
            subtitle: 'Temperature-controlled route in progress',
            distance: '84 km',
            eta: '3h 24m',
            status: 'SECURE',
            progress: 0.76,
            primaryActionLabel: 'Alert Driver',
            secondaryActionLabel: 'Temperature Log',
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Temperature Control',
            child: Row(
              children: const [
                Expanded(child: _Metric(label: 'Target', value: '2°C')),
                SizedBox(width: 10),
                Expanded(child: _Metric(label: 'Current', value: '2.4°C')),
                SizedBox(width: 10),
                Expanded(child: _Metric(label: 'Humidity', value: '44%')),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SectionCard(
            title: 'Live Actions',
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Alert Driver'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Temperature Log'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.labelMd),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(label, style: AppTypography.caption),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.labelMd),
        ],
      ),
    );
  }
}
