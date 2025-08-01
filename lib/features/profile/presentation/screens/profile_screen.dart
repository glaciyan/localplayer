import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:localplayer/core/services/spotify/data/services/spotify_audio_service.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_state.dart';
import 'package:localplayer/features/profile/presentation/blocs/profile_event.dart';
import 'package:localplayer/features/profile/presentation/widgets/profile_widget.dart';
import 'package:localplayer/features/session/domain/interfaces/session_controller_interface.dart';
import 'package:localplayer/features/session/presentation/blocs/session_bloc.dart';
import 'package:localplayer/features/session/presentation/blocs/session_state.dart';
import 'package:localplayer/features/session/session_module.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(LoadProfile());
    });
  }

 @override
  void dispose() {
    SpotifyAudioService().stop();
    super.dispose();
  }
    @override
    Widget build(final BuildContext context) => WithNavBar(
        selectedIndex: 3,
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (final BuildContext context, final ProfileState state) {
            if (state is ProfileSignedOut) {
              context.go('/signup');
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to load profile.'),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is! ProfileLoaded &&
                      state is! ProfileLoading &&
                      state is! ProfileSignedOut) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('An unknown error occurred.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (final BuildContext context, final ProfileState state) {
              if (state is ProfileLoading) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (state is ProfileLoaded) {
                return BlocBuilder<SessionBloc, SessionState>(
                  builder: (final BuildContext context, final SessionState sessionState) {
                    final ISessionController sessionController = SessionModule.provideController(
                      context,
                      context.read<SessionBloc>(),
                    );
                    final bool hasSession = sessionState is SessionActive;

                    return Scaffold(
                      body: SafeArea(
                        child: ProfileWidget(
                          profile: state.profile,
                          hasSession: hasSession,
                          onEdit: () {
                            context.push('/profile/edit');
                          },
                          onCreateSession: () {
                            if (sessionState is SessionActive) {
                              sessionController.closeSession(sessionState.session.id);
                            } else {
                              final LatLng pos = state.profile.user.position;
                              sessionController.createSession(
                                pos.latitude,
                                pos.longitude,
                                "${state.profile.user.displayName}'s Session",
                                true,
                              );
                            }
                            context.read<ProfileBloc>().add(LoadProfile());
                          },
                        ),
                      ),
                    );
                  },
                );
              } else if (state is ProfileError) {
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          "Failed to load profile",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<ProfileBloc>().add(LoadProfile());
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Scaffold(
                  body: Center(child: Text("Unknown error")),
                );
              }
            },
          ),
        ),
      );
}
