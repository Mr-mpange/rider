class SavedPlace {
  const SavedPlace({
    required this.id,
    required this.label,
    required this.address,
    required this.icon,
    this.isConfigured = true,
  });

  final String id;
  final String label;
  final String address;
  final String icon;
  final bool isConfigured;

  factory SavedPlace.fromFirestore(String id, Map<String, dynamic> data) {
    return SavedPlace(
      id: id,
      label: data['label'] as String? ?? '',
      address: data['address'] as String? ?? '',
      icon: data['icon'] as String? ?? 'place',
      isConfigured: data['isConfigured'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'label': label,
        'address': address,
        'icon': icon,
        'isConfigured': isConfigured,
      };
}
