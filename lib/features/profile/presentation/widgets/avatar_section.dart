import 'package:flutter/material.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/widgets/profile_avatar.dart';

class AvatarSection extends StatelessWidget {
  final ProfileWithSpotify profile;

  const AvatarSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(
          avatarLink: profile.user.avatarLink,
          color: profile.user.color ?? Colors.white,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(profile.user.location, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
