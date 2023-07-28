import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/api/consultation.dart';
import 'package:proyecto_tesis/api/service.dart';
import 'package:proyecto_tesis/moleDetail.dart';
import 'package:proyecto_tesis/preventiveInformation.dart';
import 'globals.dart' as globals;
import 'dart:convert';

class myConsultations extends StatelessWidget {

  final int categoryId;
  final String categoryName;

  const myConsultations({Key? key, required this.categoryId,required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Consultas",style: TextStyle(color: Colors.white),), // Nombre de la página que puedes cambiar dinámicamente según la página actual.
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(top: 60,left: 20,right: 20),
            child: Column(
              children: [
                FutureBuilder(
                  initialData: [],
                  future:service.getConsultationsByCategoryId(categoryId),
                  builder: (context, AsyncSnapshot<List> snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    else{
                      if (snapshot.data!.isEmpty) {
                        // Si la lista está vacía, muestra un Text con el mensaje
                        return Container(
                          child: Center(
                            child: Text("No hay consultas disponibles", style: TextStyle(fontSize: 16),),
                          ),
                        );
                      }
                      else{
                        return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 18,mainAxisSpacing: 18 ),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context,index){
                              var consultation=snapshot.data![index];

                              String date = consultation.createdDate;
                              String datePart = date.split(' ')[0];

                              return GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>moleDetail(consultation: consultation,categoryName:categoryName)));
                                },

                                child: Column(
                                  children: [
                                    Expanded(child: Image.memory(Base64Decoder().convert(consultation.photo),width: 90,height: 80, fit: BoxFit.cover,)),

                                    SizedBox(height: 10,),

                                    Text(datePart,style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),),

                                  ],

                                ),


                              );



                            });
                      }

                    }

                  },
                ),


              ],
            )
        ),
      ),

    );
  }

}






