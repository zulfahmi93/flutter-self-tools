import 'dart:io';

mixin LogMixin {
  bool get verbose;

  void logInfo(String log) {
    print('[INFO]:    $log');
  }

  void logVerbose(String log) {
    if (verbose) {
      print('[VERBOSE]: $log');
    }
  }

  void logWarning(String log) {
    stderr.writeln('[WARNING]: $log');
  }

  void logFatal(String log) {
    stderr.writeln('[FATAL]:   $log');
  }
}
