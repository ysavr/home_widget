part of 'counter_bloc.dart';

sealed class CounterEvent {}
class IncrementCounter extends CounterEvent {}
class ClearCounter extends CounterEvent {}

class SyncCounter extends CounterEvent {
  final int value;
  SyncCounter(this.value);
}