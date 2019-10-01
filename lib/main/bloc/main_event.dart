import 'package:meta/meta.dart';

@immutable
abstract class MainEvent {}


class IncrementEvent extends MainEvent {
  final double val;

  IncrementEvent(this.val);
}
