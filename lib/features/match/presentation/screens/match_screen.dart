import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/widgets/with_nav_bar.dart';
import 'package:localplayer/features/match/match_module.dart';
import 'package:localplayer/features/match/presentation/blocs/match_event.dart';
import 'package:localplayer/features/match/presentation/widgets/match_widget.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WithNavBar(
      selectedIndex: 1,
      child: BlocProvider(
        create: (_) => MatchModule.provideBloc()..add(LoadProfiles()),
        child: const MatchWidget(),
      ),
    );
  }
}
