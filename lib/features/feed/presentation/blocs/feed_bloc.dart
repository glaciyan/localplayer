// features/feed/presentation/blocs/feed/feed_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localplayer/core/network/api_error_exception.dart';
import 'package:localplayer/core/network/no_connection_exception.dart';
import 'package:localplayer/features/session/presentation/blocs/session_bloc.dart';
import 'feed_event.dart';
import 'feed_state.dart';
import 'package:localplayer/features/feed/domain/models/NotificationModel.dart';
import 'package:localplayer/features/feed/data/feed_repository_interface.dart';
import 'package:localplayer/features/session/presentation/blocs/session_event.dart' as session_event;

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final IFeedRepository feedRepository;
  final SessionBloc sessionBloc;

  FeedBloc({
    required this.feedRepository,
    required this.sessionBloc,
  }) : super(FeedInitial()) {
    on<RefreshFeed>(_onRefreshFeed);
    on<AcceptSession>(_onAcceptSession);
    on<RejectSession>(_onRejectSession);
    on<PingUser>(_onPingUser);
  }

  void _onRefreshFeed(final RefreshFeed event, final Emitter<FeedState> emit) async {
      try {
      emit(FeedLoading());
      await Future<void>.delayed(const Duration(seconds: 1));
      final List<NotificationModel> notifications =
          await feedRepository.fetchNotifications();
      emit(FeedLoaded(notifications: notifications));
    } on NoConnectionException {
      emit(FeedError("Cannot load notifications, no internet."));
    } catch (e) {
      if (e is ApiErrorException) {
        emit(FeedError(e.message));
      } else {
        emit(FeedError("Error fetching notifications"));
      }
    }
  }

  void _onAcceptSession(final AcceptSession event, final Emitter<FeedState> emit) async {
      try {
        // Use session bloc instead of feed repository
        sessionBloc.add(session_event.RespondToRequest(
          event.userId,
          event.sessionId,
          true,
        ));
        print('Accepted session');
        
        // Keep the current feed state
        if (state is FeedLoaded) {
          emit(FeedLoaded(notifications: (state as FeedLoaded).notifications));
        }
      } catch (e) {
        emit(FeedError(e.toString()));
      }
  }

  void _onRejectSession(final RejectSession event, final Emitter<FeedState> emit) async {
      try {
        // Use session bloc instead of feed repository
        sessionBloc.add(session_event.RespondToRequest(
          event.userId,
          event.sessionId,
          false,
        ));
        print('Rejected session');

        // Keep the current feed state
        if (state is FeedLoaded) {
          emit(FeedLoaded(notifications: (state as FeedLoaded).notifications));
        }
      } catch (e) {
        emit(FeedError(e.toString()));
      }
  }

  void _onPingUser(final PingUser event, final Emitter<FeedState> emit) async {
    try {
      await feedRepository.pingUser(event.userId);
      emit(PingUserSuccess((state as FeedLoaded).notifications));
    } catch (e) {
      emit(PingUserError(e.toString()));
    }
  }
}