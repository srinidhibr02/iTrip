import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itrip/app.dart';
import 'package:itrip/core/constants/app_constants.dart';

/// App initialization — Firebase, Hive, env, error handling.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Load environment variables (optional)
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env is optional for development
  }

  // Initialize Firebase
  try {
    // Uncomment after running: flutterfire configure
    // import 'package:itrip/firebase_options.dart';
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await Firebase.initializeApp();
    if (!kDebugMode) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }
  } catch (e) {
    debugPrint('Firebase init skipped (add config files): $e');
  }

  // Initialize Hive for offline caching
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.tripsBox);
  await Hive.openBox(AppConstants.routesBox);
  await Hive.openBox(AppConstants.settingsBox);

  runApp(
    const ProviderScope(
      child: ITripApp(),
    ),
  );
}
