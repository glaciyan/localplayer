// This file imports and runs all auth feature tests
// Run with: flutter test test/features/auth/auth_test_suite.dart

import 'domain/entities/user_auth_test.dart' as user_auth_test;
import 'domain/entities/login_token_test.dart' as login_token_test;
import 'presentation/blocs/auth_event_test.dart' as auth_event_test;
import 'presentation/blocs/auth_state_test.dart' as auth_state_test;
import 'data/repositories/auth_repository_test.dart' as auth_repository_test;
import 'data/datasources/auth_remote_data_source_test.dart' as auth_data_source_test;
import 'presentation/blocs/auth_bloc_test.dart' as auth_bloc_test;

void main() {
  // Run all auth tests
  user_auth_test.main();
  login_token_test.main();
  auth_event_test.main();
  auth_state_test.main();
  auth_repository_test.main();
  auth_data_source_test.main();
  auth_bloc_test.main();
} 