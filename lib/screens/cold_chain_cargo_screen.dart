import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/app_dialogs.dart';
import '../widgets/glass_card.dart';
import '../widgets/rider_bottom_nav_bar.dart';

class ColdChainCargoScreen extends StatefulWidget {
  const ColdChainCargoScreen({super.key});

  @override
  State<ColdChainCargoScreen> createState() => _ColdChainCargoScreenState();
}

class _ColdChainCargoScreenState extends State<ColdChainCargoScreen> {
  final double _setPoint = 2;
  String _activeZone = 'ZONE B';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 16, AppSpacing.marginMobile, 112),
          children: [
            RiiderHeader(onMenu: () => context.pop(), trailing: _HeaderPill(id: 'CC-4902-X')),
            const SizedBox(height: 14),
            Text('Cold Chain Cargo', style: AppTypography.headlineMdMobile.copyWith(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              'Temperature-controlled logistics and live refrigeration monitoring.',
              style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            _HeroCard(
              setPoint: _setPoint,
              onCenter: () => AppDialogs.showInfoSheet(
                context,
                title: 'Thermostat Control',
                body: 'Cooling set point is locked to maintain the cargo temperature envelope.',
                cta: 'Close',
              ),
              onSave: () => AppDialogs.showInfoSheet(
                context,
                title: 'Saved',
                body: 'Cold cargo preset saved.',
                cta: 'Close',
              ),
            ),
            const SizedBox(height: 14),
            GlassCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: 'Cargo Allocation',
                    action: TextButton(
                      onPressed: () => setState(() {
                        _activeZone = _activeZone == 'ZONE B' ? 'ZONE C' : 'ZONE B';
                      }),
                      child: const Text('Switch zone'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _ZoneChip(label: 'ZONE A', selected: _activeZone == 'ZONE A'),
                      _ZoneChip(label: 'ZONE B', selected: _activeZone == 'ZONE B', heavy: true),
                      _ZoneChip(label: 'ZONE C', selected: _activeZone == 'ZONE C'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('REFRIGERATED UNIT 09-A', style: AppTypography.caption),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                _MetricCard(icon: Icons.sensors, label: 'Humi. Sensor', value: '42% RH'),
                _MetricCard(icon: Icons.lock_outline, label: 'Seal Status', value: 'Secured'),
                _MetricCard(icon: Icons.ac_unit, label: 'Critical Temp', value: 'Frozen Store'),
                _MetricCard(icon: Icons.inventory_2_outlined, label: 'Available Space', value: '68%'),
                _MetricCard(icon: Icons.speed, label: 'Airflow Speed', value: '4.2 m/s'),
                _MetricCard(icon: Icons.battery_charging_full, label: 'Cooling Power', value: '88%'),
              ],
            ),
            const SizedBox(height: 14),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.route, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ETA to Destination', style: AppTypography.caption),
                        Text('02:45:10', style: AppTypography.labelMd),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Stability Time', style: AppTypography.caption),
                      Text('14h 22m', style: AppTypography.labelMd),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Live Monitoring', style: AppTypography.labelMd),
                  const SizedBox(height: 10),
                  const _StatusLine(label: 'Compressor', value: 'Cycling normal'),
                  const SizedBox(height: 8),
                  const _StatusLine(label: 'Door Seal', value: 'Locked'),
                  const SizedBox(height: 8),
                  const _StatusLine(label: 'Alert State', value: 'None'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history, color: AppColors.primary),
              title: const Text('System Health Log'),
              subtitle: const Text('Compressor cycling normal • 12:04 PM'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => AppDialogs.showInfoSheet(
                context,
                title: 'System Health Log',
                body: 'Detailed sensor history will appear here once the backend stream is connected.',
                cta: 'Close',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const RiderBottomNavBar(currentTab: RiderNavTab.tracking),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(id, style: AppTypography.caption.copyWith(color: AppColors.primary)),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.setPoint,
    required this.onCenter,
    required this.onSave,
  });

  final double setPoint;
  final VoidCallback onCenter;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Thermostat Control',
            action: IconButton(
              onPressed: onSave,
              icon: const Icon(Icons.save_outlined, color: AppColors.primary),
            ),
          ),
          Text('Precision Dial', style: AppTypography.caption),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              height: 140,
              width: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: (setPoint + 10) / 30,
                    strokeWidth: 10,
                    color: AppColors.primary,
                    backgroundColor: AppColors.surfaceContainer,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.thermostat, color: AppColors.primary),
                      Text('SET POINT', style: AppTypography.caption.copyWith(letterSpacing: 1)),
                      Text('${setPoint.toStringAsFixed(0)}°C', style: AppTypography.headlineMdMobile),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Slider(
            value: setPoint,
            min: -10,
            max: 10,
            divisions: 20,
            label: '${setPoint.toStringAsFixed(0)}°C',
            onChanged: null,
          ),
          Row(
            children: [
              const Icon(Icons.warning_amber_outlined, size: 16, color: AppColors.secondaryContainer),
              const SizedBox(width: 6),
              Expanded(child: Text('Current ambient variation: ±0.4°C', style: AppTypography.caption)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onCenter,
              child: const Text('Thermostat details'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoneChip extends StatelessWidget {
  const _ZoneChip({required this.label, this.heavy = false, this.selected = false});
  final String label;
  final bool heavy;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700, color: selected ? Colors.white : AppColors.onSurface)),
          if (heavy) Text('HEAVY', style: AppTypography.caption.copyWith(color: selected ? Colors.white70 : AppColors.secondaryContainer)),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.sizeOf(context).width - (AppSpacing.marginMobile * 2) - 10) / 2,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(label, style: AppTypography.caption),
            Text(value, style: AppTypography.labelMd.copyWith(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTypography.caption)),
        Text(value, style: AppTypography.labelMd.copyWith(fontSize: 13)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action});

  final String title;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTypography.labelMd),
        const Spacer(),
        action,
      ],
    );
  }
}
