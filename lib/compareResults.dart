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

  Widget cardConclusion(Consultation firstConsultation, Consultation secondConsultation) {

    var ruleA = true;
    var ruleB = true;
    var ruleC = true;
    var text = "";

    if (firstConsultation.resultAssymetry != secondConsultation.resultAssymetry) {
      ruleA = false;
      text = "Asimetría";
    }

    if (firstConsultation.resultBorder != secondConsultation.resultBorder) {
      ruleB = false;
      if (text.isNotEmpty) {
        text = "$text - Borde";
      }
      else {
        text = "Borde";
      }
    }

    if (firstConsultation.resultColor != secondConsultation.resultColor) {
      ruleC = false;
      if (text.isNotEmpty) {
        text = "$text - Color";
      }
      else {
        text = "Color";
      }
    }

    if (firstConsultation.dysplastic == false && secondConsultation.dysplastic == false) {
      return Card(
        color: const Color(0xFFf7fcfc),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF00807E)), // Cambia el color a tu preferencia
          borderRadius: BorderRadius.circular(10), // Ajusta el radio del borde según tus necesidades
        ),
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Column(
            children: [
              Text('CONCLUSIÓN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp), textAlign: TextAlign.center),

              SizedBox(
                height: 1.h,
              ),

              Text('A lo largo del tiempo, el lunar en cuestión no ha experimentado alteraciones en: Asimetría - Borde - Color y mantiene su naturaleza no displásica.', style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.justify),
            ],
          ),
        ),
      );
    }
    else if (firstConsultation.dysplastic == true && secondConsultation.dysplastic == true) {
      return Card(
        color: const Color(0xFFf7fcfc),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF00807E)), // Cambia el color a tu preferencia
          borderRadius: BorderRadius.circular(10), // Ajusta el radio del borde según tus necesidades
        ),
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Column(
            children: [
              Text('CONCLUSIÓN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp), textAlign: TextAlign.center),

              SizedBox(
                height: 1.h,
              ),

              ruleA == true && ruleB == true && ruleC == true ?
                Text('A lo largo del tiempo, el lunar en cuestión no ha experimentado alteraciones en: Asimetría - Borde - Color y mantiene su naturaleza displásica.', style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.justify) :
              ruleA == false || ruleB == false || ruleC == false ?
                Text('A lo largo del tiempo, el lunar en cuestión ha experimentado alteraciones en: $text y mantiene su naturaleza displásica.', style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.justify) :
                const Text(""),
            ],
          ),
        ),
      );
    }
    else if (firstConsultation.dysplastic == true && secondConsultation.dysplastic == false) {
      return Card(
        color: const Color(0xFFf7fcfc),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF00807E)), // Cambia el color a tu preferencia
          borderRadius: BorderRadius.circular(10), // Ajusta el radio del borde según tus necesidades
        ),
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Column(
            children: [
              Text('CONCLUSIÓN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp), textAlign: TextAlign.center),

              SizedBox(
                height: 1.h,
              ),

              ruleA == true && ruleB == true && ruleC == true ?
                Text('A lo largo del tiempo, el lunar en cuestión no ha experimentado alteraciones en: Asimetría - Borde - Color y ha cambiado su naturaleza de no displásica a displásica.', style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.justify) :
              ruleA == false || ruleB == false || ruleC == false ?
                Text('A lo largo del tiempo, el lunar en cuestión ha experimentado alteraciones en: $text y ha cambiado su naturaleza de no displásica a displásica.', style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.justify) :
                const Text(""),
            ],
          ),
        ),
      );
    }
    else {
      return Card(
        color: const Color(0xFFf7fcfc),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF00807E)), // Cambia el color a tu preferencia
          borderRadius: BorderRadius.circular(10), // Ajusta el radio del borde según tus necesidades
        ),
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Column(
            children: [
              Text('CONCLUSIÓN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp), textAlign: TextAlign.center),

              SizedBox(
                height: 1.h,
              ),

              ruleA == true && ruleB == true && ruleC == true ?
              Text('A lo largo del tiempo, el lunar en cuestión no ha experimentado alteraciones en: Asimetría - Borde - Color y ha cambiado su naturaleza de displásica a no displásica.', style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.justify) :
              ruleA == false || ruleB == false || ruleC == false ?
              Text('A lo largo del tiempo, el lunar en cuestión ha experimentado alteraciones en: $text y ha cambiado su naturaleza de displásica a no displásica.', style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.justify) :
              const Text(""),
            ],
          ),
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Comparación",style: TextStyle(color: Colors.white)), // Nombre de la página que puedes cambiar dinámicamente según la página actual.
              backgroundColor: const Color(0xFF00807E),
              iconTheme: const IconThemeData(color: Colors.white),
              actions: <Widget>[
                Image.asset('assets/logo-nevuscheck.png', fit: BoxFit.contain),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(2.h),
                child: Column(
                  children: [

                    cardConclusion(consultation, lastConsultation.keys.first),

                    Card(
                      color: const Color(0xFFf7fcfc),
                      child: Padding(
                        padding: EdgeInsets.all(2.w),
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
                                      consultation.resultDiameter == "The diameter can measure manually. If the diameter is greater than 6mm, a specialist should be consulted." ? "El diámetro lo puede medir manualmente. En caso de que el diámetro sea mayor a 6mm, se debe dirigir a un especialista." : "",
                                      style: TextStyle(fontSize: 10.sp),
                                      maxLines: 6,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Divider(
                      color: Color(0xFF00807E),
                      thickness: 2.5,
                    ),

                    Card(
                      color: const Color(0xFFf7fcfc),
                      child: Padding(
                        padding: EdgeInsets.all(2.w),
                        child: Column(
                          children: [
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

                                  Expanded(
                                    child: Text(
                                      lastConsultation.keys.first.resultDiameter == "The diameter can measure manually. If the diameter is greater than 6mm, a specialist should be consulted." ? "El diámetro lo puede medir manualmente. En caso de que el diámetro sea mayor a 6mm, se debe dirigir a un especialista." : "",
                                      style: TextStyle(fontSize: 10.sp),
                                      maxLines: 6,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          );
        }
    );
  }
}
