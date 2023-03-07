import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hdsaison_signing/src/BLOC/notification/notification_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hdsaison_signing/src/BLOC/user_remote/user_remote_bloc.dart';
import 'package:hdsaison_signing/src/constants/hard_constants.dart';
import 'package:hdsaison_signing/src/extentions/type_extesions.dart';
import 'package:hdsaison_signing/src/helpers/untils/logger.dart';
import 'package:hdsaison_signing/src/navigations/app_pages.dart';
import 'package:hdsaison_signing/src/navigations/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../BLOC/app_blocs.dart';
import '../BLOC/authentication/authentication_bloc.dart';
import '../BLOC/notification/models/otp_model.dart';

// DEFINE CONSTANT
const String PROFILE = 'profile';
const String HOME = 'home';
const String CHAT = 'chat';
const String NOTIFICATION = 'notification';
const String CONVERSATION = 'conversation';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

navigatorToScreen(String screenKey, dynamic payload) {}

Future<String?> getFirebaseMessagingToken() async {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? token = await _firebaseMessaging.getToken();
  return token;
}

Future<String?> getDeviceTokenAPNS() async {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? token = await _firebaseMessaging.getAPNSToken();
  return token;
}

Future<void> requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    debugPrint('User granted provisional permission');
  } else {
    debugPrint('User declined or has not accepted permission');
  }
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: false,
    badge: false,
    sound: false,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var android = const AndroidInitializationSettings('@mipmap/launcher_icon');

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
    onDidReceiveLocalNotification: (id, title, body, payload) => onSelectNotification(payload ?? ''),
  );

  var initSetttings = InitializationSettings(
      android: android, iOS: initializationSettingsDarwin);

  await flutterLocalNotificationsPlugin.initialize(initSetttings,
      onDidReceiveNotificationResponse: (details) => onSelectNotification(details.payload ?? ''),
  // onDidReceiveBackgroundNotificationResponse:(details) => onSelectNotification(details.payload ?? '')
  );

  await handleReceiveNotification();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
  await Firebase.initializeApp();
  handleNotification(message.data);
}

handleNotification(Map message) async {
  /// Sự kiện nhấn vào thông báo
  String type = message['Type'] ?? '';
  if(type.isNotEmpty){
    String notifyId = message['NotifyId'] ?? '';
    switch (type) {
      case 'DOCUMENT':
        String documentID = message['documentID'] ?? '';
        String documentName = message['documentName'] ?? '';
        String notificationType = message['NotificationType'] ?? '';
        AppBlocs.userRemoteBloc.add(UserRemoteReadNotificationEvent(notificationId: notifyId));
        if(notificationType  == NotificationType.PHAT_HANH_THE_THANH_CONG.name){
          String description = message['description'] ?? '';
          await launchUrl(Uri.parse(description));
        }else{
          Future.delayed(DELAY_250_MS,(){
            AppNavigator.push(Routes.DETAIL_CONTRACT,
                arguments: {
                  "idDocument": documentID,
                  "nameDocument": documentName
                });
          });
        }
        break;
    }
  }
}

Future onSelectNotification(String payload) async {
  print('payload: $payload');
  /*Fluttertoast.showToast(
      msg: "payload: $payload",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xFF0C91DC),
      textColor: Colors.white,
      fontSize: 16.0,
    );*/
  Map valueMap = json.decode(payload);
  handleNotification(valueMap);
}

_showNotification(RemoteMessage message) async {
  var android = const AndroidNotificationDetails(
    'channel_id',
    "CHANNEL NAME",
    channelDescription: "Channel Description",
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    styleInformation: DefaultStyleInformation(true, true),

  );

  final iOS = DarwinNotificationDetails(
      presentAlert: true, presentBadge: true, presentSound: true);

  var platform = NotificationDetails(android: android, iOS: iOS);
  // Read Data
  String? title = message.notification?.title;
  String? description = message.notification?.body;
  // String? id = message.data['objid'];

  // payLoad
  Map<dynamic, dynamic> payLoad = message.data;

  // TODO LocalNotification goi thi se co su kien tra ve payload khi click notification, chua biet neu notification binh thuong se bat su kien the nao
  await flutterLocalNotificationsPlugin.show(0, title, description, platform,
      payload: jsonEncode(payLoad));
}

handleReceiveNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) handleNotification(message.data);
  });

  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) async {
      debugPrint('A new mess event was published!' + ' ${message.data}');
      String type = message.data['Type'] ?? '';
      switch (type) {
        case 'DOCUMENT':
          UtilLogger.log('DOCUMENT', '${message.data}');
          _showNotification(message);
          Future.delayed(DELAY_500_MS*2,() {
            AppBlocs.userRemoteBloc.add(UserRemoteGetListNotificationEvent());
          },);
          break;
        case 'LOGOUT':
          UtilLogger.log('LOGOUT', '${message.data}');
          _showNotification(message);
          AppBlocs.authenticationBloc.add(AuthenticationLogOutEvent());
          break;
        default:
          UtilLogger.log('Notification Message Data', '${message.data}');
          final NotificationOtp smartOTPModel = NotificationOtp.fromMap(message.data);
          print(smartOTPModel.otp);
          AppBlocs.notificationBloc.add(NotificationCatchOTPEvent(
            smartOTPModel: smartOTPModel,
          ));
      }
    },
  );

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('A new onMessageOpenedApp event was published!' +
        ' ${message.data.toString()}');
    Future.delayed(DELAY_500_MS,(){
      handleNotification(message.data);
    });
  }).onError((error) => print('Error: $error [\'lambiengcode\']'));

}
