import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/app_dialogs.dart';
import '../widgets/glass_card.dart';
import '../widgets/rider_bottom_nav_bar.dart';

class FreightScreen extends StatefulWidget {
  const FreightScreen({super.key});

  @override
  State<FreightScreen> createState() => _FreightScreenState();
}

class _FreightScreenState extends State<FreightScreen> {
  int _selectedTab = 0;

  void _showCreateShipmentSheet(BuildContext context) {
    final originController = TextEditingController(text: 'Dar Port');
    final destinationController = TextEditingController(text: 'Inland Depot');
    String cargoType = 'Dry Van';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.marginMobile,
                0,
                AppSpacing.marginMobile,
                MediaQuery.viewInsetsOf(sheetContext).bottom + AppSpacing.marginMobile,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create Shipment', style: AppTypography.headlineMdMobile.copyWith(fontSize: 22)),
                    const SizedBox(height: 8),
                    Text('Enter shipment details and create a real freight request.', style: AppTypography.bodyMd),
                    const SizedBox(height: 16),
                    TextField(
                      controller: originController,
                      decoration: const InputDecoration(
                        labelText: 'Origin',
                        prefixIcon: Icon(Icons.local_shipping_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: destinationController,
                      decoration: const InputDecoration(
                        labelText: 'Destination',
                        prefixIcon: Icon(Icons.place_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: cargoType,
                      decoration: const InputDecoration(
                        labelText: 'Cargo Type',
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Dry Van', child: Text('Dry Van')),
                        DropdownMenuItem(value: 'Reefer', child: Text('Reefer')),
                        DropdownMenuItem(value: 'Flatbed', child: Text('Flatbed')),
                        DropdownMenuItem(value: 'Hazmat', child: Text('Hazmat')),
                      ],
                      onChanged: (value) {
                        if (value != null) setSheetState(() => cargoType = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(sheetContext);
                              AppDialogs.showInfoSheet(
                                context,
                                title: 'Shipment Created',
                                body: 'Shipment from ${originController.text} to ${destinationController.text} with $cargoType is now active.',
                                cta: 'Done',
                              );
                            },
                            child: const Text('Create'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleTabTap(BuildContext context, int index) {
    setState(() => _selectedTab = index);

    switch (index) {
      case 1:
        AppDialogs.showInfoSheet(
          context,
          title: 'Shipments',
          body: 'Browse active and completed freight shipments from the dashboard.',
          cta: 'View Shipments',
        );
        break;
      case 2:
        AppDialogs.showInfoSheet(
          context,
          title: 'Partners',
          body: 'Review carrier partners, route coverage, and service ratings.',
          cta: 'Open Partners',
        );
        break;
      case 3:
        AppDialogs.showInfoSheet(
          context,
          title: 'Billing',
          body: 'Track invoices, payments, and account balance for freight operations.',
          cta: 'Open Billing',
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.marginMobile, 16, AppSpacing.marginMobile, 112),
          children: [
            RiiderHeader(onMenu: () => context.pop()),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: [
                  _NavChip(
                    label: 'Dashboard',
                    selected: _selectedTab == 0,
                    onTap: () => _handleTabTap(context, 0),
                  ),
                  const SizedBox(width: 8),
                  _NavChip(
                    label: 'Shipments',
                    selected: _selectedTab == 1,
                    onTap: () => _handleTabTap(context, 1),
                  ),
                  const SizedBox(width: 8),
                  _NavChip(
                    label: 'Partners',
                    selected: _selectedTab == 2,
                    onTap: () => _handleTabTap(context, 2),
                  ),
                  const SizedBox(width: 8),
                  _NavChip(
                    label: 'Billing',
                    selected: _selectedTab == 3,
                    onTap: () => _handleTabTap(context, 3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Enterprise Freight Management', style: AppTypography.headlineMdMobile.copyWith(fontSize: 22)),
            const SizedBox(height: 4),
            Text('Global Logistics Control', style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                SizedBox(
                  width: (MediaQuery.sizeOf(context).width - (AppSpacing.marginMobile * 2) - 10) / 2,
                  child: OutlinedButton.icon(
                    onPressed: () => AppDialogs.showInfoSheet(context, title: 'Export', body: 'Download shipment reports.', cta: 'Download'),
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Export'),
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.sizeOf(context).width - (AppSpacing.marginMobile * 2) - 10) / 2,
                  child: ElevatedButton.icon(
                    onPressed: () => _showCreateShipmentSheet(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Create'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GlassCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create Shipment', style: AppTypography.labelMd),
                  const SizedBox(height: 12),
                  const _FormRow(label: 'Origin', value: 'Dar Port'),
                  const _FormRow(label: 'Destination', value: 'Inland Depot'),
                  const SizedBox(height: 10),
                  Text('Cargo Type', style: AppTypography.caption),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: const [
                      _TypeChip(label: 'Dry Van', selected: true),
                      _TypeChip(label: 'Reefer'),
                      _TypeChip(label: 'Flatbed'),
                      _TypeChip(label: 'Hazmat'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Expanded(child: _FormRow(label: 'Weight (kg)', value: '12,400')),
                      SizedBox(width: 12),
                      Expanded(child: _FormRow(label: 'Volume (m³)', value: '48.2')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            GlassCard(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const Icon(Icons.trending_up, color: AppColors.secondary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estimated Monthly Savings', style: AppTypography.caption),
                        Text('14% vs Last Month', style: AppTypography.labelMd.copyWith(color: AppColors.secondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text('Live Carrier Bids • 4 New Offers', style: AppTypography.labelMd),
            const SizedBox(height: 10),
            const _CarrierCard(name: 'Blue-Wave Logistics', rating: '4.9 (1.2k)', transit: '24-36 Hours', reliability: '99.8%'),
            const SizedBox(height: 10),
            const _CarrierCard(name: 'Apex Heavy Haul', rating: '4.7 (850)', transit: '18-24 Hours', reliability: '98.5%'),
            const SizedBox(height: 14),
            Text('Active In-Transit', style: AppTypography.labelMd),
            const SizedBox(height: 8),
            const _TransitRow(id: 'FRT-2049', route: 'Dar Port → Hub', cargo: 'Dry Van', status: 'In Transit', eta: '3h 24m'),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: const RiderBottomNavBar(currentTab: RiderNavTab.home),
    );
  }
}

class _NavChip extends StatelessWidget {
  const _NavChip({required this.label, required this.onTap, this.selected = false});
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(label, style: AppTypography.caption.copyWith(color: selected ? Colors.white : AppColors.onSurface)),
        ),
      ),
    );
  }
}

class _FormRow extends StatelessWidget {
  const _FormRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.caption),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.labelMd),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.label, this.selected = false});
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: AppTypography.caption.copyWith(color: selected ? Colors.white : AppColors.onSurface)),
    );
  }
}

class _CarrierCard extends StatelessWidget {
  const _CarrierCard({required this.name, required this.rating, required this.transit, required this.reliability});
  final String name;
  final String rating;
  final String transit;
  final String reliability;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.domain, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(child: Text(name, style: AppTypography.labelMd)),
              const SizedBox(width: 8),
              const Icon(Icons.star, size: 16, color: AppColors.secondaryContainer),
              const SizedBox(width: 4),
              Text(rating, style: AppTypography.caption),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Text('Est. Transit\n$transit', style: AppTypography.caption)),
              Expanded(child: Text('Reliability\n$reliability', style: AppTypography.caption)),
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  onPressed: () => AppDialogs.showInfoSheet(
                    context,
                    title: 'Select Carrier',
                    body: 'Carrier $name selected for this shipment.',
                    cta: 'Confirm',
                  ),
                  child: const Text('Select'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransitRow extends StatelessWidget {
  const _TransitRow({required this.id, required this.route, required this.cargo, required this.status, required this.eta});
  final String id;
  final String route;
  final String cargo;
  final String status;
  final String eta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: 90, child: Text(id, style: AppTypography.labelMd)),
            SizedBox(width: 150, child: Text(route, style: AppTypography.caption)),
            SizedBox(width: 100, child: Text(cargo, style: AppTypography.caption)),
            SizedBox(width: 110, child: Text(status, style: AppTypography.caption.copyWith(color: AppColors.secondary))),
            SizedBox(width: 70, child: Text(eta, style: AppTypography.caption)),
          ],
      ),
      ),
    );
  }
}
