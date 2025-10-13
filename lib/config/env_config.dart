import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static Future<void> load() async {
    // Detect which env to load from build-time define
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');

    String fileName;
    switch (env) {
      case 'dev':
        fileName = '.env.dev';
        break;
      case 'staging':
        fileName = '.env.staging';
        break;
      case 'prod':
      default:
        fileName = '.env.prod';
    }

    await dotenv.load(fileName: fileName);
    print("✅ Loaded environment: $fileName");
  }

  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static bool get enableLogging => dotenv.env['ENABLE_LOGGING'] == 'true';
  static String get environment => dotenv.env['ENV'] ?? 'production';
}
