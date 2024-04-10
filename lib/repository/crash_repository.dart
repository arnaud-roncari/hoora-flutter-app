import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashRepository {
  final FirebaseCrashlytics _instance = FirebaseCrashlytics.instance;

  Future<void> report(dynamic exception, StackTrace stack) async {
    await _instance.recordError(exception, stack, fatal: true);
  }
}
