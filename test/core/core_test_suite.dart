// This file imports and runs all core tests
// Run with: flutter test test/core/core_test_suite.dart

import 'entities/hex_color_test.dart' as hex_color_test;
import 'entities/profile_with_spotify_test.dart' as profile_with_spotify_test;
import 'network/api_error_exception_test.dart' as api_error_exception_test;
import 'network/no_connection_exception_test.dart' as no_connection_exception_test;
import 'services/toast_service_test.dart' as toast_service_test;
import 'go_router/router_test.dart' as router_test;

void main() {
  // Run all core tests
  hex_color_test.main();
  profile_with_spotify_test.main();
  api_error_exception_test.main();
  no_connection_exception_test.main();
  toast_service_test.main();
  router_test.main();
}
