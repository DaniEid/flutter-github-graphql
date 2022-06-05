import 'inject_config.dart';

/// injecting app main dependencies so can be accessed from everywhere
class AppBinding {
  ///The starting point
  ///The order of the called function is important
  static Future<void> setupInjection() async {
    ///injectable and get it configuration
    configureDependencies();
  }
}
