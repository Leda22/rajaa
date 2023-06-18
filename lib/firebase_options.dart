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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD_Fkf9Yjusaer30ey70w-3X91L_ebBZ80',
    appId: '1:582476176630:web:2b9423dfc136a667a5e0d7',
    messagingSenderId: '582476176630',
    projectId: 'radjaa-32fcc',
    authDomain: 'radjaa-32fcc.firebaseapp.com',
    storageBucket: 'radjaa-32fcc.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAIM_fH6AkIaNghX4yEeOTsGUyzXmBvcVI',
    appId: '1:582476176630:android:3691fab82270a013a5e0d7',
    messagingSenderId: '582476176630',
    projectId: 'radjaa-32fcc',
    storageBucket: 'radjaa-32fcc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD7_xbCms7ra9vPoYgYEALLKxMhUN5R9cw',
    appId: '1:582476176630:ios:369f8bd14c50c71da5e0d7',
    messagingSenderId: '582476176630',
    projectId: 'radjaa-32fcc',
    storageBucket: 'radjaa-32fcc.appspot.com',
    iosClientId: '582476176630-lbvil2ul16s9ci6dlnsetouqav69d66v.apps.googleusercontent.com',
    iosBundleId: 'com.example.test01',
  );
}