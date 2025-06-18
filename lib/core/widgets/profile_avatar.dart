import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String avatarLink;
  final Color color;
  final double scale;


  const ProfileAvatar({
    super.key,
    this.scale = 1,
    required this.avatarLink,
    required this.color,
  });

  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100 * scale,
      height: 100 * scale,
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
            transform: Matrix4.rotationX(0.1),            
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