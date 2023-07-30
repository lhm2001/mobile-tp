import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:proyecto_tesis/api/user.dart';
import 'package:proyecto_tesis/bottomNavigation.dart';
import 'package:proyecto_tesis/notification.dart';
import 'package:proyecto_tesis/register.dart';
import 'globals.dart' as globals;
import 'package:proyecto_tesis/api/service.dart';

class myNotifications extends StatefulWidget {
  const myNotifications({Key? key}) : super(key: key);

  @override
  State<myNotifications> createState() => _myNotificationsState();
}

class _myNotificationsState extends State<myNotifications> {

  bool _notificationsEnabled = globals.notificationsEnabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Notificaciones",style: TextStyle(color: Colors.white),), // Nombre de la página que puedes cambiar dinámicamente según la página actual.
        backgroundColor: Color(0xFF00807E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              activeTrackColor: Colors.teal,
              title: Text('Notificaciones'),
              value: _notificationsEnabled,
              onChanged: (newValue) {
                setState(() {
                  _notificationsEnabled = newValue;
                });
                globals.notificationsEnabled = _notificationsEnabled;
              },
            ),
            Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
                onPressed: () {
                  NotificationService().showNotification(title: 'Sample',body: 'IT WORKS!');
                },
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text("PRUEBA NOTIF",style:TextStyle(
                    //fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
