/// Firestore seed data matching the Stitch design screens.
/// Import this map in a Cloud Function, Firebase Admin script, or emulator seed.
///
/// Collections:
/// - bus_stops
/// - popular_locations
/// - routes
/// - admin_stats/overview
const firestoreSeedData = {
  'bus_stops': [
    {
      'name': 'Stendi ya Mwenge',
      'distanceMeters': 200,
      'etaMinutes': 3,
      'type': 'DALADALA',
    },
    {
      'name': 'Stendi ya Ubungo',
      'distanceMeters': 800,
      'etaMinutes': 10,
      'type': 'BRT',
    },
    {
      'name': 'Stendi ya Posta',
      'distanceMeters': 4500,
      'etaMinutes': 25,
      'type': 'POST',
    },
  ],
  'recent_destinations': [
    {
      'name': 'Kariakoo',
      'subtitle': 'Soko Kuu, Dar es Salaam',
      'sortOrder': 1,
    },
    {
      'name': 'Posta Mpya',
      'subtitle': 'CBD, Dar es Salaam',
      'sortOrder': 2,
    },
    {
      'name': 'Mbagala',
      'subtitle': 'Kituo cha Mabasi, Temeke',
      'sortOrder': 3,
    },
  ],
  'popular_locations': [
    {
      'name': 'Nyumbani',
      'subtitle': 'Weka sasa',
      'icon': 'home',
      'style': 'home',
      'sortOrder': 1,
    },
    {
      'name': 'Kazini',
      'subtitle': 'Weka sasa',
      'icon': 'work',
      'style': 'work',
      'sortOrder': 2,
    },
    {
      'name': 'Mlimani City',
      'subtitle': 'Shopping Mall, Ubungo',
      'icon': 'apartment',
      'style': 'default',
      'sortOrder': 3,
    },
  ],
  'routes': [
    {
      'origin': 'Kituo cha Ubungo',
      'destination': 'Posta Mpya',
      'routeColor': 'Bluu na Nyeupe',
      'durationMinutes': 25,
      'distanceKm': 12,
      'stopsCount': 8,
      'alternatives': [
        {'name': 'Kupitia Kimara - Magomeni', 'durationMinutes': 35, 'distanceKm': 15},
        {'name': 'Daladala za Manzese', 'durationMinutes': 42, 'distanceKm': 11},
      ],
    },
    {
      'origin': 'Stendi ya Mwenge',
      'destination': 'Posta Mpya',
      'routeColor': 'Bluu na Nyeupe',
      'durationMinutes': 22,
      'distanceKm': 10,
      'stopsCount': 6,
      'alternatives': [
        {'name': 'Kupitia Ubungo', 'durationMinutes': 28, 'distanceKm': 12},
      ],
    },
    {
      'origin': 'Stendi ya Ubungo',
      'destination': 'Posta Mpya',
      'routeColor': 'Bluu na Nyeupe',
      'durationMinutes': 20,
      'distanceKm': 9,
      'stopsCount': 5,
      'alternatives': [],
    },
    {
      'origin': 'Stendi ya Mwenge',
      'destination': 'Kariakoo',
      'routeColor': 'Nyekundu na Nyeupe',
      'durationMinutes': 18,
      'distanceKm': 7,
      'stopsCount': 4,
      'alternatives': [],
    },
    {
      'origin': 'Kituo cha Ubungo',
      'destination': 'Mlimani City',
      'routeColor': 'Kijani',
      'durationMinutes': 12,
      'distanceKm': 4,
      'stopsCount': 3,
      'alternatives': [],
    },
  ],
  'admin_stats': {
    'overview': {
      'activeUsers': 1248,
      'tripsToday': 342,
      'searches': '12.5k',
      'newReports': 42,
    },
  },
};
