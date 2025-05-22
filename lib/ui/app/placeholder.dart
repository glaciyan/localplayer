import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Placeholder extends StatelessWidget {
  const Placeholder({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // widget contains the fields from MyHomePage
        title: Text(title),
      ),
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
