import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/api/consultation.dart';
import 'package:proyecto_tesis/api/service.dart';
import 'package:proyecto_tesis/api/user.dart';
import 'package:proyecto_tesis/login.dart';
import 'package:proyecto_tesis/preventiveInformation.dart';
import 'globals.dart' as globals;
import 'dart:convert';
import 'package:sizer/sizer.dart';

class MyProfile extends StatelessWidget {

  const MyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final userId=globals.userId;

    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Mi Perfil",style: TextStyle(color: Colors.white)), // Nombre de la página que puedes cambiar dinámicamente según la página actual.
            backgroundColor: const Color(0xFF00807E),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
              padding: EdgeInsets.all(2.5.h),
              child: Column(
                children: [
                  FutureBuilder<User>(
                    future:service.getUserById(userId),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      else{
                        var user=snapshot.data!;
                        return Column(
                          children: [
                            Card(
                              color: Colors.white,
                              child: ListTile(
                                title: const Text('Nombre'),
                                subtitle: Text(user.name),
                              ),
                            ),

                            SizedBox(height: 2.5.h),

                            Card(
                              color: Colors.white,
                              child: ListTile(
                                title: const Text('Apellidos'),
                                subtitle: Text(user.lastName),
                              ),
                            ),

                            SizedBox(height: 2.5.h),

                            Card(
                              color: Colors.white,
                              child: ListTile(
                                title: const Text('Correo electrónico'),
                                subtitle: Text(user.email),

                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              )
          ),

        );
      }
    );
  }
}



Widget buildListTileWithDivider(String label, String value) {
  return Column(
    children: [
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 1.h), // Ajusta el relleno interno
        title: Text(
          label,
          style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: TextStyle(color: Colors.black, fontSize: 16.sp),
        ),
      ),
      const Divider( // Agrega una línea divisoria después de cada ListTile
        color: Colors.grey, // Puedes ajustar el color de la línea según tus preferencias
        thickness: 1, // Puedes ajustar el grosor de la línea según tus preferencias
        indent: 16, // Puedes ajustar la indentación de la línea según tus preferencias
        endIndent: 16, // Puedes ajustar la indentación del extremo de la línea según tus preferencias
      ),
    ],
  );
}







