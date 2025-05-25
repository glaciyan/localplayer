import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});
  
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('Test Band'),
              subtitle: Text('Test Band Description'),
            )
          ],
        )
      )
    );
  }
} 