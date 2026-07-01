import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../constants/firestore_seed_data.dart';

class FirestoreSeedService {
  FirestoreSeedService({this._firestore});

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  Future<void> seedIfEmpty() async {
    final batches = <Future<void>>[];

    try {
      Future<void> seedCollection(String collection, List<Map<String, dynamic>> docs) async {
        final ref = _db.collection(collection);
        final snapshot = await ref.limit(1).get();
        if (snapshot.docs.isNotEmpty) return;

        final batch = _db.batch();
        for (final doc in docs) {
          final data = Map<String, dynamic>.from(doc);
          final id = (data.remove('id') as String?) ?? _slug(data['name'] as String? ?? collection);
          batch.set(ref.doc(id), data);
        }
        batches.add(batch.commit());
      }

      await seedCollection('busStops', List<Map<String, dynamic>>.from(firestoreSeedData['bus_stops'] as List));
      await seedCollection('recentDestinations', List<Map<String, dynamic>>.from(firestoreSeedData['recent_destinations'] as List));
      await seedCollection('popularLocations', List<Map<String, dynamic>>.from(firestoreSeedData['popular_locations'] as List));
      await seedCollection('routeRecommendations', List<Map<String, dynamic>>.from(firestoreSeedData['routes'] as List));
      await seedCollection('walletTransactions', [
        {
          'title': 'Freight: Zone B to Hub',
          'subtitle': 'Today, 10:24 AM • Logistics',
          'amount': -4200,
          'status': 'pending',
          'category': 'Freight',
          'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 2))),
        },
        {
          'title': 'Wallet Top Up',
          'subtitle': 'Yesterday, 4:15 PM • Bank Transfer',
          'amount': 50000,
          'status': 'completed',
          'category': 'Top Up',
          'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
        },
        {
          'title': 'Cold Cargo Service',
          'subtitle': '22 Oct 2023 • Maintenance',
          'amount': -18000,
          'status': 'completed',
          'category': 'Cargo',
          'createdAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 3))),
        },
      ]);
      await seedCollection('tripHistory', [
        {
          'title': 'Ride 1',
          'subtitle': 'Ubungo to Posta Mpya',
          'fare': 4200,
          'status': 'completed',
          'dateLabel': 'Today',
        },
        {
          'title': 'Ride 2',
          'subtitle': 'Mwenge to Kariakoo',
          'fare': 3900,
          'status': 'completed',
          'dateLabel': 'Yesterday',
        },
      ]);

      final adminStats = firestoreSeedData['admin_stats'] as Map<String, dynamic>;
      await _db.collection('adminStats').doc('summary').set(
        Map<String, dynamic>.from(adminStats['overview'] as Map),
        SetOptions(merge: true),
      );

      await Future.wait(batches);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        if (kDebugMode) {
          debugPrint('Firestore seed skipped because current rules deny access.');
        }
        return;
      }
      rethrow;
    }
  }

  String _slug(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}
