import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/api/consultation.dart';
import 'package:proyecto_tesis/api/service.dart';
import 'package:proyecto_tesis/preventiveInformation.dart';
import 'globals.dart' as globals;
import 'dart:convert';

class moleDetail extends StatelessWidget {

  final Consultation consultation;
  final String categoryName;

  const moleDetail({Key? key, required this.consultation,required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Mi Consulta",style: TextStyle(color: Colors.white),), // Nombre de la página que puedes cambiar dinámicamente según la página actual.
        backgroundColor: Color(0xFF00807E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(top: 60,left: 20,right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(categoryName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                    Text(consultation.createdDate,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                  ],
                ),

                Image.memory(Base64Decoder().convert(consultation.photo),width: 300,height: 300,),

                Text("Lunar ${consultation.dysplastic ? "Displásico" : "No Displásico"}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),

                SizedBox(height: 20,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Resultados:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                ),
                SizedBox(height: 20,),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Asimetría: ${consultation.resultAssymetry}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                ),

                SizedBox(height: 5,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Borde: ${consultation.resultBorder}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                ),

                SizedBox(height: 5,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Color: ${consultation.resultColor}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                ),
                SizedBox(height: 5,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Diámetro: ${consultation.resultDiameter}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                ),
              ],
            )
        ),
      ),

    );
  }

}






