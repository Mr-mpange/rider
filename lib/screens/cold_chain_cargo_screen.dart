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
  double _setPoint = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 16, AppSpacing.marginMobile, 24),
          children: [
            RiiderHeader(onMenu: () => context.pop()),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text('ID: CC-4902-X', style: AppTypography.caption.copyWith(color: AppColors.primary)),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => AppDialogs.showInfoSheet(context, title: 'Saved', body: 'Cold cargo preset saved.', cta: 'Close'),
                  icon: const Icon(Icons.save_outlined, color: AppColors.primary),
                ),
              ],
            ),
            Text('Cold Cargo Management', style: AppTypography.headlineMdMobile),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thermostat Control', style: AppTypography.labelMd),
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
                            value: (_setPoint + 10) / 30,
                            strokeWidth: 10,
                            color: AppColors.primary,
                            backgroundColor: AppColors.surfaceContainer,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.thermostat, color: AppColors.primary),
                              Text('SET POINT', style: AppTypography.caption.copyWith(letterSpacing: 1)),
                              Text('${_setPoint.toStringAsFixed(0)}°C', style: AppTypography.headlineMdMobile),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Slider(
                    value: _setPoint,
                    min: -10,
                    max: 10,
                    divisions: 20,
                    label: '${_setPoint.toStringAsFixed(0)}°C',
                    onChanged: (v) => setState(() => _setPoint = v),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_outlined, size: 16, color: AppColors.secondaryContainer),
                      const SizedBox(width: 6),
                      Expanded(child: Text('Current ambient variation: ±0.4°C', style: AppTypography.caption)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            GlassCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cargo Allocation', style: AppTypography.labelMd),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Expanded(child: _ZoneChip(label: 'ZONE A')),
                      SizedBox(width: 8),
                      Expanded(child: _ZoneChip(label: 'ZONE B', heavy: true)),
                      SizedBox(width: 8),
                      Expanded(child: _ZoneChip(label: 'ZONE C')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('REFRIGERATED UNIT 09-A', style: AppTypography.caption),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: const [
                Expanded(child: _MetricCard(icon: Icons.sensors, label: 'Humi. Sensor', value: '42% RH')),
                SizedBox(width: 10),
                Expanded(child: _MetricCard(icon: Icons.lock_outline, label: 'Seal Status', value: 'Secured')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Expanded(child: _MetricCard(icon: Icons.ac_unit, label: 'Critical Temp', value: 'Frozen Store')),
                SizedBox(width: 10),
                Expanded(child: _MetricCard(icon: Icons.inventory_2_outlined, label: 'Available Space', value: '68%')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Expanded(child: _MetricCard(icon: Icons.speed, label: 'Airflow Speed', value: '4.2 m/s')),
                SizedBox(width: 10),
                Expanded(child: _MetricCard(icon: Icons.battery_charging_full, label: 'Cooling Power', value: '88%')),
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
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history, color: AppColors.primary),
              title: const Text('System Health Log'),
              subtitle: const Text('Compressor cycling normal • 12:04 PM'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const RiderBottomNavBar(currentTab: RiderNavTab.tracking),
    );
  }
}

class _ZoneChip extends StatelessWidget {
  const _ZoneChip({required this.label, this.heavy = false});
  final String label;
  final bool heavy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Text(label, style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700)),
          if (heavy) Text('HEAVY', style: AppTypography.caption.copyWith(color: AppColors.secondaryContainer)),
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
    return Container(
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
    );
  }
}
