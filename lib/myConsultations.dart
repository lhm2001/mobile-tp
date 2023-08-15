import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/api/consultation.dart';
import 'package:proyecto_tesis/api/service.dart';
import 'package:proyecto_tesis/moleDetail.dart';
import 'package:proyecto_tesis/preventiveInformation.dart';
import 'package:sizer/sizer.dart';
import 'globals.dart' as globals;
import 'dart:convert';

class MyConsultations extends StatelessWidget {

  final int categoryId;
  final String categoryName;

  const MyConsultations({Key? key, required this.categoryId,required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Mis Consultas",style: TextStyle(color: Colors.white),), // Nombre de la página que puedes cambiar dinámicamente según la página actual.
            backgroundColor: const Color(0xFF00807E),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(top: 10.w, left: 5.w, right:5.w),
                child: Column(
                  children: [
                    FutureBuilder(
                      initialData: const [],
                      future:service.getConsultationsByCategoryId(categoryId),
                      builder: (context, AsyncSnapshot<List> snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        else{
                          if (snapshot.data!.isEmpty) {
                            // Si la lista está vacía, muestra un Text con el mensaje
                            return Center(
                              child: Text("No hay consultas disponibles", style: TextStyle(fontSize: 16.sp)),
                            );
                          }
                          else{
                            return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 1.h,mainAxisSpacing: 1.h),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context,index){
                                  var consultation=snapshot.data![index];

                                  String date = consultation.createdDate;
                                  String datePart = date.split(' ')[0];

                                  return GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MoleDetail(consultation: consultation,categoryName:categoryName)));
                                    },

                                    child: Column(
                                      children: [
                                        Expanded(child: Image.memory(const Base64Decoder().convert(consultation.photo),width: 20.w,height: 20.h, fit: BoxFit.cover)),

                                        SizedBox(height: 2.5.h),

                                        Text(datePart,style: TextStyle(color: Colors.black,fontSize: 12.sp,fontWeight: FontWeight.bold)),

                                        SizedBox(height: 2.5.h),
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
    );
  }

}






