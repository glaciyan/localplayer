import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:localplayer/features/auth/auth_module.dart';
import 'package:localplayer/features/auth/domain/interfaces/auth_controller_interface.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final IAuthController authController = AuthModule.provideController(
        context,
        context.read<AuthBloc>(),
      );
      authController.findMe();
    });

    SharedPreferences.getInstance().then((final SharedPreferences value) {
      final Object? token = value.get("token");
      if (token == null) {
        context.go('/sigup');
      } else {}
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: BlocListener<AuthBloc, AuthState>(
          listener: (final BuildContext context, final AuthState state) {
            if (state is FoundYou) {
              context.go('/map');
            } else if (state is Unauthenticated) {
              context.go('/signup');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please sign in to continue.')),
              );
            }
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset('assets/LocalPlayer.png', width: 160),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
}
