import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';

abstract class FeedState {}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<NotificationModel> posts;
  final bool hasMore;
  
  FeedLoaded({
    required this.posts,
    this.hasMore = true,
  });
}

class FeedError extends FeedState {
  final String message;
  FeedError(this.message);
}