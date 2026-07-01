import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bus_stop.dart';
import '../models/destination.dart';
import '../models/route_recommendation.dart';
import '../models/saved_place.dart';
import '../models/user_profile.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users => _firestore.collection('users');
  CollectionReference<Map<String, dynamic>> get _busStops => _firestore.collection('busStops');
  CollectionReference<Map<String, dynamic>> get _recentDestinations => _firestore.collection('recentDestinations');
  CollectionReference<Map<String, dynamic>> get _popularLocations => _firestore.collection('popularLocations');
  CollectionReference<Map<String, dynamic>> get _routeRecommendations => _firestore.collection('routeRecommendations');
  CollectionReference<Map<String, dynamic>> get _savedPlaces => _firestore.collection('savedPlaces');
  CollectionReference<Map<String, dynamic>> get _reports => _firestore.collection('reports');
  CollectionReference<Map<String, dynamic>> get _activeTrips => _firestore.collection('activeTrips');
  CollectionReference<Map<String, dynamic>> get _walletTransactions => _firestore.collection('walletTransactions');
  CollectionReference<Map<String, dynamic>> get _adminStats => _firestore.collection('adminStats');

  Stream<List<BusStop>> watchNearbyStops() {
    return _busStops.limit(10).snapshots().map(
          (snap) => snap.docs.map((doc) => BusStop.fromFirestore(doc.id, doc.data())).toList(),
        );
  }

  Stream<List<RecentDestination>> watchRecentDestinations({String? userId}) {
    Query<Map<String, dynamic>> query = _recentDestinations.orderBy('updatedAt', descending: true).limit(10);
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }
    return query.snapshots().map(
          (snap) => snap.docs.map((doc) => RecentDestination.fromFirestore(doc.id, doc.data())).toList(),
        );
  }

  Stream<List<PopularLocation>> watchPopularLocations() {
    return _popularLocations.limit(10).snapshots().map(
          (snap) => snap.docs.map((doc) => PopularLocation.fromFirestore(doc.id, doc.data())).toList(),
        );
  }

  Stream<RouteRecommendation?> watchRouteRecommendation(String routeId) {
    return _routeRecommendations.doc(routeId).snapshots().map(
          (doc) => doc.data() == null ? null : RouteRecommendation.fromFirestore(doc.id, doc.data()!),
        );
  }

  Future<RouteRecommendation?> getRouteForDestination({
    required String origin,
    required String destination,
  }) async {
    final query = await _routeRecommendations
        .where('origin', isEqualTo: origin)
        .where('destination', isEqualTo: destination)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    final doc = query.docs.first;
    return RouteRecommendation.fromFirestore(doc.id, doc.data());
  }

  Stream<List<SavedPlace>> watchSavedPlaces(String userId) {
    return _savedPlaces.where('userId', isEqualTo: userId).snapshots().map(
          (snap) => snap.docs.map((doc) => SavedPlace.fromFirestore(doc.id, doc.data())).toList(),
        );
  }

  Future<void> addSavedPlace(String userId, SavedPlace place) async {
    final docRef = place.id.isEmpty ? _savedPlaces.doc() : _savedPlaces.doc(place.id);
    await docRef.set({
      ...place.toFirestore(),
      'userId': userId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveRecentDestination(
    String userId, {
    required String name,
    required String subtitle,
  }) async {
    await _recentDestinations.add({
      'userId': userId,
      'name': name,
      'subtitle': subtitle,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> submitReport({
    required String userId,
    required String type,
    required String description,
    String? photoUrl,
  }) async {
    final data = <String, dynamic>{
      'userId': userId,
      'type': type,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    };
    if (photoUrl != null) data['photoUrl'] = photoUrl;
    await _reports.add(data);
  }

  Stream<List<Map<String, dynamic>>> watchReports({int limit = 10}) {
    return _reports.orderBy('createdAt', descending: true).limit(limit).snapshots().map(
          (snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList(),
        );
  }

  Stream<Map<String, dynamic>> watchAdminStats() {
    return _adminStats.doc('summary').snapshots().map((doc) => doc.data() ?? const {});
  }

  Future<void> startTrip({
    required String userId,
    required String routeId,
    required String destination,
    String? routeColor,
  }) async {
    final data = <String, dynamic>{
      'userId': userId,
      'routeId': routeId,
      'destination': destination,
      'status': 'active',
      'driverName': 'Asha M.',
      'vehicleName': 'Toyota Premio',
      'etaMinutes': 4,
      'distanceKm': 1.4,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (routeColor != null) data['routeColor'] = routeColor;
    await _activeTrips.doc(userId).set(data, SetOptions(merge: true));
  }

  Future<void> endTrip(String userId) async {
    await _activeTrips.doc(userId).set({
      'userId': userId,
      'status': 'completed',
      'endedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<Map<String, dynamic>?> watchActiveTrip(String userId) {
    return _activeTrips.doc(userId).snapshots().map((doc) => doc.data());
  }

  Stream<List<Map<String, dynamic>>> watchActiveTrips({String? userId}) {
    Query<Map<String, dynamic>> query = _activeTrips.orderBy('updatedAt', descending: true);
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }
    return query.snapshots().map(
          (snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList(),
        );
  }

  Stream<List<Map<String, dynamic>>> watchWalletTransactions({String? userId, int limit = 20}) {
    Query<Map<String, dynamic>> query = _walletTransactions.orderBy('createdAt', descending: true).limit(limit);
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }
    return query.snapshots().map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  Stream<List<Map<String, dynamic>>> watchTripHistory({String? userId, int limit = 20}) {
    Query<Map<String, dynamic>> query = _activeTrips.orderBy('updatedAt', descending: true).limit(limit);
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }
    return query.snapshots().map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _users.doc(uid).get();
    final data = doc.data();
    if (data == null) return null;
    return UserProfile.fromFirestore(doc.id, data);
  }

  Stream<UserProfile?> watchUserProfile(String uid) {
    return _users.doc(uid).snapshots().map((doc) => doc.data() == null ? null : UserProfile.fromFirestore(doc.id, doc.data()!));
  }

  Future<void> upsertUserProfile(UserProfile profile) async {
    await _users.doc(profile.uid).set(profile.toFirestore(), SetOptions(merge: true));
  }
}
