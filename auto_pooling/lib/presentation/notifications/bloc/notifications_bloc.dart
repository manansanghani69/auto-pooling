import 'package:flutter_bloc/flutter_bloc.dart';

import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsState.initial()) {
    _setupEventListener();
  }

  void _setupEventListener() {
    on<NotificationsStartedEvent>(_onNotificationsStartedEvent);
  }

  void _onNotificationsStartedEvent(
    NotificationsStartedEvent event,
    Emitter<NotificationsState> emit,
  ) {}
}
