import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:proyecto_tesis/cameraConsultation.dart';
import 'package:proyecto_tesis/login.dart';
import 'package:proyecto_tesis/myAccount.dart';
import 'package:proyecto_tesis/register.dart';
import 'package:proyecto_tesis/myCategories.dart';
import 'package:proyecto_tesis/preventiveInformation.dart';
import 'globals.dart' as globals;

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  // int r;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  int _paginaActual=0;
  List<Widget> _paginas =[
    const MyCategories(),
    const CameraConsultation(),
    const PreventiveInformation(),
    globals.isLoggedIn ? const MyAccount() : const Login(),
  ];


  @override
  void initState() {
    super.initState();
    _paginaActual = globals.idNavigation;


    _paginas =[
      const MyCategories(),
      const CameraConsultation(),
      const PreventiveInformation(),
      globals.isLoggedIn ? const MyAccount() : const Login(),
    ];

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _paginas[_paginaActual],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap:(index){
          setState(() {
            _paginaActual=index;
          });
        },
        currentIndex: _paginaActual,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.apps),label:"Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo),label:"Buscar"),
          BottomNavigationBarItem(icon: Icon(Icons.import_contacts),label:"Agregar Receta"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label:"Mi Cuenta")
        ],

      ),

    );
  }
}
