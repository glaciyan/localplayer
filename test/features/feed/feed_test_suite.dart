// This file imports and runs all feed feature tests
// Run with: flutter test test/features/feed/feed_test_suite.dart

import 'domain/models/notification_model_test.dart' as notification_model_test;
import 'presentation/blocs/feed_event_test.dart' as feed_event_test;
import 'presentation/blocs/feed_state_test.dart' as feed_state_test;
import 'presentation/blocs/feed_bloc_test.dart' as feed_bloc_test;

void main() {
  // Run all feed tests
  notification_model_test.main();
  feed_event_test.main();
  feed_state_test.main();
  feed_bloc_test.main();
} 