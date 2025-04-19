import 'package:logger/logger.dart';

class Log {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  static void info(message) {
    _logger.i(message);
  }

  static void warning(message) {
    _logger.w(message);
  }

  static void error(message) {
    _logger.e(message);
  }

  static void debug(message) {
    _logger.d(message);
  }
}
