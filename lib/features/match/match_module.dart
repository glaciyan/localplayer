// features/match/match_module.dart
import 'package:flutter/widgets.dart';
import 'package:localplayer/features/match/domain/controllers/IMatchController.dart';
import 'package:localplayer/features/match/presentation/blocs/match_block.dart';
import 'package:localplayer/features/match/presentation/controllers/match_controller.dart';

import 'domain/repositories/match_repository.dart';
import 'domain/usecases/like_user_usecase.dart';
import 'domain/usecases/dislike_user_usecase.dart';
import 'data/repositories/match_repository_impl.dart';

class MatchModule {
  static MatchBloc provideBloc() {
    final MatchRepository repo = MatchRepositoryImpl();
    final like = LikeUserUseCase(repo);
    final dislike = DislikeUserUseCase(repo);
    return MatchBloc(
      likeUseCase: like,
      dislikeUseCase: dislike,
      repository: repo,
    );
  }

  static IMatchController provideController(BuildContext context, MatchBloc bloc) {
    return MatchController(
      context,
      (event) => bloc.add(event),
    );
  }
}
