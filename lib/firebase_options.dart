import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Firebase has not been configured for web in this project.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError('Firebase is only configured for Android and iOS in this project.');
      default:
        throw UnsupportedError('Unsupported platform.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOaQf8r0pyJKDncmB-eQwPCgyX1V-snNI',
    appId: '1:486608751731:android:2f229766c6e8e8c4aa6e06',
    messagingSenderId: '486608751731',
    projectId: 'ride-13812',
    storageBucket: 'ride-13812.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCi4AX9QBIEugjaB_byjHBz3pZ5_IW5O_Y',
    appId: '1:486608751731:ios:3db523cf1e39c200aa6e06',
    messagingSenderId: '486608751731',
    projectId: 'ride-13812',
    storageBucket: 'ride-13812.firebasestorage.app',
    iosBundleId: 'com.rider.rider',
  );
}
