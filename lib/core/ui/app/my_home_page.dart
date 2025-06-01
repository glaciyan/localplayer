import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WithNavBar(
      selectedIndex: 0, // Home = first tab
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () => context.go("/swipe"),
                child: const Text('Swipes'),
              ),
              TextButton(
                onPressed: () => context.go("/feed"),
                child: const Text('Feed'),
              ),
              TextButton(
                onPressed: () => context.go("/profile"),
                child: const Text('Profile'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
