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

class myProfile extends StatelessWidget {

  const myProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final userId=globals.userId;

    return Scaffold(
      appBar: AppBar(
        title: Text("Mi Perfil",style: TextStyle(color: Colors.white),), // Nombre de la página que puedes cambiar dinámicamente según la página actual.
        backgroundColor: Color(0xFF00807E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              FutureBuilder<User>(
                future:service.getUserById(userId),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  else{
                    var user=snapshot.data!;
                    return Column(
                      children: [
                        Card(
                          child: ListTile(
                            title: Text('Nombre'),
                            subtitle: Text(user.name),

                          ),
                          color: Colors.white,
                        ),
                        Card(
                          child: ListTile(
                            title: Text('Apellidos'),
                            subtitle: Text(user.lastName),

                          ),
                          color: Colors.white,
                        ),
                        Card(
                          child: ListTile(
                            title: Text('Correo'),
                            subtitle: Text(user.email),

                          ),
                          color: Colors.white,
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

}



Widget buildListTileWithDivider(String label, String value) {
  return Column(
    children: [
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0), // Ajusta el relleno interno
        title: Text(
          label,
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      Divider( // Agrega una línea divisoria después de cada ListTile
        color: Colors.grey, // Puedes ajustar el color de la línea según tus preferencias
        thickness: 1.0, // Puedes ajustar el grosor de la línea según tus preferencias
        indent: 16, // Puedes ajustar la indentación de la línea según tus preferencias
        endIndent: 16, // Puedes ajustar la indentación del extremo de la línea según tus preferencias
      ),
    ],
  );
}







