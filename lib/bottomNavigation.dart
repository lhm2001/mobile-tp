import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:proyecto_tesis/login.dart';
import 'package:proyecto_tesis/register.dart';
import 'package:proyecto_tesis/myCategories.dart';
import 'package:proyecto_tesis/preventiveInformation.dart';
import 'globals.dart' as globals;

class bottomNavigation extends StatefulWidget {
  const bottomNavigation({Key? key}) : super(key: key);

  // int r;

  @override
  State<bottomNavigation> createState() => _bottomNavigationState();
}

class _bottomNavigationState extends State<bottomNavigation> {

  int _paginaActual=0;
  List<Widget> _paginas =[
    myCategories(),
    register(),
    PreventiveInformation(),
    globals.isLoggedIn ? PreventiveInformation() : login(),
  ];


  //late List<Widget> _paginas;

  @override
  void initState() {
    super.initState();
    _paginaActual = globals.idNavigation;


    _paginas =[
      myCategories(),
      register(),
      PreventiveInformation(),
      globals.isLoggedIn ? PreventiveInformation() : login(),
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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label:"Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search),label:"Buscar"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline),label:"Agregar Receta"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label:"Mi Cuenta")
        ],

      ),

    );
  }
}
