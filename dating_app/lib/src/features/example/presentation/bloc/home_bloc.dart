import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<TapImageEvent>(_tapImageEvent);
  }

  FutureOr<void> _tapImageEvent(TapImageEvent event, Emitter<HomeState> emit) {
    Fluttertoast.showToast(msg: 'Test Bloc');
  }
}
