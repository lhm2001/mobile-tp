import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/api/consultation.dart';
import 'package:proyecto_tesis/api/service.dart';
import 'package:proyecto_tesis/login.dart';
import 'package:proyecto_tesis/myNotifications.dart';
import 'package:proyecto_tesis/myProfile.dart';
import 'package:proyecto_tesis/preventiveInformation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;
import 'dart:convert';
import 'package:sizer/sizer.dart';

class MyAccount extends StatelessWidget {

  const MyAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Mi Perfil", style: TextStyle(color: Colors.white)), // Nombre de la página que puedes cambiar dinámicamente según la página actual.
            backgroundColor: const Color(0xFF00807E),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 2.5.h),
            child: ListView.builder(
              itemCount: settingsList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(settingsList[index].icon,color: const Color(0xFF00807E), ),
                  title: Text(settingsList[index].title),
                  onTap: () async {
                    switch (index) {
                      case 0:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyProfile()),
                        );
                        break;
                      case 1:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyNotifications()),
                        );
                        break;
                      case 2:
                        globals.userId=0;
                        globals.isLoggedIn = false;
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('email', '');
                        prefs.setString('password', '');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                        break;
                    // Agrega más casos según la cantidad de opciones en la lista
                    }
                  },
                );
              },
            ),
          ),

        );
      }
    );

  }

}

class SettingItem {
  final String title;
  final IconData icon;
  // Otras propiedades que puedan ser necesarias para cada opción

  SettingItem({required this.title, required this.icon});
}

List<SettingItem> settingsList = [
  SettingItem(title: 'Mis datos', icon: Icons.person),
  SettingItem(title: 'Notificaciones', icon: Icons.notifications),
  SettingItem(title: 'Cerrar sesión', icon: Icons.logout),
  // Agrega más opciones según sea necesario
];






