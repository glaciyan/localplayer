import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    // TODO go to /signup if we do not have an id token
    // TODO if we have an id token try called /me and see if it is still valid

    SharedPreferences.getInstance().then((final SharedPreferences value) {
      final Object? token = value.get("token");
      if (token == null) {
        context.go('/sigup');
      } else {
        context.go('/map');
      }
    },);
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
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget> [
              Image.asset('assets/LocalPlayer.png', width: 160),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
}
