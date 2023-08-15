import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/api/consultation.dart';
import 'package:proyecto_tesis/api/service.dart';
import 'package:proyecto_tesis/preventiveInformation.dart';
import 'globals.dart' as globals;
import 'dart:convert';
import 'package:sizer/sizer.dart';

class MoleDetail extends StatelessWidget {

  final Consultation consultation;
  final String categoryName;

  const MoleDetail({Key? key, required this.consultation,required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Mi Consulta",style: TextStyle(color: Colors.white)), // Nombre de la página que puedes cambiar dinámicamente según la página actual.
            backgroundColor: const Color(0xFF00807E),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(top: 10.w, left: 5.w, right:5.w),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(categoryName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp)),
                        Text(consultation.createdDate,style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),

                    Image.memory(const Base64Decoder().convert(consultation.photo), width: 80.w, height: 40.h),

                    Text("Lunar ${consultation.dysplastic ? "Displásico" : "No Displásico"}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.sp)),

                    SizedBox(height: 5.h),

                    Align(
                      alignment: Alignment.center,
                      child: Text("Resultados",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp)),
                    ),

                    SizedBox(height: 2.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Asimetría : ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                          ),

                          Text(
                            consultation.resultAssymetry,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 1.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Borde        : ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                          ),

                          Text(
                            consultation.resultBorder,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 1.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Color         : ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                          ),

                          Text(
                            consultation.resultColor,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 1.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Diámetro  : ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                          ),

                          Text(
                            consultation.resultDiameter,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ],
                      ),
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






