// This file imports and runs all session feature tests
// Run with: flutter test test/features/session/session_test_suite.dart

import 'presentation/blocs/session_event_test.dart' as session_event_test;
import 'presentation/blocs/session_state_test.dart' as session_state_test;
import 'presentation/blocs/session_bloc_test.dart' as session_bloc_test;

void main() {
  // Run all session tests
  session_event_test.main();
  session_state_test.main();
  session_bloc_test.main();
}
