import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:soloforte_app/core/services/logger_service.dart';

/// Environment Configuration
/// Manages API URLs and keys for different environments
class EnvConfig {
  // Current environment (from .env or --dart-define)
  static String get environment {
    return dotenv.get(
      'ENV',
      fallback: const String.fromEnvironment('ENV', defaultValue: 'dev'),
    );
  }

  // Current API URL
  static String get apiUrl {
    return dotenv.get('API_URL', fallback: 'http://localhost:3000');
  }

  // Current API Key
  static String get apiKey {
    return dotenv.get('API_KEY', fallback: 'dev_key_12345');
  }

  // Google API Key (for Maps, Geocoding, etc.)
  static String get googleApiKey {
    return dotenv.get('GOOGLE_API_KEY', fallback: '');
  }

  static String get sentryDsn {
    return dotenv.get('SENTRY_DSN', fallback: '');
  }

  // Supabase Configuration
  static String get supabaseUrl =>
      dotenv.get('SUPABASE_URL', fallback: 'https://PLACEHOLDER.supabase.co');
  static String get supabaseAnonKey =>
      dotenv.get('SUPABASE_ANON_KEY', fallback: 'PLACEHOLDER_KEY');

  // Flag to know if we should use Supabase
  static bool get useSupabase {
    final use = dotenv.get('USE_SUPABASE', fallback: 'true');
    return use.toLowerCase() == 'true';
  }

  // Debug mode
  static bool get isDebug {
    return environment == 'dev' || environment == 'development';
  }

  // Production mode
  static bool get isProduction {
    return environment == 'prod' || environment == 'production';
  }

  // Print current configuration (for debugging)
  static void printConfig() {
    if (isDebug) {
      LoggerService.d('Environment: $environment');
      LoggerService.d('API URL: $apiUrl');
      LoggerService.d('Use Supabase: $useSupabase');
    }
  }
}
