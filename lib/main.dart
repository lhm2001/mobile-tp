import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proyecto_tesis/bottomNavigation.dart';
import 'package:proyecto_tesis/login.dart';
import 'package:proyecto_tesis/notification.dart';
import 'globals.dart' as globals;
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  await Permission.notification.isGranted.then((value) {
    globals.notificationsEnabled=true;
  });

  NotificationService().initNotification();

  tz.initializeTimeZones();

  // DateTime dateTime1 = DateTime(2023, 7, 29, 20, 35);
  // DateTime dateTime2 = DateTime(2023, 7, 29, 20, 36);
  //
  // NotificationService().scheduleNotification(id: 1,title: 'Scheduled Notification',body: 'Hola', scheduledNotificationDateTime: dateTime1);
  // NotificationService().scheduleNotification(id:2,title: 'Scheduled Notification',body: 'Hola', scheduledNotificationDateTime: dateTime2);
  //

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}