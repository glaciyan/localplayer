import 'package:flutter/material.dart';
import 'package:localplayer/features/feed/domain/controllers/feed_controller.dart';
import 'package:localplayer/features/feed/domain/interfaces/feed_controller_interface.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_bloc.dart';
import 'package:localplayer/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:localplayer/core/network/api_client.dart';

class FeedModule {
  static FeedBloc provideBloc() => FeedBloc(
    FeedRemoteDataSource(ApiClient()),
  );

  static IFeedController provideController(final BuildContext context, final FeedBloc bloc) => FeedController(
    context,
    bloc.add,
  );
}
