import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/features/auth/auth_module.dart';
import 'package:localplayer/features/auth/domain/interfaces/auth_controller_interface.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:localplayer/features/auth/presentation/blocs/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  final TextEditingController userHandleController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

    @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<TextEditingController>('userHandleController', userHandleController, ifPresent: 'has userHandleController'));
    properties.add(ObjectFlagProperty<TextEditingController>('passwordController', passwordController, ifPresent: 'has passwordController'));
    properties.add(FlagProperty('_isLoading', value: _isLoading, ifTrue: 'loading'));
  }

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    userHandleController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final IAuthController authController = AuthModule.provideController(context, context.read<AuthBloc>());
    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget> [
                    Image.asset('assets/LocalPlayer.png', width: 160),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: TextField(
                        controller: userHandleController,
                        decoration: const InputDecoration(labelText: 'username'),
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(labelText: 'password'),
                        obscureText: true,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () async {
                          setState(() {
                            _isLoading = true;
                          });

                          await authController.signUp(userHandleController.text, passwordController.text);

                          // try {
                          //   // context.go('/map');
                          // } on DioException catch(e) {
                          //   Fluttertoast.showToast(
                          //     msg: "Failed to create account" + (e.message ?? ""),
                          //     toastLength: Toast.LENGTH_LONG,
                          //     gravity: ToastGravity.BOTTOM,
                          //     timeInSecForIosWeb: 3,
                          //     backgroundColor: Colors.black54,
                          //     textColor: Colors.white,
                          //     fontSize: 16.0
                          //   );
                          // } finally {
                          //   setState(() {
                          //     _isLoading = false;
                          //   });
                          // }
                        },
                        child: _isLoading 
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : (context.read<AuthBloc>().state is AuthSignIn)
                            ? Text('Login', style: Theme.of(context).textTheme.titleLarge)
                            : Text('Register', style: Theme.of(context).textTheme.titleLarge),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}