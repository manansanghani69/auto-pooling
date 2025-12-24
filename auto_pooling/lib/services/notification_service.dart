import 'dart:async';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  Stream<String> get onNotificationTap => const Stream.empty();

  Future<void> initialize() async {}
}
