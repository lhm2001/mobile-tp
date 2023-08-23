import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:proyecto_tesis/api/user.dart';
import 'package:proyecto_tesis/bottomNavigation.dart';
import 'package:proyecto_tesis/notification.dart';
import 'package:proyecto_tesis/register.dart';
import 'globals.dart' as globals;
import 'package:proyecto_tesis/api/service.dart';
import 'package:sizer/sizer.dart';

class MyNotifications extends StatefulWidget {
  const MyNotifications({Key? key}) : super(key: key);

  @override
  State<MyNotifications> createState() => _MyNotificationsState();
}

class _MyNotificationsState extends State<MyNotifications> {

  bool _notificationsEnabled = globals.notificationsEnabled;

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Mis Notificaciones",style: TextStyle(color: Colors.white),), // Nombre de la página que puedes cambiar dinámicamente según la página actual.
            backgroundColor: const Color(0xFF00807E),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: EdgeInsets.all(2.5.h),
            child: Column(
              children: [
                SwitchListTile(
                  activeTrackColor: Colors.teal,
                  title: const Text('Notificaciones'),
                  value: _notificationsEnabled,
                  onChanged: (newValue) {
                    setState(() {
                      _notificationsEnabled = newValue;
                    });
                    globals.notificationsEnabled = _notificationsEnabled;
                  },
                ),

                // Container(
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       primary: Colors.white,
                //     ),
                //     onPressed: () {
                //       NotificationService().showNotification(title: 'Sample',body: 'IT WORKS!');
                //     },
                //     child: Padding(
                //       padding: EdgeInsets.all(5.w),
                //       child: Text("PRUEBA NOTIF",style:TextStyle(
                //         //fontWeight: FontWeight.bold,
                //           fontSize: 12.sp,
                //           color: Colors.black
                //       )),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      }
    );

  }
}
