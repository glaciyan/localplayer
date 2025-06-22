import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:localplayer/core/entities/profile_with_spotify.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_block.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_event.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_state.dart';
import 'package:localplayer/features/profile/presentation/widgets/editable_profile_card.dart';


class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final GlobalKey<EditableProfileCardState> _cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WithNavBar(
      selectedIndex: 3,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return Column(
              children: [
                // Editable content
                Expanded(
                  child: EditableProfileCard(
                    key: _cardKey,
                    profile: state.profile,
                  ),
                ),

                // Sticky save button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final updated = _cardKey.currentState?.getUpdatedProfile();
                          if (updated != null) {
                            context.read<ProfileBloc>().add(UpdateProfile(updated));
                            context.pop(); // go back to profile screen
                          }
                        },
                        child: const Text('Save Profile'),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('Failed to load profile.'));
          }
        },
      ),
    );
  }
}
