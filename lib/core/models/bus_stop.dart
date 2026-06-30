class BusStop {
  const BusStop({
    required this.id,
    required this.name,
    required this.distanceMeters,
    required this.etaMinutes,
    required this.type,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String name;
  final int distanceMeters;
  final int etaMinutes;
  final String type;
  final double? latitude;
  final double? longitude;

  factory BusStop.fromFirestore(String id, Map<String, dynamic> data) {
    return BusStop(
      id: id,
      name: data['name'] as String? ?? '',
      distanceMeters: (data['distanceMeters'] as num?)?.toInt() ?? 0,
      etaMinutes: (data['etaMinutes'] as num?)?.toInt() ?? 0,
      type: data['type'] as String? ?? 'DALADALA',
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
    );
  }

  String get distanceLabel {
    if (distanceMeters >= 1000) {
      final km = distanceMeters / 1000;
      return 'km ${km.toStringAsFixed(1)}';
    }
    return 'mita $distanceMeters';
  }
}
