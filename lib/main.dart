import 'package:soloforte_app/l10n/generated/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'core/config/env_config.dart';
import 'core/database/database_bootstrap.dart';

import 'core/error/global_error_handler.dart';
import 'core/router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'package:soloforte_app/core/services/logger_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

/// Inicializa o SQLite FFI para plataformas que necessitam (Web/Desktop).
/// Para mobile (iOS/Android), o sqflite nativo é usado diretamente.
///
/// IMPORTANTE: Esta função DEVE ser await para garantir que o databaseFactory
/// esteja completamente pronto antes de qualquer acesso ao banco.
Future<void> _initializeSQLiteFFI() async {
  if (kIsWeb) {
    // Web: usa IndexedDB via FFI Web
    databaseFactory = databaseFactoryFfiWeb;

    // Aguarda um frame para garantir que o factory está completamente pronto
    await Future.delayed(const Duration(milliseconds: 100));
  } else {
    // Desktop: verifica se é Windows, macOS ou Linux
    final platform = defaultTargetPlatform;
    if (platform == TargetPlatform.windows ||
        platform == TargetPlatform.macOS ||
        platform == TargetPlatform.linux) {
      // Desktop: usa SQLite FFI nativo
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

      // Aguarda um frame para garantir que o factory está completamente pronto
      await Future.delayed(const Duration(milliseconds: 100));
    }
    // Mobile (iOS/Android): não faz nada, sqflite nativo funciona diretamente
  }
}

Future<void> main() async {
  // Run app with error zone protection - all initialization must be inside
  GlobalErrorHandler.runAppGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Load environment variables
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      LoggerService.e('Error loading .env file', error: e, tag: 'INIT');
    }

    // Initialize SQLite FFI for Web/Desktop platforms
    await _initializeSQLiteFFI();

    // Mark SQLite as ready for use (gate de bootstrap)
    DatabaseBootstrap.markAsReady();

    // Initialize Firebase
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      LoggerService.w(
        'Firebase initialization failed (ignoring for development/unsupported platforms): $e',
        tag: 'INIT',
      );
    }

    // Initialize Supabase
    try {
      if (EnvConfig.useSupabase) {
        await Supabase.initialize(
          url: EnvConfig.supabaseUrl,
          anonKey: EnvConfig.supabaseAnonKey,
        );
      }
    } catch (e) {
      LoggerService.e('Supabase init failed', error: e, tag: 'INIT');
    }

    runApp(const ProviderScope(child: SoloForteApp()));
  });
}

class SoloForteApp extends ConsumerWidget {
  const SoloForteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerAsync = ref.watch(routerProvider);
    final appTheme = ref.watch(appThemeProvider);

    // Seleciona o tema baseado no enum AppTheme
    final theme = switch (appTheme) {
      AppTheme.avenue => AppThemeData.green(),
      AppTheme.dark => AppThemeData.dark(),
      AppTheme.cleanIOS => AppThemeData.blue(), // default: Clean iOS
    };

    return routerAsync.when(
      loading: () {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: const Scaffold(
            backgroundColor: Colors.blueAccent,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Iniciando aplicação...',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stack) {
        LoggerService.e(
          'Router initialization failed',
          error: error,
          stackTrace: stack,
          tag: 'INIT',
        );
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          // Force locale here too to be safe
          locale: const Locale('pt', 'BR'),
          home: const Scaffold(
            body: Center(child: Text('Erro ao inicializar aplicação')),
          ),
        );
      },
      data: (router) {
        return MaterialApp.router(
          title: 'SoloForte',
          debugShowCheckedModeBanner: false,
          theme: theme,
          // Force locale to prevent crash on non-supported system locales (e.g. en_US)
          locale: const Locale('pt', 'BR'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        );
      },
    );
  }
}
