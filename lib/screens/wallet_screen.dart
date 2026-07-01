import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/services/auth_service.dart';
import '../core/services/firestore_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/app_dialogs.dart';
import '../widgets/glass_card.dart';
import '../widgets/rider_bottom_nav_bar.dart';

enum _ChartMode { week, month }

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _showBalance = true;
  _ChartMode _chartMode = _ChartMode.month;

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
    final auth = context.watch<AuthService>();
    final profile = auth.currentUser;
    final balanceText = _showBalance ? 'TSh ${((profile?.balanceTzs ?? 0)).toStringAsFixed(2)}' : 'TSh ••••••';

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
                      _RangeChip(label: 'This Week', selected: _chartMode == _ChartMode.week, onTap: () => setState(() => _chartMode = _ChartMode.week)),
                      const SizedBox(width: 8),
                      _RangeChip(label: 'This Month', selected: _chartMode == _ChartMode.month, onTap: () => setState(() => _chartMode = _ChartMode.month)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: context.read<FirestoreService>().watchWalletTransactions(userId: profile?.uid, limit: 12),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return _StateCard(
                          icon: Icons.error_outline,
                          title: 'Unable to load wallet chart',
                          body: 'Check your connection and try again.',
                        );
                      }
                      final transactions = snapshot.data ?? const [];
                      final series = _chartSeries(transactions, _chartMode);
                      return Column(
                        children: [
                          SizedBox(
                            height: 160,
                            child: CustomPaint(painter: _ChartPainter.fromSeries(series)),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _LegendDot(color: AppColors.primary, label: 'Credits'),
                              const SizedBox(width: 16),
                              _LegendDot(color: AppColors.secondaryContainer, label: 'Debits'),
                            ],
                          ),
                        ],
                      );
                    },
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
            if (profile != null) ...[
              GlassCard(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const Icon(Icons.person_outline, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profile.displayName, style: AppTypography.labelMd),
                          Text(profile.email, style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: context.read<FirestoreService>().watchWalletTransactions(userId: profile?.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: _StateCard(
                      icon: Icons.error_outline,
                      title: 'Transactions unavailable',
                      body: 'Firestore returned an error while loading your wallet history.',
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final transactions = snapshot.data ?? const [];
                if (transactions.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('No wallet activity yet')),
                  );
                }
                return Column(
                  children: transactions.map((t) => _TxnTile(txn: t)).toList(),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const RiderBottomNavBar(currentTab: RiderNavTab.wallet),
    );
  }

  List<_ChartPoint> _chartSeries(List<Map<String, dynamic>> transactions, _ChartMode mode) {
    final now = DateTime.now();
    final buckets = mode == _ChartMode.week ? 7 : 6;
    final labels = <String>[];
    final credits = List<double>.filled(buckets, 0);
    final debits = List<double>.filled(buckets, 0);

    for (var i = buckets - 1; i >= 0; i--) {
      final day = now.subtract(Duration(days: mode == _ChartMode.week ? i : i * 7));
      labels.add(mode == _ChartMode.week ? _weekdayShort(day.weekday) : _monthShort(day));
    }

    for (final txn in transactions) {
      final createdAt = txn['createdAt'];
      DateTime? date;
      if (createdAt is DateTime) {
        date = createdAt;
      } else if (createdAt is Timestamp) {
        date = createdAt.toDate();
      }
      if (date == null) continue;

      final amount = (txn['amount'] as num?)?.toDouble() ?? 0;
      final bucket = mode == _ChartMode.week
          ? now.difference(DateTime(date.year, date.month, date.day)).inDays
          : (now.year - date.year) * 12 + now.month - date.month;
      if (bucket < 0 || bucket >= buckets) continue;
      final index = buckets - bucket - 1;
      if (amount >= 0) {
        credits[index] += amount;
      } else {
        debits[index] += amount.abs();
      }
    }

    return [
      for (var i = 0; i < buckets; i++) _ChartPoint(label: labels[i], credit: credits[i], debit: debits[i]),
    ];
  }

  String _weekdayShort(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[(weekday - 1).clamp(0, 6)];
  }

  String _monthShort(DateTime date) {
    const names = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return names[date.month - 1];
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

class _StateCard extends StatelessWidget {
  const _StateCard({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelMd),
                const SizedBox(height: 4),
                Text(body, style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TxnTile extends StatelessWidget {
  const _TxnTile({required this.txn});
  final Map<String, dynamic> txn;

  @override
  Widget build(BuildContext context) {
    final amount = (txn['amount'] as num?)?.toDouble() ?? 0;
    final pending = (txn['status'] as String? ?? '').toLowerCase() == 'pending';
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
            child: Icon(pending ? Icons.hourglass_top : Icons.receipt_long, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${txn['title'] ?? 'Transaction'}', style: AppTypography.labelMd),
                Text('${txn['subtitle'] ?? ''}', style: AppTypography.caption),
              ],
            ),
          ),
          Text(
            '${amount < 0 ? '-' : '+'}TSh ${amount.abs().toStringAsFixed(0)}',
            style: AppTypography.caption.copyWith(
              color: pending ? AppColors.secondaryContainer : AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter._(this._points);

  factory _ChartPainter.fromSeries(List<_ChartPoint> points) {
    return _ChartPainter._(points);
  }

  final List<_ChartPoint> _points;

  @override
  void paint(Canvas canvas, Size size) {
    final axis = Paint()..color = AppColors.outlineVariant.withValues(alpha: 0.3)..strokeWidth = 1;
    final credits = Paint()..color = AppColors.primary..strokeWidth = 3.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final debits = Paint()..color = AppColors.secondaryContainer..strokeWidth = 3.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final creditsFill = Paint()..shader = LinearGradient(
      colors: [AppColors.primary.withValues(alpha: 0.28), AppColors.primary.withValues(alpha: 0.02)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final debitsFill = Paint()..shader = LinearGradient(
      colors: [AppColors.secondaryContainer.withValues(alpha: 0.20), AppColors.secondaryContainer.withValues(alpha: 0.01)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), axis);

    if (_points.isEmpty) return;

    Path buildPath(List<double> values, double maxValue) {
      final path = Path();
      for (var i = 0; i < values.length; i++) {
        final x = values.length == 1 ? size.width / 2 : (size.width / (values.length - 1)) * i;
        final normalized = maxValue == 0 ? 0 : values[i] / maxValue;
        final y = size.height - (size.height * 0.75 * normalized) - 16;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      return path;
    }

    Path fillPath(List<double> values, double maxValue) {
      final path = buildPath(values, maxValue);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      return path;
    }

    final creditValues = _points.map((p) => p.credit).toList();
    final debitValues = _points.map((p) => p.debit).toList();
    final maxValue = [...creditValues, ...debitValues].fold<double>(1, (max, value) => value > max ? value : max);
    canvas.drawPath(fillPath(creditValues, maxValue), creditsFill);
    canvas.drawPath(fillPath(debitValues, maxValue), debitsFill);
    canvas.drawPath(buildPath(creditValues, maxValue), credits);
    canvas.drawPath(buildPath(debitValues, maxValue), debits);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ChartPoint {
  const _ChartPoint({required this.label, required this.credit, required this.debit});
  final String label;
  final double credit;
  final double debit;
}
