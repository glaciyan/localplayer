import 'package:flutter/material.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/widgets/profile_avatar.dart';
import 'package:flutter/foundation.dart';

class AvatarSection extends StatelessWidget {
  final ProfileWithSpotify profile;

  const AvatarSection({super.key, required this.profile});

  @override
  Widget build(final BuildContext context) => Row(
      children: <Widget> [
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

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ProfileWithSpotify>('profile', profile));
  }
}
