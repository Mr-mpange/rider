import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/rider_bottom_nav_bar.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _pageController = PageController(initialPage: 0);
  int _page = 0;
  bool _showBalance = true;

  final _cards = const [
    _WalletCardData(
      title: 'Main Wallet Balance',
      balance: 'TSh 142,580.00',
      rate: '+12.4%',
      accent: AppColors.primary,
    ),
    _WalletCardData(
      title: 'Savings Wallet',
      balance: 'TSh 38,200.00',
      rate: '+4.1%',
      accent: AppColors.secondary,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openAction(String action) {
    switch (action) {
      case 'topup':
        _showSheet(
          title: 'Top Up Wallet',
          body: 'Choose a payment source and load funds instantly.',
          cta: 'Proceed to Top Up',
        );
      case 'send':
        _showSheet(
          title: 'Send Money',
          body: 'Transfer funds to another Rider wallet or mobile money account.',
          cta: 'Proceed to Send',
        );
      case 'details':
        _showSheet(
          title: 'Wallet Details',
          body: 'View linked cards, limits, and transaction history.',
          cta: 'Open Details',
        );
    }
  }

  void _showSheet({
    required String title,
    required String body,
    required String cta,
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
            Text(body, style: AppTypography.bodyMd),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(cta),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final card = _cards[_page];
    final balanceText = _showBalance ? card.balance : 'TSh ••••••';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 8, AppSpacing.marginMobile, 110),
          children: [
            Row(
              children: [
                Text('RIDER', style: AppTypography.labelMd.copyWith(color: AppColors.primary)),
                const Spacer(),
                const Icon(Icons.notifications_outlined, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: card.accent,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(card.title.toUpperCase(), style: AppTypography.caption.copyWith(color: Colors.white70, letterSpacing: 2)),
                      const Spacer(),
                      IconButton(
                        onPressed: () => setState(() => _showBalance = !_showBalance),
                        icon: Icon(_showBalance ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white),
                      ),
                    ],
                  ),
                  Text.rich(
                    TextSpan(
                      style: AppTypography.displayLg.copyWith(color: Colors.white, fontSize: 38),
                      children: [
                        TextSpan(text: balanceText),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
                    child: Text(card.rate, style: AppTypography.labelMd.copyWith(color: Colors.white)),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: _WalletAction(icon: Icons.add, label: 'Top Up', filled: true, onTap: () => _openAction('topup'))),
                      const SizedBox(width: 10),
                      Expanded(child: _WalletAction(icon: Icons.send, label: 'Send', onTap: () => _openAction('send'))),
                      const SizedBox(width: 10),
                      Expanded(child: _WalletAction(icon: Icons.credit_card, label: 'Details', onTap: () => _openAction('details'))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 220,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _cards.length,
                onPageChanged: (value) => setState(() => _page = value),
                itemBuilder: (context, index) {
                  final active = index == _page;
                  final item = _cards[index];
                  return AnimatedScale(
                    scale: active ? 1 : 0.94,
                    duration: const Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: active ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.35),
                            width: active ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: AppTypography.headlineMdMobile.copyWith(fontSize: 18)),
                            const Spacer(),
                            Text('•••• •••• •••• 8842', style: AppTypography.headlineMdMobile.copyWith(fontSize: 22, letterSpacing: 3)),
                            const Spacer(),
                            Text('CARD HOLDER', style: AppTypography.caption),
                            const SizedBox(height: 2),
                            Text('KWAME MENSAH', style: AppTypography.labelMd),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_cards.length, (index) {
                final active = index == _page;
                return GestureDetector(
                  onTap: () => _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                );
              }),
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
                  Row(
                    children: [
                      Text('Spending Analytics', style: AppTypography.labelMd),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _showSheet(
                          title: 'Analytics',
                          body: 'Monthly spend, top routes, and wallet movement charts.',
                          cta: 'Open Analytics',
                        ),
                        child: const Text('Open'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 160,
                    child: CustomPaint(painter: _ChartPainter()),
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

class _WalletCardData {
  const _WalletCardData({
    required this.title,
    required this.balance,
    required this.rate,
    required this.accent,
  });

  final String title;
  final String balance;
  final String rate;
  final Color accent;
}

class _WalletAction extends StatelessWidget {
  const _WalletAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
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
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final axis = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.3)
      ..strokeWidth = 1;
    final line = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), axis);
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), axis);

    final path = Path()
      ..moveTo(0, size.height * 0.78)
      ..lineTo(size.width * 0.15, size.height * 0.60)
      ..lineTo(size.width * 0.32, size.height * 0.68)
      ..lineTo(size.width * 0.50, size.height * 0.38)
      ..lineTo(size.width * 0.68, size.height * 0.48)
      ..lineTo(size.width * 0.84, size.height * 0.20)
      ..lineTo(size.width, size.height * 0.30);
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
