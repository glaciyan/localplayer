import 'package:bloc/bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on<NavigateToHome>((event, emit) => emit(NavigationHome()));
    on<NavigateToChat>((event, emit) => emit(NavigationChat()));
    on<NavigateToFeed>((event, emit) => emit(NavigationFeed()));
    on<NavigateToMap>((event, emit) => emit(NavigationMap()));
    on<NavigateToMatch>((event, emit) => emit(NavigationMatch()));
  }
}