import 'package:flutter/material.dart';
import '../core/constants/app_branding.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/models/destination.dart';
import '../core/router/app_router.dart';
import '../core/services/auth_service.dart';
import '../core/services/firestore_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../widgets/shimmer_loading.dart';

class DestinationSearchScreen extends StatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  State<DestinationSearchScreen> createState() => _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends State<DestinationSearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _selectDestination(String name, String subtitle) {
    final userId = context.read<AuthService>().currentUser?.uid;
    if (userId != null) {
      context.read<FirestoreService>().saveRecentDestination(
            userId,
            name: name,
            subtitle: subtitle,
          );
    }
    context.push(
      AppRoutes.routeRecommendation,
      extra: {'origin': 'Kituo cha Ubungo', 'destination': name},
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final userId = auth.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          AppBar(
            backgroundColor: AppColors.surface.withValues(alpha: 0.9),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
              onPressed: () => context.pop(),
            ),
            title: Text(
              AppBranding.appName,
              style: AppTypography.headlineMdMobile.copyWith(color: AppColors.primary),
            ),
            actions: const [
              Icon(Icons.search, color: AppColors.primary),
              SizedBox(width: 16),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.marginMobile,
                24,
                AppSpacing.marginMobile,
                32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      style: AppTypography.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Where are you going?',
                        border: InputBorder.none,
                        prefixIcon: const Icon(Icons.my_location, color: AppColors.primary),
                        suffixIcon: const Icon(Icons.mic, color: AppColors.onSurfaceVariant),
                      ),
                      onSubmitted: (v) {
                        if (v.trim().isNotEmpty) {
                          _selectDestination(v.trim(), 'Dar es Salaam');
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Recent Trips',
                    style: AppTypography.textTheme.labelLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<List<RecentDestination>>(
                    stream: context
                        .read<FirestoreService>()
                        .watchRecentDestinations(userId: userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ShimmerPlaceholders();
                      }
                      final items = snapshot.data ?? [];
                      if (items.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: items.map((item) {
                          return _RecentItem(
                            name: item.name,
                            subtitle: item.subtitle,
                            onTap: () => _selectDestination(item.name, item.subtitle),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Popular Places',
                    style: AppTypography.textTheme.labelLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<List<PopularLocation>>(
                    stream: context.read<FirestoreService>().watchPopularLocations(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ShimmerPlaceholders();
                      }
                      final locations = snapshot.data ?? [];
                      if (locations.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            'No popular places available yet.',
                            style: AppTypography.textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        );
                      }
                      return _PopularBentoGrid(
                        locations: locations,
                        onSelect: _selectDestination,
                        onSavedPlaces: () => context.go(AppRoutes.savedPlaces),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.outlineVariant.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Nearby Places',
                        style: AppTypography.textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const ShimmerPlaceholders(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularBentoGrid extends StatelessWidget {
  const _PopularBentoGrid({
    required this.locations,
    required this.onSelect,
    required this.onSavedPlaces,
  });

  final List<PopularLocation> locations;
  final void Function(String name, String subtitle) onSelect;
  final VoidCallback onSavedPlaces;

  @override
  Widget build(BuildContext context) {
    final tiles = locations.where((l) => l.style == 'home' || l.style == 'work').toList();
    final listItems = locations.where((l) => l.style == 'default').toList();

    return Column(
      children: [
        if (tiles.isNotEmpty)
          Row(
            children: [
              for (var i = 0; i < tiles.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(
                  child: _PopularTile(
                    icon: _iconFromName(tiles[i].icon),
                    title: tiles[i].name,
                    subtitle: tiles[i].subtitle,
                    color: tiles[i].style == 'home'
                        ? AppColors.secondaryContainer.withValues(alpha: 0.2)
                        : AppColors.primaryContainer.withValues(alpha: 0.1),
                    iconColor: tiles[i].style == 'home'
                        ? AppColors.secondary
                        : AppColors.primary,
                    borderColor: tiles[i].style == 'home'
                        ? AppColors.secondaryContainer
                        : AppColors.primaryContainer.withValues(alpha: 0.2),
                    onTap: tiles[i].style == 'home' || tiles[i].style == 'work'
                        ? onSavedPlaces
                        : () => onSelect(tiles[i].name, tiles[i].subtitle),
                  ),
                ),
              ],
            ],
          ),
        if (tiles.isNotEmpty && listItems.isNotEmpty) const SizedBox(height: 12),
        ...listItems.map(
          (loc) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _PopularListTile(
              icon: _iconFromName(loc.icon),
              title: loc.name,
              subtitle: loc.subtitle,
              onTap: () => onSelect(loc.name, loc.subtitle),
            ),
          ),
        ),
      ],
    );
  }

  IconData _iconFromName(String name) {
    switch (name) {
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      case 'apartment':
        return Icons.apartment;
      default:
        return Icons.place;
    }
  }
}

class _RecentItem extends StatelessWidget {
  const _RecentItem({
    required this.name,
    required this.subtitle,
    required this.onTap,
  });

  final String name;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.surfaceVariant,
              child: const Icon(Icons.history, color: AppColors.onSurfaceVariant, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTypography.textTheme.bodyLarge),
                  Text(subtitle, style: AppTypography.textTheme.labelSmall),
                ],
              ),
            ),
            const Icon(Icons.north_west, color: AppColors.outlineVariant, size: 20),
          ],
        ),
      ),
    );
  }
}

class _PopularTile extends StatelessWidget {
  const _PopularTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.iconColor,
    required this.borderColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color iconColor;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 128,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: iconColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.textTheme.labelLarge?.copyWith(
                    color: iconColor == AppColors.secondary
                        ? AppColors.onSecondaryContainer
                        : AppColors.onPrimaryContainer,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.textTheme.labelSmall?.copyWith(
                    color: (iconColor == AppColors.secondary
                            ? AppColors.onSecondaryContainer
                            : AppColors.onPrimaryContainer)
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularListTile extends StatelessWidget {
  const _PopularListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.onPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(subtitle, style: AppTypography.textTheme.labelSmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
