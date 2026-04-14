import 'package:flutter/services.dart';

class NotificationChannel {
  static const MethodChannel _channel = MethodChannel('finance/notifications');

  /// Call from native when a notification with transaction info arrives.
  static void setOnNotificationReceived(void Function(Map<String, dynamic>) callback) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onNotification') {
        final args = Map<String, dynamic>.from(call.arguments as Map);
        callback(args);
      }
    });
  }

  /// For testing: simulate native notification
  static Future<void> simulateNativeNotification(Map<String, dynamic> payload) async {
    await _channel.invokeMethod('simulate', payload);
  }
}
