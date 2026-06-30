import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';

class AuthService extends ChangeNotifier {
  UserProfile? _profile;

  String? _verificationId;
  String? _pendingPhone;

  bool get isFirebaseReady => false;

  dynamic get currentUser => null;
  bool get isAuthenticated => false;
  Stream<dynamic> get authStateChanges => const Stream<dynamic>.empty();

  Future<UserProfile?> getUserProfile() async => _profile;

  Stream<UserProfile?> watchUserProfile() {
    return Stream<UserProfile?>.value(_profile);
  }

  Future<void> sendPhoneOtp(String phoneDigits) async {
    _pendingPhone = '+255$phoneDigits';
    _verificationId = 'offline-verification';
    notifyListeners();
  }

  Future<void> verifyOtp(String code) async {
    if (_verificationId == null) {
      throw Exception('No verification in progress');
    }
    _profile = UserProfile(
      uid: 'offline-user',
      displayName: 'Msafiri',
      phoneNumber: _pendingPhone ?? '',
      photoUrl: null,
      isVerified: true,
      tripCount: 0,
      balanceTzs: 0,
    );
    _verificationId = null;
    notifyListeners();
  }

  Future<void> registerUser({
    required String displayName,
    required String phoneDigits,
  }) async {
    _pendingPhone = '+255$phoneDigits';
    _profile = UserProfile(
      uid: 'offline-user',
      displayName: displayName,
      phoneNumber: _pendingPhone ?? '',
      photoUrl: null,
      isVerified: true,
      tripCount: 0,
      balanceTzs: 0,
    );
    _verificationId = 'offline-verification';
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _profile = UserProfile(
      uid: 'offline-user',
      displayName: 'Msafiri',
      phoneNumber: _pendingPhone ?? '',
      photoUrl: null,
      isVerified: true,
      tripCount: 0,
      balanceTzs: 0,
    );
    notifyListeners();
  }

  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    if (_profile == null) return;
    _profile = UserProfile(
      uid: _profile!.uid,
      displayName: displayName ?? _profile!.displayName,
      phoneNumber: _profile!.phoneNumber,
      photoUrl: photoUrl ?? _profile!.photoUrl,
      isVerified: _profile!.isVerified,
      tripCount: _profile!.tripCount,
      balanceTzs: _profile!.balanceTzs,
    );
    notifyListeners();
  }

  Future<void> signOut() async {
    _profile = null;
    _verificationId = null;
    _pendingPhone = null;
    notifyListeners();
  }

  String? get pendingPhone => _pendingPhone;
}
