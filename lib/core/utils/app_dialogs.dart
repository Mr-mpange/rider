import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

abstract final class AppDialogs {
  static void showInfoSheet(
    BuildContext context, {
    required String title,
    required String body,
    String cta = 'Close',
    VoidCallback? onCta,
  }) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.headlineMdMobile.copyWith(fontSize: 20)),
            const SizedBox(height: 8),
            Text(body, style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onCta?.call();
                },
                child: Text(cta),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showContactDriverSheet(BuildContext context) {
    showInfoSheet(
      context,
      title: 'Contact Driver',
      body: 'Messaging and voice calls connect through your registered phone number.',
      cta: 'Got it',
    );
  }

  static void showSearchSheet(BuildContext context, {String hint = 'Search shipments, routes, or ports'}) {
    final controller = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.marginMobile,
          0,
          AppSpacing.marginMobile,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.marginMobile,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Search', style: AppTypography.headlineMdMobile.copyWith(fontSize: 20)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(hintText: hint),
              onSubmitted: (value) {
                Navigator.pop(context);
                if (value.trim().isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Searching for "${value.trim()}"')),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final query = controller.text.trim();
                  Navigator.pop(context);
                  if (query.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Searching for "$query"')),
                    );
                  }
                },
                child: const Text('Search'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
