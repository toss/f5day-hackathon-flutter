import 'package:amplitude_flutter/amplitude.dart';

class EventLog {
  static Future<void> sendEventLog(String eventType,
      {Map<String, dynamic>? eventProperties,
      bool? outOfSession = false}) async {
    // Create the instance
    final Amplitude analytics =
        Amplitude.getInstance(instanceName: "stylebook");

    // Log an event
    analytics.logEvent(eventType, eventProperties: eventProperties);
  }
}
