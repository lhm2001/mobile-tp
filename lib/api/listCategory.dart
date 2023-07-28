import 'dart:developer';

import 'package:proyecto_tesis/api/category.dart';

class listCategory{

  static List<Category> listaCategory(List<dynamic> listaJson){
    List<Category> listadoCategory=[];
    //log('listadoRecipepre: $listaJson');
    if(listaJson!=null){
      for(var c in listaJson){
        //log('c: $c');
        final ca=Category.objJson(c);
        // final e=ca.id;
        //final ing=ca.ingredients;
        //log("id:$e");
        // log("ingre:$ing");
        log('ca: $ca');
        // inspect(ca);
        listadoCategory.add(ca);
        //log('aaaaa: $listadoRecipe');
      }
    }
    //log('data: $listadoRecipe');
    return listadoCategory;
  }
}