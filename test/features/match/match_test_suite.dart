// This file imports and runs all match feature tests
// Run with: flutter test test/features/match/match_test_suite.dart

import 'presentation/blocs/match_event_test.dart' as match_event_test;
import 'presentation/blocs/match_state_test.dart' as match_state_test;
import 'presentation/blocs/match_bloc_test.dart' as match_bloc_test;

void main() {
  // Run all match tests
  match_event_test.main();
  match_state_test.main();
  match_bloc_test.main();
}
