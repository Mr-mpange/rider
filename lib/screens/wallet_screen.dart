import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/app_dialogs.dart';
import '../widgets/glass_card.dart';
import '../widgets/rider_bottom_nav_bar.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _showBalance = true;
  int _analysisRange = 0;

  final _transactions = const [
    _Txn(icon: Icons.local_shipping_outlined, title: 'Freight: Zone B to Hub', subtitle: 'Today, 10:24 AM • Logistics', amount: 'Pending', pending: true),
    _Txn(icon: Icons.account_balance, title: 'Wallet Top Up', subtitle: 'Yesterday, 4:15 PM • Bank Transfer', amount: 'Completed'),
    _Txn(icon: Icons.ac_unit, title: 'Cold Cargo Service', subtitle: '22 Oct 2023 • Maintenance', amount: 'Completed'),
    _Txn(icon: Icons.directions_bus, title: 'Staff Shuttle Monthly', subtitle: '21 Oct 2023 • Operations', amount: 'Completed'),
    _Txn(icon: Icons.person_outline, title: 'P2P Transfer from Sarah K.', subtitle: '18 Oct 2023 • Wallet', amount: 'Completed'),
  ];

  void _openAction(String action) {
    switch (action) {
      case 'topup':
        _showSheet(title: 'Top Up Wallet', body: 'Choose a payment source and load funds instantly.', cta: 'Proceed to Top Up');
      case 'withdraw':
        _showSheet(title: 'Withdraw', body: 'Move funds from your RIIDER wallet to your linked bank account.', cta: 'Proceed to Withdraw');
      case 'send':
        _showSheet(title: 'Send Money', body: 'Transfer funds to another RIIDER wallet or mobile money account.', cta: 'Proceed to Send');
    }
  }

  void _showSheet({required String title, required String body, required String cta}) {
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
              child: ElevatedButton(onPressed: () => Navigator.pop(context), child: Text(cta)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final balanceText = _showBalance ? 'TSh 142,580.00' : 'TSh ••••••';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 16, AppSpacing.marginMobile, 118),
          children: [
            RiiderHeader(onMenu: () => context.pop()),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.walletGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withValues(alpha: 0.12), blurRadius: 30, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('AVAILABLE BALANCE', style: AppTypography.caption.copyWith(color: Colors.white70, letterSpacing: 2)),
                      const Spacer(),
                      IconButton(
                        onPressed: () => setState(() => _showBalance = !_showBalance),
                        icon: Icon(_showBalance ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white),
                      ),
                    ],
                  ),
                  Text(balanceText, style: AppTypography.displayLg.copyWith(color: Colors.white, fontSize: 36)),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
                    child: Text('RIIDER PAY', style: AppTypography.labelMd.copyWith(color: Colors.white)),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: _WalletAction(icon: Icons.add, label: 'Top Up', filled: true, onTap: () => _openAction('topup'))),
                      const SizedBox(width: 10),
                      Expanded(child: _WalletAction(icon: Icons.payments_outlined, label: 'Withdraw', onTap: () => _openAction('withdraw'))),
                      const SizedBox(width: 10),
                      Expanded(child: _WalletAction(icon: Icons.send, label: 'Send', onTap: () => _openAction('send'))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Spending Analysis', style: AppTypography.labelMd.copyWith(letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _RangeChip(label: 'Last 6 Months', selected: _analysisRange == 0, onTap: () => setState(() => _analysisRange = 0)),
                      const SizedBox(width: 8),
                      _RangeChip(label: 'Last 30 Days', selected: _analysisRange == 1, onTap: () => setState(() => _analysisRange = 1)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(height: 160, child: CustomPaint(painter: _ChartPainter())),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _LegendDot(color: AppColors.primary, label: 'Earnings'),
                      const SizedBox(width: 16),
                      _LegendDot(color: AppColors.secondaryContainer, label: 'Logistics Spend'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Text('Transaction History', style: AppTypography.labelMd.copyWith(letterSpacing: 1)),
                const Spacer(),
                IconButton(
                  onPressed: () => AppDialogs.showSearchSheet(context, hint: 'Search transactions'),
                  icon: const Icon(Icons.search, color: AppColors.primary),
                ),
                IconButton(
                  onPressed: () => AppDialogs.showInfoSheet(context, title: 'Filter', body: 'Filter by date, type, or status.', cta: 'Apply'),
                  icon: const Icon(Icons.tune, color: AppColors.primary),
                ),
              ],
            ),
            ..._transactions.map((t) => _TxnTile(txn: t)),
          ],
        ),
      ),
      bottomNavigationBar: const RiderBottomNavBar(currentTab: RiderNavTab.wallet),
    );
  }
}

class _WalletAction extends StatelessWidget {
  const _WalletAction({required this.icon, required this.label, required this.onTap, this.filled = false});
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

class _RangeChip extends StatelessWidget {
  const _RangeChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(label, style: AppTypography.caption.copyWith(color: selected ? Colors.white : AppColors.onSurface)),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}

class _Txn {
  const _Txn({required this.icon, required this.title, required this.subtitle, required this.amount, this.pending = false});
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final bool pending;
}

class _TxnTile extends StatelessWidget {
  const _TxnTile({required this.txn});
  final _Txn txn;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.surfaceContainerLow,
            child: Icon(txn.icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(txn.title, style: AppTypography.labelMd),
                Text(txn.subtitle, style: AppTypography.caption),
              ],
            ),
          ),
          Text(
            txn.amount,
            style: AppTypography.caption.copyWith(
              color: txn.pending ? AppColors.secondaryContainer : AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final axis = Paint()..color = AppColors.outlineVariant.withValues(alpha: 0.3)..strokeWidth = 1;
    final earnings = Paint()..color = AppColors.primary..strokeWidth = 3..style = PaintingStyle.stroke;
    final spend = Paint()..color = AppColors.secondaryContainer..strokeWidth = 3..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), axis);

    final ePath = Path()
      ..moveTo(0, size.height * 0.7)
      ..lineTo(size.width * 0.2, size.height * 0.55)
      ..lineTo(size.width * 0.4, size.height * 0.62)
      ..lineTo(size.width * 0.6, size.height * 0.4)
      ..lineTo(size.width * 0.8, size.height * 0.48)
      ..lineTo(size.width, size.height * 0.25);
    canvas.drawPath(ePath, earnings);

    final sPath = Path()
      ..moveTo(0, size.height * 0.82)
      ..lineTo(size.width * 0.2, size.height * 0.75)
      ..lineTo(size.width * 0.4, size.height * 0.78)
      ..lineTo(size.width * 0.6, size.height * 0.65)
      ..lineTo(size.width * 0.8, size.height * 0.7)
      ..lineTo(size.width, size.height * 0.58);
    canvas.drawPath(sPath, spend);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
