import 'package:flutter_bloc/flutter_bloc.dart';

class StringState {
  final String value;

  StringState(this.value);
}

class StringCubit extends Cubit<StringState> {
  StringCubit() : super(StringState('Initial Value'));

  void updateString(String newValue) {
    emit(StringState(newValue));
  }
}
