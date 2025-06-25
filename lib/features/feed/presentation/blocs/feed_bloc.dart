// features/feed/presentation/blocs/feed/feed_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feed_event.dart';
import 'feed_state.dart';
import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';
import 'package:localplayer/features/feed/data/feed_repository_interface.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final IFeedRepository feedRepository;

  FeedBloc({
    required this.feedRepository,
  }) : super(FeedInitial()) {
    on<RefreshFeed>(_onRefreshFeed);
    on<AcceptSession>(_onAcceptSession);
    on<RejectSession>(_onRejectSession);
  }

  void _onRefreshFeed(final RefreshFeed event, final Emitter<FeedState> emit) async {
      try {
        emit(FeedLoading());
        await Future<void>.delayed(const Duration(seconds: 1));
        final List<NotificationModel> notifications = await feedRepository.fetchNotifications();
        emit(FeedLoaded(notifications: notifications));
      } catch (e) {
        emit(FeedError("Error fetching notifications"));
      }
  }

  void _onAcceptSession(final AcceptSession event, final Emitter<FeedState> emit) async {
      try {
        final bool success = await feedRepository.acceptSession(event.userId, event.sessionId);
        if (success && state is FeedLoaded) {
          emit(FeedLoaded(notifications: (state as FeedLoaded).notifications));
        } else if (!success) {
          emit(FeedError("Error accepting session"));
        }
      } catch (e) {
        emit(FeedError(e.toString()));
      }
  }

  void _onRejectSession(final RejectSession event, final Emitter<FeedState> emit) async {
      emit(FeedLoading());
      try {
        await feedRepository.rejectSession(event.userId, event.sessionId);
      } catch (e) {
        emit(FeedError(e.toString()));
      }
  }
}