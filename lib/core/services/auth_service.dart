// ignore_for_file: prefer_initializing_formals

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_profile.dart';
import 'firestore_service.dart';

class AuthService extends ChangeNotifier {
  AuthService({FirebaseAuth? auth, FirestoreService? firestoreService})
      : _auth = auth,
        _firestoreService = firestoreService {
    _authSubscription = _firebaseAuth.authStateChanges().listen((user) async {
      if (user == null) {
        _profile = null;
        notifyListeners();
        return;
      }

      _profile = await _firestore.getUserProfile(user.uid) ??
          UserProfile(
            uid: user.uid,
            displayName: user.displayName ?? '',
            email: user.email ?? '',
            phoneNumber: user.phoneNumber ?? '',
            photoUrl: user.photoURL,
            isVerified: user.emailVerified,
            tripCount: 0,
            balanceTzs: 0,
          );
      notifyListeners();
    });
  }

  FirebaseAuth? _auth;
  FirestoreService? _firestoreService;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  StreamSubscription<User?>? _authSubscription;
  UserProfile? _profile;

  bool get isFirebaseReady => true;

  FirebaseAuth get _firebaseAuth {
    _auth ??= FirebaseAuth.instanceFor(app: Firebase.app());
    return _auth!;
  }

  FirestoreService get _firestore {
    _firestoreService ??= FirestoreService(firestore: FirebaseFirestore.instanceFor(app: Firebase.app()));
    return _firestoreService!;
  }

  dynamic get currentUser => _profile;
  bool get isAuthenticated => _firebaseAuth.currentUser != null;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserProfile?> getUserProfile() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return _profile ?? await _firestore.getUserProfile(user.uid);
  }

  Stream<UserProfile?> watchUserProfile() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return Stream<UserProfile?>.value(null);
    return _firestore.watchUserProfile(user.uid);
  }

  Future<void> registerUser({
    required String displayName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    try {
      final cred = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final user = cred.user;
      if (user == null) {
        throw FirebaseAuthException(code: 'account-create-failed', message: 'Unable to create account');
      }

      final profile = UserProfile(
        uid: user.uid,
        displayName: displayName,
        email: email,
        phoneNumber: phoneNumber ?? user.phoneNumber ?? '',
        photoUrl: user.photoURL,
        isVerified: false,
        tripCount: 0,
        balanceTzs: 0,
      );
      await _firestore.upsertUserProfile(profile);
      _profile = profile;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<void> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw Exception('Google sign in cancelled');
    }
    final auth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null || _profile == null) return;

    final updated = UserProfile(
      uid: _profile!.uid,
      displayName: displayName ?? _profile!.displayName,
      email: _profile!.email,
      phoneNumber: _profile!.phoneNumber,
      photoUrl: photoUrl ?? _profile!.photoUrl,
      tripCount: _profile!.tripCount,
      balanceTzs: _profile!.balanceTzs,
      isVerified: _profile!.isVerified,
      isAdmin: _profile!.isAdmin,
    );
    await _firestore.upsertUserProfile(updated);
    _profile = updated;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _profile = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
