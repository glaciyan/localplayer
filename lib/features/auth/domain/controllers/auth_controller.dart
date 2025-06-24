import 'package:flutter/material.dart';
import 'package:localplayer/features/auth/domain/interfaces/auth_controller_interface.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_event.dart';

class AuthController implements IAuthController {
  final BuildContext context;
  final Function(AuthEvent) addEvent;

  AuthController(this.context, this.addEvent);

  @override
  Future<dynamic> signIn(final String name, final String password) async {
    addEvent(SignInRequested(name, password));
  }
  
  @override
  Future<dynamic> signUp(final String name, final String password) async {
    addEvent(SignUpRequested(name, password));
  }
}