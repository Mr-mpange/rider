class RecentDestination {
  const RecentDestination({
    required this.id,
    required this.name,
    required this.subtitle,
  });

  final String id;
  final String name;
  final String subtitle;

  factory RecentDestination.fromFirestore(String id, Map<String, dynamic> data) {
    return RecentDestination(
      id: id,
      name: data['name'] as String? ?? '',
      subtitle: data['subtitle'] as String? ?? '',
    );
  }
}

class PopularLocation {
  const PopularLocation({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.style,
  });

  final String id;
  final String name;
  final String subtitle;
  final String icon;
  final String style;

  factory PopularLocation.fromFirestore(String id, Map<String, dynamic> data) {
    return PopularLocation(
      id: id,
      name: data['name'] as String? ?? '',
      subtitle: data['subtitle'] as String? ?? '',
      icon: data['icon'] as String? ?? 'place',
      style: data['style'] as String? ?? 'default',
    );
  }
}
