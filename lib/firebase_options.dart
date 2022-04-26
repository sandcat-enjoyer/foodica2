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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBAPQbuKyN3YNkW4gIgHPhK3eIc4qsWeJ4',
    appId: '1:828152655111:android:fa02625635905eb7a329a2',
    messagingSenderId: '828152655111',
    projectId: 'foodica-9743c',
    databaseURL: 'https://foodica-9743c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'foodica-9743c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD3DiGFaL2pUR_KRatKs9lh7rADF12NisA',
    appId: '1:828152655111:ios:0929b4bb8c1913b2a329a2',
    messagingSenderId: '828152655111',
    projectId: 'foodica-9743c',
    databaseURL: 'https://foodica-9743c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'foodica-9743c.appspot.com',
    androidClientId: '828152655111-c5f1h8eimmugohlmj3oihuq1s3s96aug.apps.googleusercontent.com',
    iosClientId: '828152655111-kqh94ul6shb2onndssg9bnivohnbn0te.apps.googleusercontent.com',
    iosBundleId: 'com.julesdebbaut.foodica',
  );
}