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
          child: (avatarLink.isNotEmpty)
              ? Image.network(
                  avatarLink,
                  fit: BoxFit.cover,
                  loadingBuilder: (final BuildContext context, final Widget child, final ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                  },
                  errorBuilder: (final BuildContext context, final Object error, final StackTrace? stackTrace) => const Icon(Icons.person_off, size: 40, color: Colors.white),
                )
              : const Icon(Icons.person, size: 40, color: Colors.white),
        ),
      ),
    );
}
