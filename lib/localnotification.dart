import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings("mipmap/ic_launcher");

  Future<void> initNotification() async {
    var initializationsettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: DarwinInitializationSettings());

    await notificationPlugin.initialize(
      initializationsettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResppoonse) async {},
    );
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation('')),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return notificationPlugin.show(id, title, body, await notificationDetails(),
        payload: "ravi");
  }
}
