import 'package:flutter_bloc/flutter_bloc.dart';

part 'counter_event.dart';

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<IncrementCounter>((event, emit) => emit(state + 1));
    on<ClearCounter>((event, emit) => emit(0));
    on<SyncCounter>((event, emit) => emit(event.value));
  }
}
