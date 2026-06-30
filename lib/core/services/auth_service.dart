import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';

class AuthService extends ChangeNotifier {
  UserProfile? _profile;
  String? _registeredPassword;

  bool get isFirebaseReady => false;

  dynamic get currentUser => _profile;
  bool get isAuthenticated => _profile != null;
  Stream<dynamic> get authStateChanges => const Stream<dynamic>.empty();

  Future<UserProfile?> getUserProfile() async => _profile;

  Stream<UserProfile?> watchUserProfile() {
    return Stream<UserProfile?>.value(_profile);
  }

  Future<void> registerUser({
    required String displayName,
    required String email,
    required String password,
  }) async {
    _registeredPassword = password;
    _profile = UserProfile(
      uid: 'offline-user',
      displayName: displayName,
      email: email,
      phoneNumber: '',
      photoUrl: null,
      isVerified: true,
      tripCount: 0,
      balanceTzs: 0,
    );
    notifyListeners();
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (_profile == null) {
      throw Exception('No account registered');
    }
    if (_profile!.email != email || _registeredPassword != password) {
      throw Exception('Invalid email or password');
    }
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _profile ??= UserProfile(
      uid: 'offline-user',
      displayName: 'Asha',
      email: 'user@example.com',
      phoneNumber: '',
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
      email: _profile!.email,
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
    _registeredPassword = null;
    notifyListeners();
  }
}
