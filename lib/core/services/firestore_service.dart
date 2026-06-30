import '../models/bus_stop.dart';
import '../models/destination.dart';
import '../models/route_recommendation.dart';
import '../models/saved_place.dart';

class FirestoreService {
  Stream<List<BusStop>> watchNearbyStops() => Stream.value(const []);

  Stream<List<RecentDestination>> watchRecentDestinations({String? userId}) =>
      Stream.value(const []);

  Stream<List<PopularLocation>> watchPopularLocations() =>
      Stream.value(const []);

  Stream<RouteRecommendation?> watchRouteRecommendation(String routeId) =>
      Stream.value(null);

  Future<RouteRecommendation?> getRouteForDestination({
    required String origin,
    required String destination,
  }) async {
    return null;
  }

  Stream<List<SavedPlace>> watchSavedPlaces(String userId) =>
      Stream.value(const []);

  Future<void> addSavedPlace(String userId, SavedPlace place) async {}

  Future<void> saveRecentDestination(
    String userId, {
    required String name,
    required String subtitle,
  }) async {}

  Future<void> submitReport({
    required String userId,
    required String type,
    required String description,
    String? photoUrl,
  }) async {}

  Stream<List<Map<String, dynamic>>> watchReports({int limit = 10}) =>
      Stream.value(const []);

  Stream<Map<String, dynamic>> watchAdminStats() =>
      Stream.value(const {});

  Future<void> startTrip({
    required String userId,
    required String routeId,
    required String destination,
  }) async {}

  Future<void> endTrip(String userId) async {}

  Stream<Map<String, dynamic>?> watchActiveTrip(String userId) =>
      Stream.value(null);
}
