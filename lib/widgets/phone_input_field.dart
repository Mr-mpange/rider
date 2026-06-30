import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class PhoneInputField extends StatefulWidget {
  const PhoneInputField({
    super.key,
    required this.controller,
    this.onChanged,
    this.errorText,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Namba ya Simu',
          style: AppTypography.textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (v) => setState(() => _focused = v),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _focused ? AppColors.primary : AppColors.outlineVariant,
                width: _focused ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: AppColors.primary.withValues(alpha: 0.08),
                        ),
                        child: const Icon(Icons.flag, size: 12, color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '+255',
                        style: AppTypography.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 24, color: AppColors.outlineVariant),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(9),
                    ],
                    onChanged: widget.onChanged,
                    style: AppTypography.textTheme.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: '7XX XXX XXX',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: AppTypography.textTheme.labelSmall?.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}

String? validateTanzaniaPhone(String? value) {
  if (value == null || value.isEmpty) return 'Namba ya simu inahitajika';
  if (value.length != 9) return 'Namba ya simu lazima iwe na tarakimu 9';
  if (!value.startsWith('7') && !value.startsWith('6')) {
    return 'Namba ya simu si sahihi';
  }
  return null;
}
