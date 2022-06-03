import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:konsul/configs/_configs.dart';
import 'package:konsul/controllers/notification_controller.dart';
import 'package:konsul/models/notification.dart' as k;
import 'package:konsul/services/database_handler.dart';
import 'package:konsul/views/login_page/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// inisialisasi chanel android notifikasi
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notification',
  description: 'This channed is used for importance notifications',
  importance: Importance.high,
  playSound: true,
);

// inisialisasi local notifkasi
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _fcmBackgrounHanlder(RemoteMessage message) async {
  await Firebase.initializeApp();

  RemoteNotification? notification = message.notification;

  if (notification != null) {
    await storeNotification(notification);
  }

  debugPrint("Pesan baru telah muncul: ${message.messageId}");
}

// ketika notifikasi di terima simpan ke dalam local database
Future<void> storeNotification(RemoteNotification remoteNotification) async {
  k.Notification notification = k.Notification(
    title: remoteNotification.title ?? 'Title tdk tersedia!',
    subtitle: remoteNotification.body ?? 'Subtitle tdk tersedia',
    isnew: true,
    date: DateTime.now().toString(),
  );

  DatabaseHandler databaseHandler = DatabaseHandler.dbHandler;

  await databaseHandler.insertNotification(notification);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // tanganin kasus di mana notifikasi masuk pada saat aplikasi
  // dalam keadaan mati/terminated
  FirebaseMessaging.onBackgroundMessage(_fcmBackgrounHanlder);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: bg_color,
        backgroundColor: bg_color,
      ),
      home: const Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({
    Key? key,
  }) : super(key: key);

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  final cNotif = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();

    // Keadaan di mana notifikasi yang diterima akan di tampilkan di status bar
    // ketika aplikasi berada dalam status active, foreground, dan terminated
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;

      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );

        storeNotification(notification).then((_) {
          cNotif.countUnreadNoitf();
        });
      }
    });


    // Keadaan di mana notifikasi yang diterima akan di tampilkan secara langsung dengan menggunakan
    // popup dialog, hanya berlaku ketika aplikasi sendang aktif dn terbuka
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;

      if (notification != null && androidNotification != null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title ?? '-'),
              content: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.body ?? '-'),
                ],
              )),
            );
          },
        );

        storeNotification(notification).then((_) {
          cNotif.countUnreadNoitf();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}
