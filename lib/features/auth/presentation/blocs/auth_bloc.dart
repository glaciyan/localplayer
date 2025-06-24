import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/features/auth/data/IAuthRepository.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_event.dart';
import '../../domain/entities/user_auth.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository authRepository;

  AuthBloc({
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<AuthLoadingEvent>(_onAuthLoading);
    on<AuthSuccessEvent>(_onAuthSuccess);
    on<AuthFailureEvent>(_onAuthFailure);
    on<AuthRegisteredEvent>(_onRegisterSuccess);
  }

  Future<void> _onSignInRequested(final SignInRequested event, final Emitter<AuthState> emit) async {
    add(AuthLoadingEvent());
    try {
      await authRepository.signIn(event.name, event.password);
      add(AuthSuccessEvent(UserAuth(id: '', name: event.name, token: '')));
    } catch (e) {
      add(AuthFailureEvent(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(final SignUpRequested event, final Emitter<AuthState> emit) async {
    add(AuthLoadingEvent());
    try {
      await authRepository.signUp(event.name, event.password);
      add(AuthRegisteredEvent());
    } catch (e) {
      add(AuthFailureEvent(e.toString()));
    }
  }

  void _onAuthLoading(final AuthLoadingEvent event, final Emitter<AuthState> emit) {
    emit(AuthLoading());
  }

  void _onAuthSuccess(final AuthSuccessEvent event, final Emitter<AuthState> emit) {
    emit(Authenticated(event.user));
  }

  void _onRegisterSuccess(final AuthRegisteredEvent event, final Emitter<AuthState> emit) {
    emit(Registered());
  }

  void _onAuthFailure(final AuthFailureEvent event, final Emitter<AuthState> emit) {
    emit(Unauthenticated());
  }
}