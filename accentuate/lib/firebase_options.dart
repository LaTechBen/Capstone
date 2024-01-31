// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAOZA_OFnb4yljXuBlaGAul8eK6ETbd3_c',
    appId: '1:116021754934:web:b0dac5452f55506ed4ac97',
    messagingSenderId: '116021754934',
    projectId: 'accentuate-3be42',
    authDomain: 'accentuate-3be42.firebaseapp.com',
    storageBucket: 'accentuate-3be42.appspot.com',
    measurementId: 'G-76SCF166BY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA92WqJkQNwjJHGUR02LwWHfZBA_gGYqkQ',
    appId: '1:116021754934:android:d726da593dfd2792d4ac97',
    messagingSenderId: '116021754934',
    projectId: 'accentuate-3be42',
    storageBucket: 'accentuate-3be42.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC-b9iDncBxlitDHpMoA4sk0JekgdxNY04',
    appId: '1:116021754934:ios:c7ac9a0fad7450a8d4ac97',
    messagingSenderId: '116021754934',
    projectId: 'accentuate-3be42',
    storageBucket: 'accentuate-3be42.appspot.com',
    iosBundleId: 'com.example.accentuate',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC-b9iDncBxlitDHpMoA4sk0JekgdxNY04',
    appId: '1:116021754934:ios:c3eac5937376a244d4ac97',
    messagingSenderId: '116021754934',
    projectId: 'accentuate-3be42',
    storageBucket: 'accentuate-3be42.appspot.com',
    iosBundleId: 'com.example.accentuate.RunnerTests',
  );
}