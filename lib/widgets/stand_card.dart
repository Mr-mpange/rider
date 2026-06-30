import 'package:flutter/material.dart';

import '../core/models/bus_stop.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class StandCard extends StatelessWidget {
  const StandCard({
    super.key,
    required this.stop,
    required this.onTap,
    this.opacity = 1.0,
  });

  final BusStop stop;
  final VoidCallback onTap;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    Color iconBg;
    Color iconFg;
    IconData icon;

    switch (stop.type.toUpperCase()) {
      case 'BRT':
        iconBg = AppColors.tertiaryContainer;
        iconFg = AppColors.onTertiaryContainer;
        icon = Icons.train;
      case 'POST':
        iconBg = AppColors.surfaceContainerHighest;
        iconFg = AppColors.onSurfaceVariant;
        icon = Icons.location_on;
      default:
        iconBg = AppColors.primaryContainer;
        iconFg = AppColors.onPrimaryContainer;
        icon = Icons.directions_bus;
    }

    return Opacity(
      opacity: opacity,
      child: Material(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconFg, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              stop.name,
                              style: AppTypography.textTheme.labelLarge,
                            ),
                          ),
                          if (stop.type.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: stop.type == 'BRT'
                                    ? AppColors.primaryContainer
                                    : AppColors.secondaryContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                stop.type,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSecondaryContainer,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        '${stop.distanceLabel}, dakika ${stop.etaMinutes}',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
