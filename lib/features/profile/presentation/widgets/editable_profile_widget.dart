import 'package:flutter/material.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/features/profile/domain/controllers/profile_controller.dart';
import 'package:localplayer/features/profile/presentation/widgets/editable_profile_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_event.dart';

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
    properties.add(ObjectFlagProperty<ProfileWithSpotify>.has('profile', profile));
    properties.add(ObjectFlagProperty<GlobalKey<EditableProfileCardState>>.has('cardKey', cardKey));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onSave', onSave));
  }

  @override
  Widget build(final BuildContext context) {
    final ProfileController _profileController = ProfileController(
      context,
      (final ProfileEvent event) => context.read<ProfileBloc>().add(event),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: EditableProfileCard(
                  key: cardKey,
                  profile: profile,
                ),
              ),

              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final ProfileWithSpotify? updatedProfile = cardKey.currentState?.getUpdatedProfile();
                      
                      if (updatedProfile != null) {
                        _profileController.updateProfile(updatedProfile);
                      }
                    },
                    icon: const Icon(Icons.edit, size: 28),
                    label: Text(
                      "Save Changes",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
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
      ),
    );
  }
}
