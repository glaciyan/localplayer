// features/feed/presentation/blocs/feed/feed_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feed_event.dart';
import 'feed_state.dart';
import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';
import 'package:localplayer/features/feed/data/feed_repository_interface.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final IFeedRepository feedRepository;

  final List<NotificationModel> posts = <NotificationModel> [
    NotificationModel(id: 1, artistId: 1, backgroundLink: "https://i1.sndcdn.com/artworks-y3inzkQdBqBFfOow-yfKP9g-t1080x1080.jpg", createdAt: DateTime(2000), title: "Test Title", read: false, type: NotificationType.like, recipientId: 1),
    NotificationModel(id: 2, artistId: 1, backgroundLink: "https://i1.sndcdn.com/artworks-y3inzkQdBqBFfOow-yfKP9g-t1080x1080.jpg", createdAt: DateTime(2001), title: "Test Title 2", read: false, type: NotificationType.follow, recipientId: 1),
    NotificationModel(id: 3, artistId: 1, backgroundLink: "https://i1.sndcdn.com/artworks-y3inzkQdBqBFfOow-yfKP9g-t1080x1080.jpg", createdAt: DateTime(2002), title: "Test Title 3", read: false, type: NotificationType.newMessage, recipientId: 1),
    NotificationModel(id: 4, artistId: 1, backgroundLink: "https://i1.sndcdn.com/artworks-y3inzkQdBqBFfOow-yfKP9g-t1080x1080.jpg", createdAt: DateTime(2003), title: "Test Title 4", read: false, type: NotificationType.sessionInvite, recipientId: 1),
    NotificationModel(id: 5, artistId: 1, backgroundLink: "https://i1.sndcdn.com/artworks-y3inzkQdBqBFfOow-yfKP9g-t1080x1080.jpg", createdAt: DateTime(2004), title: "Test Title 5", read: false, type: NotificationType.sessionAccepted, recipientId: 1),
    NotificationModel(id: 6, artistId: 1, backgroundLink: "https://picsum.photos/200/300", createdAt: DateTime(2005), title: "Test Title 6", read: false, type: NotificationType.sessionRejected, recipientId: 1),
  ];

  FeedBloc({
    required this.feedRepository,
  }) : super(FeedInitial()) {
    on<LoadFeed>(_onLoadFeed);
    on<RefreshFeed>(_onRefreshFeed);
    on<AcceptSession>(_onAcceptSession);
    on<RejectSession>(_onRejectSession);
  }

  void _onLoadFeed(final LoadFeed event, final Emitter<FeedState> emit) async {
    emit(FeedLoading());
  }

  void _onRefreshFeed(final RefreshFeed event, final Emitter<FeedState> emit) async {
      try {
        final List<NotificationModel> notifications = await feedRepository.fetchNotifications();
        emit(FeedLoaded(notifications: notifications));
      } catch (e) {
        emit(FeedError(e.toString()));
      }
  }

  void _onAcceptSession(final AcceptSession event, final Emitter<FeedState> emit) async {
      emit(FeedLoading());
      try {
        await feedRepository.acceptSession(event.sessionId, event.userId);
      } catch (e) {
        emit(FeedError(e.toString()));
      }
  }

  void _onRejectSession(final RejectSession event, final Emitter<FeedState> emit) async {
      emit(FeedLoading());
      try {
        await feedRepository.rejectSession(event.sessionId, event.userId);
      } catch (e) {
        emit(FeedError(e.toString()));
      }
  }
}