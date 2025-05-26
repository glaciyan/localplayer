import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String avatarLink;
  final Color color;

  const ProfileAvatar({
    super.key,
    required this.avatarLink,
    required this.color,
  });

  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(4),
      child: ClipOval(
        child: AspectRatio(
          aspectRatio: 1,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationX(3.14159),
            child: Image.network(
              avatarLink,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );  
  }
}