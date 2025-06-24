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