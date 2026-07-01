class UserProfile {
  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    this.photoUrl,
    this.tripCount = 0,
    this.balanceTzs = 0,
    this.isVerified = false,
    this.isAdmin = false,
    this.notificationsEnabled = true,
    this.themeMode = 'system',
    this.localeCode = 'en',
  });

  final String uid;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String? photoUrl;
  final int tripCount;
  final double balanceTzs;
  final bool isVerified;
  final bool isAdmin;
  final bool? notificationsEnabled;
  final String? themeMode;
  final String? localeCode;

  bool get notificationsEnabledValue => notificationsEnabled ?? true;
  String get themeModeValue => themeMode ?? 'system';
  String get localeCodeValue => localeCode ?? 'en';

  factory UserProfile.fromFirestore(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      displayName: data['displayName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      tripCount: (data['tripCount'] as num?)?.toInt() ?? 0,
      balanceTzs: (data['balanceTzs'] as num?)?.toDouble() ?? 0,
      isVerified: data['isVerified'] as bool? ?? false,
      isAdmin: data['isAdmin'] as bool? ?? false,
      notificationsEnabled: data['notificationsEnabled'] as bool? ?? true,
      themeMode: data['themeMode'] as String? ?? 'system',
      localeCode: data['localeCode'] as String? ?? 'en',
    );
  }

  Map<String, dynamic> toFirestore() => {
        'displayName': displayName,
        'email': email,
        'phoneNumber': phoneNumber,
        if (photoUrl != null) 'photoUrl': photoUrl,
        'tripCount': tripCount,
        'balanceTzs': balanceTzs,
        'isVerified': isVerified,
        'isAdmin': isAdmin,
        'notificationsEnabled': notificationsEnabled ?? true,
        'themeMode': themeMode ?? 'system',
        'localeCode': localeCode ?? 'en',
      };
}
