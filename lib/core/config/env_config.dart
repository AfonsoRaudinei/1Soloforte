/// Environment Configuration
/// Manages API URLs and keys for different environments
class EnvConfig {
  // Development
  static const String devApiUrl = 'http://localhost:3000';
  static const String devApiKey = 'dev_key_12345';

  // Staging
  static const String stagingApiUrl = 'https://staging-api.soloforte.com';
  static const String stagingApiKey = 'staging_key_67890';

  // Production
  static const String prodApiUrl = 'https://api.soloforte.com';
  static const String prodApiKey = 'prod_key_secret';

  // Current environment (from --dart-define)
  static String get environment {
    return const String.fromEnvironment('ENV', defaultValue: 'dev');
  }

  // Current API URL
  static String get apiUrl {
    switch (environment) {
      case 'prod':
      case 'production':
        return prodApiUrl;
      case 'staging':
        return stagingApiUrl;
      case 'dev':
      case 'development':
      default:
        return devApiUrl;
    }
  }

  // Current API Key
  static String get apiKey {
    // Try to get from environment variable first
    const envApiKey = String.fromEnvironment('API_KEY');
    if (envApiKey.isNotEmpty) {
      return envApiKey;
    }

    // Fallback to environment-specific key
    switch (environment) {
      case 'prod':
      case 'production':
        return prodApiKey;
      case 'staging':
        return stagingApiKey;
      case 'dev':
      case 'development':
      default:
        return devApiKey;
    }
  }

  // Google API Key (for Maps, Geocoding, etc.)
  static String get googleApiKey {
    // Try to get from environment variable first
    const envGoogleApiKey = String.fromEnvironment('GOOGLE_API_KEY');
    if (envGoogleApiKey.isNotEmpty) {
      return envGoogleApiKey;
    }

    // Fallback to hardcoded key (should be overridden by environment variable in production)
    return 'AIzaSyB6W7iXI4xuNLQjQM7MvEm7oVlBBamAJb8';
  }

  static String get sentryDsn {
    return const String.fromEnvironment('SENTRY_DSN', defaultValue: '');
  }

  // Supabase Configuration
  static const String supabaseUrl = 'https://PLACEHOLDER.supabase.co';
  static const String supabaseAnonKey = 'PLACEHOLDER_KEY';

  // Flag to know if we should use Supabase (even if just for Settings)
  static bool get useSupabase => true;

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
      print('🔧 Environment Configuration:');
      print('   Environment: $environment');
      print('   API URL: $apiUrl');
      print('   API Key: ${apiKey.substring(0, 10)}...');
      print('   Debug Mode: $isDebug');
      print(
        '   Sentry DSN: ${sentryDsn.isNotEmpty ? "Configured" : "Not configured"}',
      );
    }
  }
}
