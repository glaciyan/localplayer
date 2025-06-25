import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';

abstract class FeedState {}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<NotificationModel> notifications;
  final bool hasMore;
  
  FeedLoaded({
    required this.notifications,
    this.hasMore = true,
  });
}

class FeedError extends FeedState {
  final String message;
  FeedError(this.message);
}

class PingUserSuccess extends FeedState {
  final List<NotificationModel> notifications;
  PingUserSuccess(this.notifications);
}

class PingUserError extends FeedState {
  final String message;
  PingUserError(this.message);
}