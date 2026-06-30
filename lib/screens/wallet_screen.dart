import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/rider_bottom_nav_bar.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile, vertical: 8),
              child: Row(
                children: [
                  Text('RIDER', style: AppTypography.labelMd.copyWith(color: AppColors.primary)),
                  const Spacer(),
                  const Icon(Icons.notifications_outlined, color: AppColors.primary),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 8, AppSpacing.marginMobile, 110),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MAIN WALLET BALANCE', style: AppTypography.caption.copyWith(color: Colors.white70, letterSpacing: 2)),
                        const SizedBox(height: 8),
                        Text.rich(
                          TextSpan(
                            style: AppTypography.displayLg.copyWith(color: Colors.white, fontSize: 38),
                            children: const [
                              TextSpan(text: '₦'),
                              TextSpan(text: '142,580'),
                              TextSpan(text: '.00', style: TextStyle(fontSize: 22, color: Colors.white70)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
                          child: Text('+12.4%', style: AppTypography.labelMd.copyWith(color: Colors.white)),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(child: _WalletAction(icon: Icons.add, label: 'Top Up', filled: true)),
                            const SizedBox(width: 10),
                            Expanded(child: _WalletAction(icon: Icons.send, label: 'Send')),
                            const SizedBox(width: 10),
                            Expanded(child: _WalletAction(icon: Icons.credit_card, label: 'Details')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rider Platinum', style: AppTypography.headlineMdMobile.copyWith(fontSize: 18)),
                        const SizedBox(height: 14),
                        Text('•••• •••• •••• 8842', style: AppTypography.headlineMdMobile.copyWith(fontSize: 24, letterSpacing: 3)),
                        const SizedBox(height: 14),
                        Text('CARD HOLDER', style: AppTypography.caption),
                        const SizedBox(height: 2),
                        Text('KWAME MENSAH', style: AppTypography.labelMd),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Spending Analytics', style: AppTypography.labelMd),
                        const SizedBox(height: 18),
                        SizedBox(
                          height: 120,
                          child: CustomPaint(painter: _ChartPainter()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const RiderBottomNavBar(currentTab: RiderNavTab.wallet),
    );
  }
}

class _WalletAction extends StatelessWidget {
  const _WalletAction({required this.icon, required this.label, this.filled = false});
  final IconData icon;
  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: filled ? Colors.white : Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: filled ? AppColors.primary : Colors.white, size: 18),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.caption.copyWith(color: filled ? AppColors.primary : Colors.white)),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.35, size.width * 0.4, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.25, size.width, size.height * 0.18);
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
