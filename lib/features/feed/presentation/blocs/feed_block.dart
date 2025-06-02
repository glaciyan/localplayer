// features/feed/presentation/blocs/feed/feed_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
// separete events and states into their own files when they grow larger

abstract class FeedEvent {}

abstract class FeedState {}

class FeedInitial extends FeedState {}

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedInitial());
}
