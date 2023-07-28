import 'dart:developer';

import 'package:flutter/material.dart';

class PreventiveInformation extends StatefulWidget {
  const PreventiveInformation({super.key});

  @override
  State<PreventiveInformation> createState() => _PreventiveInformationState();
}

class _PreventiveInformationState extends State<PreventiveInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'INFORMACIÓN PREVENTIVA',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(15),
                  ),

                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        '1. ¿Qué es un nevo displásico?',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),

                    ),
                  ),
                ),

                SizedBox(
                  height: 40,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(15),
                  ),

                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        '2. ¿Qué es el melanoma?',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),

                  ),
                ),

                SizedBox(
                  height: 40,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(15),
                  ),

                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        '3. ¿Este diagnóstico reemplaza el de un doctor?',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),

                  ),
                ),

                SizedBox(
                  height: 40,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(15),
                  ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        '4. ¿Cómo funciona el diagnóstico?',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
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
}
