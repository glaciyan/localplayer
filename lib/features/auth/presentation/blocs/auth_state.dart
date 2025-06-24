import '../../domain/entities/user_auth.dart';

abstract class AuthState {}

class AuthSignIn extends AuthState {}
class AuthSignUp extends AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class Registered extends AuthState {}
class FoundYou extends AuthState {}

class Authenticated extends AuthState {
  final UserAuth user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}