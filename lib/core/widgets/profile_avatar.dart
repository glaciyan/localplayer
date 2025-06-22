import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('avatarLink', avatarLink));
    properties.add(ColorProperty('color', color));
    properties.add(DoubleProperty('scale', scale));
  }

  
  @override
  Widget build(final BuildContext context) => Container(
      width: 100 * scale,
      height: 100 * scale,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(4),
      child: ClipOval(
        child: AspectRatio(
          aspectRatio: 1,
          child: avatarLink.isEmpty
              ? const Icon(Icons.person, size: 40, color: Colors.white)
              : Image.network(
                  avatarLink,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person_off, size: 40, color: Colors.white);
                  },
                ),
        ),
      ),
    );
}
