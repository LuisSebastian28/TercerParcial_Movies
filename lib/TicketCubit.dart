import 'package:flutter_bloc/flutter_bloc.dart';

class TicketCubit extends Cubit<int> {
  TicketCubit() : super(0);

  void increment() => emit(state + 1);

  void decrement() => {
        if (state == 0) {emit(state)} else {emit(state - 1)}
      };
}
