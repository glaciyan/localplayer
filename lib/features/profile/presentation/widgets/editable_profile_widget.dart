import 'package:flutter/material.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/profile/presentation/widgets/editable_profile_card.dart';
import 'package:flutter/foundation.dart';

class EditableProfileWidget extends StatelessWidget {
  final ProfileWithSpotify profile;
  final GlobalKey<EditableProfileCardState> cardKey;
  final VoidCallback onSave;

  const EditableProfileWidget({
    super.key,
    required this.profile,
    required this.cardKey,
    required this.onSave,
  });

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ProfileWithSpotify>('profile', profile, ifPresent: 'has profile'));
    properties.add(ObjectFlagProperty<GlobalKey<EditableProfileCardState>>('cardKey', cardKey, ifPresent: 'has cardKey'));
    properties.add(ObjectFlagProperty<VoidCallback>('onSave', onSave, ifPresent: 'has onSave'));
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // Fullscreen editable profile card
            Positioned.fill(
              child: EditableProfileCard(
                key: cardKey,
                profile: profile,
              ),
            ),

            // Top-right overlay buttons (logout + save)
            Positioned(
              top: 12,
              right: 12,
              child: Row(
                children: <Widget> [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    color: Colors.white,
                    tooltip: 'Logout',
                    onPressed: () {
                      // TODO: Implement logout
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logout tapped')),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Bottom save button
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child:       Expanded(
                child: ElevatedButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.edit, size: 28),
                  label: const Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(60),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
