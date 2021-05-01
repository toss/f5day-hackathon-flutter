import 'package:amplitude_flutter/amplitude.dart';

class EventLog {
  static final Amplitude _analytics =
      Amplitude.getInstance(instanceName: "stylebook");

  static Future<void> sendEventLog(String eventType,
      {Map<String, dynamic>? eventProperties,
      bool? outOfSession = false}) async {
    // Create the instance

    // Log an event
    _analytics.logEvent(eventType, eventProperties: eventProperties);
  }

  static Future<void> setProperties(Map<String, dynamic> properties) async {
    _analytics.setUserProperties(properties);
  }
}
