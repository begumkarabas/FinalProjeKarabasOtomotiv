// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBKusnukNs61pEWOLthozBIqXKaf4k2pFU',
    appId: '1:138473151776:web:fc9a6b2381a767747fcb45',
    messagingSenderId: '138473151776',
    projectId: 'finalproje-6a06d',
    authDomain: 'finalproje-6a06d.firebaseapp.com',
    storageBucket: 'finalproje-6a06d.firebasestorage.app',
    measurementId: 'G-NJEGN4PNHB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBONc4uDZ9mygfsgxpfmbc1_MisuoTQ0EQ',
    appId: '1:138473151776:android:a4e4b76b98c365d27fcb45',
    messagingSenderId: '138473151776',
    projectId: 'finalproje-6a06d',
    storageBucket: 'finalproje-6a06d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBMdd9lIaM_O7xCdYl2Yb6udc41TMl5Zyg',
    appId: '1:138473151776:ios:fba63e71361afebf7fcb45',
    messagingSenderId: '138473151776',
    projectId: 'finalproje-6a06d',
    storageBucket: 'finalproje-6a06d.firebasestorage.app',
    iosBundleId: 'com.example.finalproje',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBMdd9lIaM_O7xCdYl2Yb6udc41TMl5Zyg',
    appId: '1:138473151776:ios:fba63e71361afebf7fcb45',
    messagingSenderId: '138473151776',
    projectId: 'finalproje-6a06d',
    storageBucket: 'finalproje-6a06d.firebasestorage.app',
    iosBundleId: 'com.example.finalproje',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBKusnukNs61pEWOLthozBIqXKaf4k2pFU',
    appId: '1:138473151776:web:16d94071c082b01d7fcb45',
    messagingSenderId: '138473151776',
    projectId: 'finalproje-6a06d',
    authDomain: 'finalproje-6a06d.firebaseapp.com',
    storageBucket: 'finalproje-6a06d.firebasestorage.app',
    measurementId: 'G-26JZSCS1Z0',
  );
}
