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
    apiKey: 'AIzaSyC-ur2q6jKn0kbJi7Tct0n-I67KevrT07g',
    appId: '1:658563042958:web:5521bc9614445b66e703df',
    messagingSenderId: '658563042958',
    projectId: 'quizapp-7d724',
    authDomain: 'quizapp-7d724.firebaseapp.com',
    storageBucket: 'quizapp-7d724.firebasestorage.app',
    measurementId: 'G-VYMP32P78Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC3LBuiYk-0_6j76uUSF7tnS-USSFJd49g',
    appId: '1:658563042958:android:9be68bbc7960a1f0e703df',
    messagingSenderId: '658563042958',
    projectId: 'quizapp-7d724',
    storageBucket: 'quizapp-7d724.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBc16xzFHufuppFtXkgDZ0n5BQ90dBRxrY',
    appId: '1:658563042958:ios:4f018c1f6359624ee703df',
    messagingSenderId: '658563042958',
    projectId: 'quizapp-7d724',
    storageBucket: 'quizapp-7d724.firebasestorage.app',
    iosBundleId: 'com.example.quizApp',
  );
}
