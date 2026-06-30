class UserProfile {
  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.phoneNumber,
    this.photoUrl,
    this.tripCount = 0,
    this.balanceTzs = 0,
    this.isVerified = false,
    this.isAdmin = false,
  });

  final String uid;
  final String displayName;
  final String phoneNumber;
  final String? photoUrl;
  final int tripCount;
  final double balanceTzs;
  final bool isVerified;
  final bool isAdmin;

  factory UserProfile.fromFirestore(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      displayName: data['displayName'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      tripCount: (data['tripCount'] as num?)?.toInt() ?? 0,
      balanceTzs: (data['balanceTzs'] as num?)?.toDouble() ?? 0,
      isVerified: data['isVerified'] as bool? ?? false,
      isAdmin: data['isAdmin'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'displayName': displayName,
        'phoneNumber': phoneNumber,
        if (photoUrl != null) 'photoUrl': photoUrl,
        'tripCount': tripCount,
        'balanceTzs': balanceTzs,
        'isVerified': isVerified,
        'isAdmin': isAdmin,
      };
}
