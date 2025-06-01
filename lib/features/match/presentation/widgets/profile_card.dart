import 'package:flutter/material.dart';
import 'package:localplayer/features/match/domain/entities/UserProfile.dart';

class ProfileCard extends StatelessWidget {
  final UserProfile profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(profile.imageUrl, fit: BoxFit.cover),
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${profile.name}, ${profile.age}',
                      style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text(profile.description,
                      style: const TextStyle(
                          fontSize: 16, color: Colors.white70)),
                  Text(profile.location,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.white54)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
