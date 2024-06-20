import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'firebase_options_staging.dart' as staging;
import 'firebase_options_production.dart' as production;

class FirebaseOptionsLoader {
  static FirebaseOptions get currentPlatform {
    if (kReleaseMode) {
      // Production
      return production.DefaultFirebaseOptions.currentPlatform;
    } else {
      // Staging or other non-production flavors
      return staging.DefaultFirebaseOptions.currentPlatform;
    }
  }
}