// This file imports and runs all map feature tests
// Run with: flutter test test/features/map/map_test_suite.dart

import 'presentation/blocs/map_event_test.dart' as map_event_test;
import 'presentation/blocs/map_state_test.dart' as map_state_test;
import 'presentation/blocs/map_bloc_test.dart' as map_bloc_test;

void main() {
  // Run all map tests
  map_event_test.main();
  map_state_test.main();
  map_bloc_test.main();
} 