// features/chat/presentation/blocs/chat/chat_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
// separete events and states into their own files when they grow larger
abstract class ChatEvent {}

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial());
}
