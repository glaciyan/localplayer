import 'package:flutter/material.dart';
import 'package:localplayer/features/feed/domain/controllers/feed_controller.dart';
import 'package:localplayer/features/feed/domain/interfaces/feed_controller_interface.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:localplayer/features/feed/data/feed_repository_interface.dart';
import 'package:localplayer/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:localplayer/core/network/api_client.dart';
import 'package:localplayer/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:localplayer/spotify/data/services/config_service.dart';

class FeedModule {
  static FeedBloc provideBloc({
    required final IFeedRepository feedRepository,
  }) => FeedBloc(
    feedRepository: feedRepository,
  );

  static IFeedController provideController(
    final BuildContext context, 
    final FeedBloc bloc
    ) => FeedController(context, bloc.add,);

  static IFeedRepository provideRepository(final ConfigService config) => FeedRepository(
    FeedRemoteDataSource(ApiClient(baseUrl: config.apiBaseUrl))
  );
}