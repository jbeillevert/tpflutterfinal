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
    apiKey: 'AIzaSyDLVryEtYUlIXwFjXoM7KK3dE3ZVmR0xtI',
    appId: '1:630738819394:web:ddaa41d300bce3c3d790db',
    messagingSenderId: '630738819394',
    projectId: 'flutter-final-notes',
    authDomain: 'flutter-final-notes.firebaseapp.com',
    storageBucket: 'flutter-final-notes.appspot.com',
    measurementId: 'G-7NQ59NPW2D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBXPTusThonIDn3YAuC1yhEhx8SCStu_g',
    appId: '1:630738819394:android:51d59d171b6fba7dd790db',
    messagingSenderId: '630738819394',
    projectId: 'flutter-final-notes',
    storageBucket: 'flutter-final-notes.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBuCQgag10rSszEWm7iQ88V4yFszkMZDqU',
    appId: '1:630738819394:ios:4e9903fa0ac7b92fd790db',
    messagingSenderId: '630738819394',
    projectId: 'flutter-final-notes',
    storageBucket: 'flutter-final-notes.appspot.com',
    iosBundleId: 'com.example.tpFlutterFinal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBuCQgag10rSszEWm7iQ88V4yFszkMZDqU',
    appId: '1:630738819394:ios:8c114c0cbdfb4569d790db',
    messagingSenderId: '630738819394',
    projectId: 'flutter-final-notes',
    storageBucket: 'flutter-final-notes.appspot.com',
    iosBundleId: 'com.example.tpFlutterFinal.RunnerTests',
  );
}
