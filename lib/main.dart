import 'package:prbal/app.dart';
// import 'package:prbal/utils/cache/onboarding/intro_caching.dart' ;
import 'package:prbal/utils/cubit/theme_cubit.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
// import 'package:prbal/utils/theme/theme_caching.dart';
import 'package:prbal/utils/localization/project_locales.dart';
import 'package:prbal/utils/cubit/cubit_observer.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/services/performance_service.dart';
import 'package:prbal/services/health_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbal/utils/intro_caching.dart';
import 'package:prbal/utils/theme/theme_caching.dart';

part 'utils/localization/localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint('🚀 Starting Prbal app initialization...');

    // Set up BLoC observer for better debugging
    Bloc.observer = CubitObserver();

    // Run app services in parallel for faster startup
    await _initializeAppServices().then((_) {
      debugPrint('🚀 All services initialized successfully');

      // Log localization status before starting app
      LocaleVariables.logLocalizationStatus();

      runApp(
        ProviderScope(
          child: EasyLocalization(
            supportedLocales: LocaleVariables.supportedLocales,
            path: LocaleVariables.localesPath,
            fallbackLocale: LocaleVariables.fallbackLocale,
            child: BlocProvider(
              create: (context) => ThemeCubit(),
              child: const MyApp(),
            ),
          ),
        ),
      );
    });
  } catch (error) {
    // Fallback error handling
    debugPrint('❌ App initialization error: $error');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Prbal.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Failed to initialize app',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Restart the app
                    main();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Parallel initialization of app services
Future<void> _initializeAppServices() async {
  debugPrint('📦 Initializing app services...');
  await Future.wait([
    LocaleVariables._init(),
    ThemeCaching.init(),
    IntroCaching.init(),
    HiveService.init(),
  ]);

  debugPrint('🏥 Initializing performance and health monitoring...');

  // Initialize performance service first
  await PerformanceService.instance.initializePerformanceMonitoring();

  // Optimize image loading
  PerformanceService.optimizeImageLoading();

  // Initialize health monitoring service (but don't perform check here)
  // The splash screen will handle health checking with proper caching
  final healthService = HealthService();
  await healthService.initialize();

  debugPrint('🏥 Performance and health monitoring ready');
  debugPrint(
      '🏥 Note: Health checks will be performed on splash screen with caching');
  debugPrint('📦 App services initialized');
}
