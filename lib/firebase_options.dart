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
    apiKey: 'AIzaSyBq1Z_VAHqy4c0lEzDZlaBssSET-yl-Hyk',
    appId: '1:1051409231134:web:ce212cdf2a703758712d0f',
    messagingSenderId: '1051409231134',
    projectId: 'lista-compras-23ae2',
    authDomain: 'lista-compras-23ae2.firebaseapp.com',
    databaseURL: 'https://lista-compras-23ae2-default-rtdb.firebaseio.com',
    storageBucket: 'lista-compras-23ae2.appspot.com',
    measurementId: 'G-MC23EW7FJ7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBGsVYfbarm1Cr2sWO7Q5oW0wBaAgVInXw',
    appId: '1:1051409231134:android:42271bedce9d72cc712d0f',
    messagingSenderId: '1051409231134',
    projectId: 'lista-compras-23ae2',
    databaseURL: 'https://lista-compras-23ae2-default-rtdb.firebaseio.com',
    storageBucket: 'lista-compras-23ae2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5pWhjgLtYSD7OJ9s8lv4zrUz7b_nkIy4',
    appId: '1:1051409231134:ios:035c76d6ec53c773712d0f',
    messagingSenderId: '1051409231134',
    projectId: 'lista-compras-23ae2',
    databaseURL: 'https://lista-compras-23ae2-default-rtdb.firebaseio.com',
    storageBucket: 'lista-compras-23ae2.appspot.com',
    iosClientId: '1051409231134-brki32na8ltph62an171frku4p0lbdmv.apps.googleusercontent.com',
    iosBundleId: 'com.example.listaCompras',
  );
}