import '../../domain/entities/user_auth.dart';

abstract class AuthEvent {}

class SignInRequested extends AuthEvent {
  final String name;
  final String password;
  SignInRequested(this.name, this.password);
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String password;
  SignUpRequested(this.name, this.password);
}

class SignOutRequested extends AuthEvent {}

class AuthLoadingEvent extends AuthEvent {}

class AuthRegisteredEvent extends AuthEvent {}

class AuthSuccessEvent extends AuthEvent {
  final UserAuth user;
  AuthSuccessEvent(this.user);
}

class AuthFailureEvent extends AuthEvent {
  final String message;
  AuthFailureEvent(this.message);
}