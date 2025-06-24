import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/features/auth/data/IAuthRepository.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository authRepository;

  AuthBloc({
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
  }

  Future<dynamic> _onSignInRequested(final SignInRequested event, final Emitter<AuthState> emit) async => await authRepository.signIn(event.name, event.password);

  Future<dynamic> _onSignUpRequested(final SignUpRequested event, final Emitter<AuthState> emit) async => await authRepository.signUp(event.name, event.password);
}