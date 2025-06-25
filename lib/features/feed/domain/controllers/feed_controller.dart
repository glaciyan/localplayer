import 'package:flutter/material.dart';
import 'package:localplayer/features/feed/domain/interfaces/feed_controller_interface.dart';
import 'package:localplayer/features/feed/presentation/blocs/feed_event.dart';

class FeedController implements IFeedController {
  final BuildContext context;
  final Function(FeedEvent) addEvent;

  FeedController(this.context, this.addEvent);

  @override
  void loadFeed() => addEvent(LoadFeed());

  @override
  void refreshFeed() => addEvent(RefreshFeed());

  @override
  void acceptSession(final int userId, final int sessionId) => addEvent(AcceptSession(sessionId, userId));

  @override
  void rejectSession(final int userId, final int sessionId) => addEvent(RejectSession(sessionId, userId));

  @override
  void pingUser(final int userId) => addEvent(PingUser(userId));
}