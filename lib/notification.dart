import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MyHomePage extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 39, 47, 82),
        title: Text('Event Notifications'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Schedule a notification for an upcoming event (e.g., 10 seconds from now).
                scheduleEventNotification();
              },
              child: Text('Schedule Event Notification'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> scheduleEventNotification() async {
    // Initialize the notification plugin
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Initialize the time zone
    tz.initializeTimeZones();
    final String timeZoneName = 'Asia/Karachi';
    ; // Replace 'your_timezone' with the desired time zone
    final tz.Location timeZone = tz.getLocation(timeZoneName);

    // Define the notification details
    // ignore: prefer_const_constructors
    final NotificationDetails notificationDetails = NotificationDetails(
      android: const AndroidNotificationDetails(
        'event_channel_id',
        'Event Channel Name',
        importance: Importance.high,
      ),
    );

    // Calculate the time for the notification (e.g., 10 seconds from now)
    final scheduledTime =
        tz.TZDateTime.now(timeZone).add(Duration(seconds: 10));

    // Define the notification content
    final eventNotification = NotificationContent(
      title: 'Upcoming Event',
      body: "Don't forget about the event!",
    );

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      eventNotification.title,
      eventNotification.body,
      scheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload:
          'customData', // You can add custom data for handling the notification
    );
  }
}

class NotificationContent {
  final String title;
  final String body;

  NotificationContent({
    required this.title,
    required this.body,
  });
}
