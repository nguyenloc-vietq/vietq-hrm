import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vietq_hrm/configs/apiConfig/notification.api.dart';
import 'package:vietq_hrm/configs/sharedPreference/SharedPreferences.config.dart';
import 'package:vietq_hrm/main.dart';


@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint('User tapped notification: ${notificationResponse.payload}');
  // Bạn có thể xử lý chuyển trang ở đây nếu cần
}

class NotificationService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notification is permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      Permission.notification.request();
      print('Notification is provisional');
    } else {
      Permission.notification.request();
      print('Notification is denied');
    }
  }

  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      return (await deviceInfo.androidInfo).id;
    } else if (Platform.isIOS) {
      return (await deviceInfo.iosInfo).identifierForVendor!;
    }
    return '';
  }

  Future<void> getToken() async {
    final bool isAllowNotification = await SharedPreferencesConfig.allowNotification;
    if(!isAllowNotification) throw new Exception("Notification is disabled");

    String? token = await _firebaseMessaging.getToken();
    String deviceId = await getDeviceId();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    try{
      await NotificationApi().registerNotification({
        "platform": Platform.isAndroid ? "android" : "ios",
        "appVersion": packageInfo.version,
        "deviceId": deviceId,
        "fcmToken": token,
      });
      print('FCM : $token');
    }catch (e){
      print("#==========> DEVICES FCM ERROR: " + e.toString());
    }

  }

  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    SharedPreferencesConfig.allowNotification = false;
  }

  void initLocalNotification(BuildContext context,
      RemoteMessage message,) async {
    //setting android ios setting
    var androidInitSetting = const AndroidInitializationSettings(
      'ic_launcher',
    );
    var iosInitSetting = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true
    );
    //cau hinh
    var initialaizationSetting = InitializationSettings(
      android: androidInitSetting,
      iOS: iosInitSetting,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initialaizationSetting,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          handleMessage(context, message);
        },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground
    );
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      print(android);
      if (kDebugMode) {
        print('Notification title: ${notification!.title}');
        print('Notification body: ${notification!.body}');
      }
      if (Platform.isIOS) {
        iosForgroundMessage();
      }
      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        showNotification(message);
      }
    });
  }

  //func to show notifications
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notification',
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: "Channel Description",
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true,
        sound: channel.sound,
        icon: 'ic_launcher',
    );
    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    Future.delayed(
        Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
        payload: "my_data",
      );
    }
    );
  }

  //background and terminated
  Future<void> setupInteractions(BuildContext context) async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage(context, message);
    });

    FirebaseMessaging.instance.getInitialMessage().then(
          (RemoteMessage? message) {
        if (message != null && message.data.isNotEmpty) {
          handleMessage(context, message);
        }
      },
    );
  }

  Future<void> handleMessage(BuildContext context,
      RemoteMessage message) async {
    //navigate to link notification
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MyHomePage(title: 'hello')));
  }

  Future iosForgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

