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
    apiKey: 'AIzaSyCmwBKfIKCGJqZAI9my8qjXbDPCpfiOR-M',
    appId: '1:462027147690:web:37e9c6d633827382d083d3',
    messagingSenderId: '462027147690',
    projectId: 'olivia-bec5b',
    authDomain: 'olivia-bec5b.firebaseapp.com',
    storageBucket: 'olivia-bec5b.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDaH8BpoZjm6CBF9odCQogt9KXIo3rnZuA',
    appId: '1:462027147690:android:bbb6a8c6c936e70fd083d3',
    messagingSenderId: '462027147690',
    projectId: 'olivia-bec5b',
    storageBucket: 'olivia-bec5b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZ2C-10NbSmNxNmzkesnnwgtWR2lx2Bc4',
    appId: '1:462027147690:ios:5a63bc4e982ce576d083d3',
    messagingSenderId: '462027147690',
    projectId: 'olivia-bec5b',
    storageBucket: 'olivia-bec5b.firebasestorage.app',
    iosBundleId: 'com.example.feBarangHilang',
  );
}
