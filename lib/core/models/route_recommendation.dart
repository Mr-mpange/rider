class RouteRecommendation {
  const RouteRecommendation({
    required this.id,
    required this.origin,
    required this.destination,
    required this.routeColor,
    required this.durationMinutes,
    required this.distanceKm,
    required this.stopsCount,
    this.alternatives = const [],
  });

  final String id;
  final String origin;
  final String destination;
  final String routeColor;
  final int durationMinutes;
  final double distanceKm;
  final int stopsCount;
  final List<AlternativeRoute> alternatives;

  factory RouteRecommendation.fromFirestore(String id, Map<String, dynamic> data) {
    final alts = (data['alternatives'] as List<dynamic>? ?? [])
        .map((e) => AlternativeRoute.fromMap(e as Map<String, dynamic>))
        .toList();
    return RouteRecommendation(
      id: id,
      origin: data['origin'] as String? ?? '',
      destination: data['destination'] as String? ?? '',
      routeColor: data['routeColor'] as String? ?? '',
      durationMinutes: (data['durationMinutes'] as num?)?.toInt() ?? 0,
      distanceKm: (data['distanceKm'] as num?)?.toDouble() ?? 0,
      stopsCount: (data['stopsCount'] as num?)?.toInt() ?? 0,
      alternatives: alts,
    );
  }
}

class AlternativeRoute {
  const AlternativeRoute({
    required this.name,
    required this.durationMinutes,
    required this.distanceKm,
  });

  final String name;
  final int durationMinutes;
  final double distanceKm;

  factory AlternativeRoute.fromMap(Map<String, dynamic> data) {
    return AlternativeRoute(
      name: data['name'] as String? ?? '',
      durationMinutes: (data['durationMinutes'] as num?)?.toInt() ?? 0,
      distanceKm: (data['distanceKm'] as num?)?.toDouble() ?? 0,
    );
  }
}
