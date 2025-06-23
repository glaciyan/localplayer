import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_state.dart';
import 'package:localplayer/features/profile/presentation/widgets/profile_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(final BuildContext context) => WithNavBar(
      selectedIndex: 3,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (final BuildContext context, final ProfileState state) {
          if (state is ProfileLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProfileLoaded) {
            return Scaffold(
              body: SafeArea(
                child: ProfileWidget(
                  profile: state.profile,
                  onEdit: () {
                    context.push('/profile/edit');
                },
                  onCreateSession: () {
                    // TODO: Hook this up to session creation logic
                  },
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(child: Text("Failed to load profile")),
            );
          }
        },
      ),
    );
}
