import 'package:meta/meta.dart';

@immutable
abstract class MainState {
  final double counter;
  MainState(this.counter);
}

class InitialMainState extends MainState {
  InitialMainState(double counter) : super(counter);
}
