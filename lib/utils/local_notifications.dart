import 'dart:convert';

import 'package:djizhub_light/home/home.dart';
import 'package:djizhub_light/main.dart';
import 'package:djizhub_light/utils/join_account_page_by_link.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';


class NotificationService {

  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final storage = const FlutterSecureStorage();


  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('splash_logo');

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

    final platform = notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
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

  Future <void> handleBackroundMessage(RemoteMessage message)async{
    print('title : ${message.notification?.title}');
    print('title : ${message.notification?.body}');
    print('title : ${message.data}');

  }
  void handleMessage(RemoteMessage message){
    if(message == null) return;
    navigatorKey.currentState?.pushNamed(
        JoinAccountByLink.route,
        arguments: message
    );
  }

  Future initPushNotification() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );



    //   FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  //  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  //  FirebaseMessaging.onBackgroundMessage(handleBackroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if(notification == null) return;
      notificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription : _androidChannel.description,
            icon: '@drawable/splash_logo',
            styleInformation: BigTextStyleInformation(
                notification.body ?? '', htmlFormatBigText: false, contentTitle: notification.title, htmlFormatContentTitle: false),
          )
        ),
        payload: jsonEncode(message.toMap()),

      );
    });

  }

  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel',
      'high_importance_notification',
      description: 'Ce channel est utilisé pour les notifications importantes',
      importance: Importance.defaultImportance

  );







Future <void> initFCMNotifications() async {
    await _firebaseMessaging.requestPermission();
    final FCMToken = await _firebaseMessaging.getToken();
    print("FCM TOKEN : $FCMToken");
    storage.write(key: 'fcmToken', value: FCMToken);

  //  FirebaseMessaging.onBackgroundMessage(handleBackroundMessage);
  initPushNotification();

}



}