import 'package:djizhub_light/home/home.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('logo_random');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
          //    String payload = notificationResponse.notification!.payload ?? '';
              String payload = '';
              // Ici, tu peux vérifier la valeur de payload et naviguer vers la page appropriée
              if (payload == 'page_specifique') {
                // Naviguer vers la page spécifique de ton choix
                // Exemple (assumes que tu utilises MaterialApp et MaterialApp.router):
                // Navigator.pushNamed(context, '/page_specifique');
                Get.to(()=>Home());
            }});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max,styleInformation: BigTextStyleInformation(''),),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {required int id, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }
}