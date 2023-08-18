import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PreventiveInformation extends StatefulWidget {
  const PreventiveInformation({super.key});

  @override
  State<PreventiveInformation> createState() => _PreventiveInformationState();
}

class _PreventiveInformationState extends State<PreventiveInformation> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Información Preventiva",style: TextStyle(color: Colors.white)), // Nombre de la página que puedes cambiar dinámicamente según la página actual.
              backgroundColor: const Color(0xFF00807E),
              automaticallyImplyLeading: false,
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(2.5.h),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB1D8D7),
                          borderRadius: BorderRadius.circular(15.w),
                        ),

                        child: Padding(
                          padding: EdgeInsets.all(5.w),
                          child: Text(
                            '1. ¿Qué es un nevo displásico?',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),

                          ),
                        ),
                      ),

                      SizedBox(
                        height: 2.5.h,
                      ),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB1D8D7),
                          borderRadius: BorderRadius.circular(15.w),
                        ),

                        child: Padding(
                          padding: EdgeInsets.all(5.w),
                          child: Text(
                            '2. ¿Qué es el melanoma?',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),
                          ),

                        ),
                      ),

                      SizedBox(
                        height: 2.5.h,
                      ),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:const Color(0xFFB1D8D7),
                          borderRadius: BorderRadius.circular(15.w),
                        ),

                        child: Padding(
                          padding: EdgeInsets.all(5.w),
                          child: Text(
                            '3. ¿Este diagnóstico reemplaza el de un doctor?',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),
                          ),

                        ),
                      ),

                      SizedBox(
                        height: 2.5.h,
                      ),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB1D8D7),
                          borderRadius: BorderRadius.circular(15.w),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5.w),
                          child: Text(
                            '4. ¿Cómo funciona el diagnóstico?',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),

                      ),


                      SizedBox(
                        height: 2.5.h,
                      ),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB1D8D7),
                          borderRadius: BorderRadius.circular(15.w),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5.w),
                          child: Text(
                            '5. ¿Cuál es la precisión del resultado?',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),

                      ),

                      SizedBox(
                        height: 2.5.h,
                      ),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB1D8D7),
                          borderRadius: BorderRadius.circular(15.w),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5.w),
                          child: Text(
                            '6. ¿Cada cuánto tiempo es recomendable asistir a un especialista?',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),

                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );

  }
}