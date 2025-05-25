import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            TextButton(
              onPressed: () => context.go("/"),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}