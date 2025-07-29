import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
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
    // Trigger profile reload when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(LoadProfile());
    });
  }

  @override
  Widget build(final BuildContext context) => WithNavBar(
      selectedIndex: 3,
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (final BuildContext context, final ProfileState state) {
          if (state is ProfileSignedOut) {
            context.go('/signup');
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
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Scaffold(
                body: Center(child: Text("Failed to load profile", style: TextStyle(color: Colors.red))),
              );
            }
          },
        ),
      ),
    );
}
