import 'package:flutter_bloc/flutter_bloc.dart';

import 'ride_tracking_event.dart';
import 'ride_tracking_state.dart';

class RideTrackingBloc extends Bloc<RideTrackingEvent, RideTrackingState> {
  RideTrackingBloc() : super(RideTrackingState.initial()) {
    _setupEventListener();
  }

  void _setupEventListener() {
    on<RideTrackingStartedEvent>(_onRideTrackingStartedEvent);
  }

  void _onRideTrackingStartedEvent(
    RideTrackingStartedEvent event,
    Emitter<RideTrackingState> emit,
  ) {}
}
