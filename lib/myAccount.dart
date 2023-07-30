import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/api/consultation.dart';
import 'package:proyecto_tesis/api/service.dart';
import 'package:proyecto_tesis/login.dart';
import 'package:proyecto_tesis/myNotifications.dart';
import 'package:proyecto_tesis/myProfile.dart';
import 'package:proyecto_tesis/preventiveInformation.dart';
import 'globals.dart' as globals;
import 'dart:convert';

class myAccount extends StatelessWidget {

  const myAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Mi Perfil",style: TextStyle(color: Colors.white),), // Nombre de la página que puedes cambiar dinámicamente según la página actual.
        backgroundColor: Color(0xFF00807E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: ListView.builder(
          itemCount: settingsList.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(settingsList[index].icon,color: Color(0xFF00807E), ),
              title: Text(settingsList[index].title),
              onTap: () {
                switch (index) {
                  case 0:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => myProfile()),
                    );
                    break;
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => myNotifications()),
                    );
                    break;
                  case 2:
                    globals.userId=0;
                    globals.isLoggedIn = false;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => login()),
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






