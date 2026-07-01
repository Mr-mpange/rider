import 'package:flutter/material.dart';
import '../core/constants/app_branding.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/services/firestore_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          _Sidebar(onBack: () => context.pop()),
          Expanded(
            child: Column(
              children: [
                _TopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Overview', style: AppTypography.headlineMdMobile.copyWith(fontSize: 22)),
                        const SizedBox(height: 14),
                        StreamBuilder<Map<String, dynamic>>(
                          stream: context.read<FirestoreService>().watchAdminStats(),
                          builder: (context, snapshot) {
                            final stats = snapshot.data ?? {};
                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _StatBox(label: 'Active Users', value: '${stats['activeUsers'] ?? '1,248'}', color: AppColors.primary),
                                _StatBox(label: 'Trips Today', value: '${stats['tripsToday'] ?? '342'}', color: AppColors.secondary),
                                _StatBox(label: 'Searches', value: '${stats['searches'] ?? '12.5k'}', color: AppColors.tertiary),
                                _StatBox(label: 'New Reports', value: '${stats['newReports'] ?? '42'}', color: AppColors.error),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 18),
                        Text('Recent User Reports', style: AppTypography.labelMd),
                        const SizedBox(height: 10),
                        StreamBuilder<List<Map<String, dynamic>>>(
                          stream: context.read<FirestoreService>().watchReports(limit: 5),
                          builder: (context, snapshot) {
                            final reports = snapshot.data ?? [];
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()));
                            }
                            if (reports.isEmpty) {
                                return Text('No recent reports', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant));
                            }
                            return Column(children: reports.map((r) => _ReportRow(report: r)).toList());
                          },
                        ),
                        const SizedBox(height: 14),
                        TextButton(
                          onPressed: () => context.push('/reports'),
                          child: const Text('View all reports'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quick admin action not wired.'))),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.onBack});
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 272,
      color: AppColors.surfaceContainerLowest,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(22),
              child: Text(AppBranding.appName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ),
            _NavItem(icon: Icons.dashboard_outlined, label: 'Overview', active: true),
            _NavItem(icon: Icons.place_outlined, label: 'Nearby Stops', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nearby stops not wired.')))),
            _NavItem(icon: Icons.local_shipping_outlined, label: 'Freight', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Freight management not wired.')))),
            _NavItem(icon: Icons.report_outlined, label: 'Reports', onTap: () => context.push('/reports')),
            _NavItem(icon: Icons.settings_outlined, label: 'Settings', onTap: () => context.push('/profile')),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text('Back to App'),
              onTap: onBack,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, this.active = false, this.onTap});
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: active ? AppColors.primary : AppColors.onSurfaceVariant),
        title: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.primary : AppColors.onSurface,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.35))),
      ),
      child: Row(
        children: [
          Text('Overview', style: AppTypography.headlineMdMobile.copyWith(fontSize: 20)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No new admin notifications.'))),
          ),
          const CircleAvatar(child: Icon(Icons.person)),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 152,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.caption),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.headlineMdMobile.copyWith(fontSize: 22, color: color)),
        ],
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  const _ReportRow({required this.report});
  final Map<String, dynamic> report;
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${report['type'] ?? 'Ripoti'}', style: AppTypography.labelMd),
                const SizedBox(height: 4),
                Text('${report['description'] ?? ''}', maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTypography.caption.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          TextButton(onPressed: () => context.push('/reports'), child: const Text('Chunguza')),
        ],
      ),
    );
  }
}
