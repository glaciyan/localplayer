import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_event.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_state.dart';
import 'package:localplayer/features/profile/presentation/widgets/editable_profile_card.dart';
import 'package:localplayer/features/profile/presentation/widgets/editable_profile_widget.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_state.dart' as profile_state;

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final GlobalKey<EditableProfileCardState> _cardKey = GlobalKey();

  @override
  Widget build(final BuildContext context) => WithNavBar(
      selectedIndex: 3,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (final BuildContext context, final ProfileState state) {

          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return BlocListener<ProfileBloc, ProfileState>(
              listener: (final BuildContext context, final ProfileState state) {
                if (state is profile_state.ProfileUpdateSuccess) {
                  context.pop();
                } 
              },
              child: EditableProfileWidget(
                profile: state.profile,
                cardKey: _cardKey,
                onSave: () {
                  final ProfileWithSpotify? updated = _cardKey.currentState?.getUpdatedProfile();
                  if (updated != null) {
                    context.read<ProfileBloc>().add(UpdateProfile(updated));
                  }
                },
              ),
            );
          } else {
            return const Center(child: Text('Failed to load profile.'));
          }
        },
      ),
    );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<GlobalKey<EditableProfileCardState>>.has('_cardKey', _cardKey));
  }
}
