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
      text = "asimetría";
    }

    if (firstConsultation.resultBorder != secondConsultation.resultBorder) {
      ruleB = false;
      if (text.isNotEmpty) {
        text = "$text, borde";
      }
      else {
        text = "borde";
      }
    }

    if (firstConsultation.resultColor != secondConsultation.resultColor) {
      ruleC = false;
      if (text.isNotEmpty) {
        text = "$text y color";
      }
      else {
        text = "color";
      }
    }
    else {
      if (text.contains("asimetría") == true && text.contains("borde") == true) {
        text = "asimetría y borde";
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

              Text('En el transcurso del tiempo, el lunar interesado no ha experimentado alteraciones en cuanto a su asimetría, borde y color. Asimismo, mantiene su naturaleza no displásica. En consecuencia, no se observan indicios de preocupación médica relacionados con este lunar.', style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.justify),
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
                Text('En el transcurso del tiempo, el lunar interesado no ha experimentado alteraciones en cuanto a su asimetría, borde y color. Asimismo, mantiene su naturaleza displásica. En consecuencia, se sugiere que consultes a un dermatólogo para una evaluación más detallada de este lunar y para determinar si es necesario realizar una biopsia u otro procedimiento médico para descartar cualquier riesgo potencial.', style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.justify) :
              ruleA == false || ruleB == false || ruleC == false ?
                Text('En el transcurso del tiempo, el lunar interesado ha experimentado alteraciones en cuanto a su $text. Asimismo, mantiene su naturaleza displásica. En consecuencia, es de suma importancia buscar atención médica de manera inmediata. Estos cambios podrían indicar un riesgo potencial, y es esencial que un dermatólogo realice una evaluación detallada y determine el curso de acción necesario, que podría incluir una biopsia o tratamiento adicional según sea necesario para garantizar la salud y seguridad del paciente.', style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.justify) :
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
                Text('En el transcurso del tiempo, el lunar interesado no ha experimentado alteraciones en cuanto a su asimetría, borde y color. Asimismo, ha cambiado su naturaleza de no displásica a displásica. En consecuencia, se recomienda encarecidamente buscar atención médica de inmediato. Este cambio podría indicar un riesgo potencial para la salud, y es esencial que un dermatólogo realice una evaluación exhaustiva y determine el plan de tratamiento o seguimiento necesario para garantizar la salud y el bienestar del paciente.', style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.justify) :
              ruleA == false || ruleB == false || ruleC == false ?
                Text('En el transcurso del tiempo, el lunar interesado ha experimentado alteraciones en cuanto a su $text. Asimismo, ha cambiado su naturaleza de no displásica a displásica. En consecuencia, se recomienda encarecidamente buscar atención médica de inmediato. Estos cambios podrían indicar un riesgo potencial para la salud, y es esencial que un dermatólogo realice una evaluación exhaustiva y determine el plan de tratamiento o seguimiento necesario para garantizar la salud y el bienestar del paciente.', style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.justify) :
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
              Text('En el transcurso del tiempo, el lunar interesado no ha experimentado alteraciones en cuanto a su asimetría, borde y color. Asimismo, ha cambiado su naturaleza de displásica a no displásica. En consecuencia, es probable que no represente una preocupación médica significativa. Sin embargo, se recomienda programar una consulta con un dermatólogo para una evaluación completa y confirmar que no se requiere ningún tratamiento o seguimiento adicional para garantizar su salud a largo plazo.', style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.justify) :
              ruleA == false || ruleB == false || ruleC == false ?
              Text('En el transcurso del tiempo, el lunar interesado ha experimentado alteraciones en cuanto a su $text. Asimismo, ha cambiado su naturaleza de displásica a no displásica. En consecuencia, es menos probable que represente una preocupación médica significativa. Sin embargo, aún se recomienda programar una consulta con un dermatólogo para una evaluación completa y confirmar que no se necesite ningún tratamiento o seguimiento adicional para garantizar su salud a largo plazo.', style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.justify) :
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

                    SizedBox(height: 1.h),

                    Card(
                      color: const Color(0xFFf7fcfc),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xFF00807E)), // Cambia el color a tu preferencia
                        borderRadius: BorderRadius.circular(10), // Ajusta el radio del borde según tus necesidades
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(2.w),
                        child: Column(
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Row(
                                  children: [
                                    Text(lastConsultation.values.first.name, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10.sp)),

                                    SizedBox(width: 12.5.w),

                                    Text(lastConsultation.keys.first.createdDate.substring(0, 10),style: TextStyle(fontSize: 10.sp))
                                  ],
                                ),

                                SizedBox(width: 5.w),

                                Row(
                                  children: [
                                    Text(category, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10.sp)),

                                    SizedBox(width: 12.5.w),

                                    Text(consultation.createdDate.substring(0, 10),style: TextStyle(fontSize: 10.sp))
                                  ],
                                ),

                              ],
                            ),

                            SizedBox(height: 1.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Row(
                                  children: [
                                    Image.memory(const Base64Decoder().convert(lastConsultation.keys.first.photo), width: 40.w, height: 20.h),
                                  ],
                                ),

                                SizedBox(width: 5.w),

                                Row(
                                  children: [
                                    Image.memory(const Base64Decoder().convert(consultation.photo), width: 40.w, height: 20.h),
                                  ],
                                ),

                              ],
                            ),

                            SizedBox(height: 1.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                Row(
                                  children: [
                                    Text("Lunar ${lastConsultation.keys.first.dysplastic ? "Displásico" : "No Displásico"}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.sp)),
                                  ],
                                ),

                                SizedBox(width: 5.w),

                                Row(
                                  children: [
                                    Text("Lunar ${consultation.dysplastic ? "Displásico" : "No Displásico"}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.sp)),
                                  ],
                                ),

                              ],
                            ),

                            SizedBox(height: 2.5.h),

                            Align(
                              alignment: Alignment.center,
                              child: Text("Resultados",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp)),
                            ),

                            SizedBox(height: 1.h),

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
                                    lastConsultation.keys.first.resultAssymetry == 'Asymmetric' && consultation.resultAssymetry == 'Asymmetric' ? "Ambos son asimétricos" :
                                    lastConsultation.keys.first.resultAssymetry != 'Asymmetric' && consultation.resultAssymetry == 'Asymmetric' ? "Simétrico -> Asimétrico" :
                                    lastConsultation.keys.first.resultAssymetry == 'Asymmetric' && consultation.resultAssymetry != 'Asymmetric' ? "Asimétrico -> Simétrico" : "Ambos son simétricos",
                                    style: TextStyle(fontSize: 10.sp),
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
                                    lastConsultation.keys.first.resultBorder == 'Regular' && consultation.resultBorder == 'Regular' ? "Ambos son regulares" :
                                    lastConsultation.keys.first.resultBorder != 'Regular' && consultation.resultBorder == 'Regular' ? "Irregular -> Regular" :
                                    lastConsultation.keys.first.resultBorder == 'Regular' && consultation.resultBorder != 'Regular' ? "Regular -> Irregular" : "Ambos son irregulares",
                                    style: TextStyle(fontSize: 10.sp),
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
                                    lastConsultation.keys.first.resultColor == 'Heterogeneous' && consultation.resultColor == 'Heterogeneous' ? "Ambos son heterogéneos" :
                                    lastConsultation.keys.first.resultColor != 'Heterogeneous' && consultation.resultColor == 'Heterogeneous' ? "Homogéneo -> Heterogéneo" :
                                    lastConsultation.keys.first.resultColor == 'Heterogeneous' && consultation.resultColor != 'Heterogeneous' ? "Heterogéneo -> Homogéneo" : "Ambos son homogéneos",
                                    style: TextStyle(fontSize: 10.sp),
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
                  ],
                ),
              ),
            )
          );
        }
    );
  }
}
