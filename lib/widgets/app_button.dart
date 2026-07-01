import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.enabled = true,
    this.fullWidth = true,
    this.height = 56,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool enabled;
  final bool fullWidth;
  final double height;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = enabled ? onPressed : null;

    Color bg;
    Color fg;
    Border? border;

    switch (variant) {
      case AppButtonVariant.primary:
        bg = AppColors.primary;
        fg = AppColors.onPrimary;
        border = null;
      case AppButtonVariant.secondary:
        bg = AppColors.surfaceContainerLowest;
        fg = AppColors.primary;
        border = Border.all(color: AppColors.outlineVariant);
      case AppButtonVariant.ghost:
        bg = Colors.transparent;
        fg = AppColors.primary;
        border = Border.all(color: AppColors.outline);
    }

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: Material(
        color: enabled ? bg : bg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: effectiveOnPressed == null
              ? null
              : () {
                  HapticFeedback.lightImpact();
                  effectiveOnPressed();
                },
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: border,
              boxShadow: variant == AppButtonVariant.primary
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTypography.labelMd.copyWith(color: fg),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(icon, color: fg, size: 20),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
