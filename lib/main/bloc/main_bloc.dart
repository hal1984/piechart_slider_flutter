import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  @override
  MainState get initialState => InitialMainState(0);

  @override
  Stream<MainState> mapEventToState(
    MainEvent event,
  ) async* {
    if (event is IncrementEvent) {
      yield InitialMainState(event.val);
    }
  }
}
