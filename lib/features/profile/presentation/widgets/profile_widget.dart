import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/widgets/profile_card.dart';
import 'package:flutter/foundation.dart';
import 'package:localplayer/features/profile/domain/controllers/profile_controller.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_event.dart';


class ProfileWidget extends StatelessWidget {
  final ProfileWithSpotify profile;
  final VoidCallback onEdit;
  final VoidCallback onCreateSession;
  final bool hasSession;

  const ProfileWidget({
    super.key,
    required this.profile,
    required this.onEdit,
    required this.onCreateSession,
    required this.hasSession,
  });

  @override
  Widget build(final BuildContext context) {
    final ProfileController _profileController = ProfileController(
      context,
      (final ProfileEvent event) => context.read<ProfileBloc>().add(event),
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ProfileCard(profile: profile),
            ),

            Positioned(
              top: 12,
              right: 12,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.logout),
                    color: Colors.white,
                    tooltip: 'Logout',
                    onPressed: _profileController.signOut,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit, size: 28),
                        label: const Text(
                          "Edit Profile",
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(60),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onCreateSession,
                        icon: const Icon(Icons.play_arrow, size: 28),
                        label: Text(
                          hasSession ? 'Close Session' : 'Create Session',
                          style: const TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(60),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ProfileWithSpotify>('profile', profile));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onEdit', onEdit));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onCreateSession', onCreateSession));
    properties.add(DiagnosticsProperty<bool>('hasSession', hasSession));
  }
}
