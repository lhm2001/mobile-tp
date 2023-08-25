import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'api/category.dart';
import 'api/consultation.dart';

class CompareResults extends StatelessWidget {
  // const CompareResults({Key? key}) : super(key: key);

  final Map<Consultation, Category> lastConsultation;
  final Consultation consultation;
  final String category;

  CompareResults({required this.lastConsultation, required this.consultation, required this.category});


  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Comparación",style: TextStyle(color: Colors.white)), // Nombre de la página que puedes cambiar dinámicamente según la página actual.
              backgroundColor: const Color(0xFF00807E),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(2.h),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(category, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.sp)),

                        Text(consultation.createdDate,style: TextStyle(fontSize: 12.sp))
                      ],
                    ),

                    Image.memory(const Base64Decoder().convert(consultation.photo), width: 40.w, height: 20.h),

                    Text("Lunar ${consultation.dysplastic ? "Displásico" : "No Displásico"}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp)),

                    SizedBox(height: 2.5.h),

                    Align(
                      alignment: Alignment.center,
                      child: Text("Resultados",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.sp)),
                    ),

                    SizedBox(height: 1.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Asimetría : ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
                          ),

                          Text(
                            consultation.resultAssymetry == 'Asymmetric' ? "Asimétrico" : "Simétrico",
                            style: TextStyle(fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 0.5.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Borde        : ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
                          ),

                          Text(
                            consultation.resultBorder,
                            style: TextStyle(fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 0.5.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Color         : ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
                          ),

                          Text(
                            consultation.resultColor == "Heterogeneous" ? "Heterogéneo" : "Homogéneo",
                            style: TextStyle(fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 0.5.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Diámetro  : ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
                          ),

                          Expanded(
                            child: Text(
                              consultation.resultDiameter == "The diameter can be measured manually. If the diameter is greater than 6mm, a specialist should be consulted." ? "El diámetro lo puede medir manualmente. En caso de que el diámetro sea mayor a 6mm, se debe dirigir a un especialista." : "",
                              style: TextStyle(fontSize: 10.sp),
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(
                      color: Color(0xFF00807E),
                      thickness: 2.5,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(lastConsultation.values.first.name, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.sp)),

                        Text(lastConsultation.keys.first.createdDate,style: TextStyle(fontSize: 12.sp))
                      ],
                    ),

                    Image.memory(const Base64Decoder().convert(lastConsultation.keys.first.photo), width: 40.w, height: 20.h),

                    Text("Lunar ${lastConsultation.keys.first.dysplastic ? "Displásico" : "No Displásico"}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp)),

                    SizedBox(height: 2.5.h),

                    Align(
                      alignment: Alignment.center,
                      child: Text("Resultados",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.sp)),
                    ),

                    SizedBox(height: 1.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Asimetría : ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
                          ),

                          Text(
                            lastConsultation.keys.first.resultAssymetry == 'Asymmetric' ? "Asimétrico" : "Simétrico",
                            style: TextStyle(fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 0.5.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Borde        : ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
                          ),

                          Text(
                            lastConsultation.keys.first.resultBorder,
                            style: TextStyle(fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 0.5.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Color         : ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
                          ),

                          Text(
                            lastConsultation.keys.first.resultColor == "Heterogeneous" ? "Heterogéneo" : "Homogéneo",
                            style: TextStyle(fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 0.5.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Diámetro  : ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
                          ),

                          Text(
                            lastConsultation.keys.first.resultDiameter == "The diameter can be measured manually. If the diameter is greater than 6mm, a specialist should be consulted." ? "El diámetro lo puede medir manualmente. En caso de que el diámetro sea mayor a 6mm, se debe dirigir a un especialista." : "",
                            style: TextStyle(fontSize: 10.sp),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              ),
            )
          );
        }
    );
  }
}
