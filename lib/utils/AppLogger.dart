import 'package:logger/logger.dart';

/// No preety
class AppLogger {
  final logger = Logger(printer: PrettyPrinter(methodCount: 0, colors: true));

  AppLogger() {
    // Set the log level to info (default is Level.debug)
  }

  void logInfo(String message) {
    logger.i('INFO: $message');
  }

  void logWarning(String message) {
    logger.w('WARNING: $message');
  }

  void logError(String message, dynamic error) {
    logger.e('ERROR: $message', error: error);
  }

  void logCustom(String level, String message) {
    switch (level) {
      case 'debug':
        logger.d(message);
        break;
      case 'info':
        logger.i(message);
        break;
      case 'error':
        logger.e(message);
        break;
      default:
        logger.d(message);
    }
  }
}
