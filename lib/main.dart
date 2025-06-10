import 'package:prbal/app.dart';
import 'package:prbal/init/cache/onboarding/intro_caching.dart';
import 'package:prbal/init/cubit/theme_cubit.dart';
import 'package:prbal/init/cache/theme/theme_caching.dart';
import 'package:prbal/init/localization/project_locales.dart';
import 'package:prbal/cubit_observer.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/services/performance_service.dart';
import 'package:prbal/services/health_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'init/localization/localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Run app services in parallel
    await Future.wait([
      // Cache and locale initializations (can run in parallel)
      _initializeAppServices(),
      // Performance optimization
      PerformanceService.instance.optimizeStartup(),
    ]);

    // Set up BLoC observer and performance monitoring
    Bloc.observer = CubitObserver();
    await PerformanceService.instance.initializePerformanceMonitoring();
    PerformanceService.optimizeImageLoading();

    // Initialize health monitoring
    final healthService = HealthService();
    await healthService.initialize();

    runApp(
      ProviderScope(
        child: EasyLocalization(
          supportedLocales: LocaleVariables._localesList,
          path: LocaleVariables._localesPath,
          fallbackLocale: LocaleVariables._fallBackLocale,
          child: BlocProvider(
            create: (context) => ThemeCubit(),
            child: const MyApp(),
          ),
        ),
      ),
    );
  } catch (error) {
    // Fallback error handling
    debugPrint('App initialization error: $error');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
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
  await Future.wait([
    LocaleVariables._init(),
    ThemeCaching.init(),
    IntroCaching.init(),
    HiveService.init(),
  ]);
}
