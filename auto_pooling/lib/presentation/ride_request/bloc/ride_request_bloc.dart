import 'package:flutter_bloc/flutter_bloc.dart';

import 'ride_request_event.dart';
import 'ride_request_state.dart';

class RideRequestBloc extends Bloc<RideRequestEvent, RideRequestState> {
  RideRequestBloc() : super(RideRequestState.initial()) {
    _setupEventListener();
  }

  void _setupEventListener() {
    on<RideRequestStartedEvent>(_onRideRequestStartedEvent);
  }

  void _onRideRequestStartedEvent(
    RideRequestStartedEvent event,
    Emitter<RideRequestState> emit,
  ) {}
}
