import 'dart:developer';

import 'package:proyecto_tesis/api/consultation.dart';

class listConsultation{

  static List<Consultation> listaConsultation(List<dynamic> listaJson){
    List<Consultation> listadoConsultation=[];
    if(listaJson!=null){
      for(var c in listaJson){
        final ca=Consultation.objJson(c);
        listadoConsultation.add(ca);
      }
    }
    return listadoConsultation;
  }
}