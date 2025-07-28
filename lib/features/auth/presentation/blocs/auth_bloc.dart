import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localplayer/features/auth/data/IAuthRepository.dart';
import 'package:localplayer/features/auth/domain/entities/login_token.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localplayer/core/network/no_connection_exception.dart';
import 'package:localplayer/core/services/geolocator/geolocator_interface.dart';
import 'package:localplayer/core/services/presence/presence_interface.dart';
import '../../domain/entities/user_auth.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository authRepository;
  final IGeolocatorService geolocatorService;
  final IPresenceService presenceService;

  AuthBloc({
    required this.authRepository,
    required this.geolocatorService,
    required this.presenceService,
  }) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<AuthLoadingEvent>(_onAuthLoading);
    on<AuthSuccessEvent>(_onAuthSuccess);
    on<AuthFailureEvent>(_onAuthFailure);
    on<AuthRegisteredEvent>(_onRegisterSuccess);
    on<FindMeRequested>(_onFindMeRequested);
    on<FoundYouEvent>(_onFoundYou);
  }

  Future<void> _onSignInRequested(final SignInRequested event, final Emitter<AuthState> emit) async {
    add(AuthLoadingEvent());
    try {
      // Get current location
      print('🔍 Getting current location...');
      final Position position = await geolocatorService.getCurrentLocation();
      print(' Location obtained: ${position.latitude}, ${position.longitude}');
      
      // Sign in FIRST
      print('🔐 Proceeding with sign in...');
      final Map<String, dynamic> result = await authRepository.signIn(event.name, event.password);
      final LoginToken loginToken = LoginToken.fromJson(result);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", loginToken.token);
      print('✅ Sign in completed successfully');
      
      // THEN update presence (now we have the token)
      print('📡 Updating presence with location...');
      
      print('📍 Old location: [will be fetched from backend]');
      print('📍 New location: ${position.latitude}, ${position.longitude}');
      await presenceService.updateLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        fakingRadiusMeters: 100.0,
      );
      print('✅ Presence updated successfully');
      
      // Store user's location for map initialization
      prefs.setDouble('user_latitude', position.latitude);
      prefs.setDouble('user_longitude', position.longitude);
      print('📍 Stored user location: ${position.latitude}, ${position.longitude}');

      add(AuthSuccessEvent(UserAuth(id: '', name: event.name, token: '')));
    } catch (e) {
      print('❌ Error during sign in: $e');
      add(AuthFailureEvent(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(final SignUpRequested event, final Emitter<AuthState> emit) async {
    add(AuthLoadingEvent());
    try {
      await authRepository.signUp(event.name, event.password);
      add(AuthRegisteredEvent());
    } on NoConnectionException {
      add(AuthFailureEvent('No internet connection, please check again later'));
    } catch (e) {
      add(AuthFailureEvent(e.toString()));
    }
  }

  Future<void> _onFindMeRequested(final FindMeRequested event, final Emitter<AuthState> emit) async {
    add(AuthLoadingEvent());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final Object? token = prefs.get("token");
      if (token == null && !(token is String)) {
        add(AuthFailureEvent("invalid token"));
      } else {
        await authRepository.findMe(token as String);
        add(FoundYouEvent());
      }
    } on NoConnectionException {
      add(AuthFailureEvent('No internet connection'));
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
    emit(AuthError(event.message));
  }

  void _onFoundYou(final FoundYouEvent event, final Emitter<AuthState> emit) {
    emit(FoundYou());
  }
}