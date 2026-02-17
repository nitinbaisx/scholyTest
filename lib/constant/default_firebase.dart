import 'package:schooly/constant/export_utils.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (Platform.isIOS || Platform.isMacOS) {
      return ios;
    } else if (Platform.isAndroid) {
      return android;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static FirebaseOptions ios = const FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    storageBucket: '',
    iosBundleId: '',
  );

  static FirebaseOptions android = const FirebaseOptions(
    apiKey: 'AIzaSyDqQnDTfKwrULfP8Mu-0G4gSk1_h-TWmm0',
    appId: '1:677843952085:android:10c173aab7e2309a801d5c',
    messagingSenderId: '677843952085',
    projectId: 'schooly-b6294',
  );
}
