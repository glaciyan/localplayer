// This file imports and runs all profile feature tests
// Run with: flutter test test/features/profile/profile_test_suite.dart

import 'presentation/blocs/profile_event_test.dart' as profile_event_test;
import 'presentation/blocs/profile_state_test.dart' as profile_state_test;
import 'presentation/blocs/profile_bloc_test.dart' as profile_bloc_test;

void main() {
  // Run all profile tests
  profile_event_test.main();
  profile_state_test.main();
  profile_bloc_test.main();
}
