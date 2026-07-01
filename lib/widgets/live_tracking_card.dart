import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import 'glass_card.dart';

class LiveTrackingCard extends StatelessWidget {
  const LiveTrackingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.distance,
    required this.eta,
    required this.status,
    this.progress = 0.72,
    this.primaryActionLabel,
    this.secondaryActionLabel,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.onTap,
    this.isExpanded = false,
    this.targets = const [],
    this.activeTarget,
    this.onTargetSelected,
  });

  final String title;
  final String subtitle;
  final String distance;
  final String eta;
  final String status;
  final double progress;
  final String? primaryActionLabel;
  final String? secondaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final VoidCallback? onTap;
  final bool isExpanded;
  final List<String> targets;
  final String? activeTarget;
  final ValueChanged<String>? onTargetSelected;

  @override
  Widget build(BuildContext context) {
    final card = GlassCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.route, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.labelMd),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTypography.caption),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  status,
                  style: AppTypography.caption.copyWith(color: AppColors.onSecondaryContainer),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.18),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _Metric(label: 'Distance', value: distance)),
              const SizedBox(width: 12),
              Expanded(child: _Metric(label: 'ETA', value: eta)),
              const SizedBox(width: 12),
              Expanded(child: _Metric(label: 'Status', value: 'Live')),
            ],
          ),
          if (targets.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: targets.map((target) {
                final selected = target == activeTarget;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  child: InkWell(
                    onTap: onTargetSelected == null ? null : () => onTargetSelected!(target),
                    borderRadius: BorderRadius.circular(999),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: selected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text(
                            target,
                            style: AppTypography.caption.copyWith(
                              color: selected ? Colors.white : AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tracking focus',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          activeTarget == null
                              ? 'Tap a target above to narrow tracking.'
                              : 'Following $activeTarget in real time with route updates.',
                          style: AppTypography.bodyMd.copyWith(fontSize: 14, color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          if (primaryActionLabel != null || secondaryActionLabel != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                if (secondaryActionLabel != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onSecondaryAction,
                      child: Text(secondaryActionLabel!),
                    ),
                  ),
                if (secondaryActionLabel != null && primaryActionLabel != null)
                  const SizedBox(width: 12),
                if (primaryActionLabel != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPrimaryAction,
                      child: Text(primaryActionLabel!),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: card,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.labelMd.copyWith(fontSize: 14)),
      ],
    );
  }
}
