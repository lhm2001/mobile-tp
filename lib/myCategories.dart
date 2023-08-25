import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_tesis/api/consultation.dart';
import 'package:proyecto_tesis/api/service.dart';
import 'package:proyecto_tesis/myConsultations.dart';
import 'package:proyecto_tesis/preventiveInformation.dart';
import 'api/category.dart';
import 'globals.dart' as globals;
import 'dart:convert';
import 'package:sizer/sizer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyCategories extends StatefulWidget {
  const MyCategories({Key? key}) : super(key: key);

  @override
  State<MyCategories> createState() => _MyCategoriesState();
}

class _MyCategoriesState extends State<MyCategories> {
  // const MyCategories({Key? key}) : super(key: key);
  List<Category> categories = [];

  final userId = globals.userId;

  late final Future futureCategoriesByUserId;
  Map<Category, Consultation> myCategoryConsultation = {};

  int selectedButtonIndex = -1;
  bool dataLoaded = false;

  Map<Category, Consultation> auxCategoryConsultation = {};
  Map<Category, Consultation> filCategoryConsultation = {};

  late TextEditingController categoryName = TextEditingController();

  @override
  void initState() {
    super.initState();

    futureCategoriesByUserId = service.getCategoriesByUserId(globals.userId);
    futureCategoriesByUserId.then((allCategories) => {
      processLastConsultationByCategoryId(allCategories),
    });
  }

  Future<void> processLastConsultationByCategoryId(List<Category> categories) async {
    for (Category c in categories) {
      Consultation lastConsultation = await service.getLastConsultationByCategoryId(c.idCategory);
      print("lastConsultation: ${lastConsultation.toString()}");
      myCategoryConsultation[c] = lastConsultation;
    }

    auxCategoryConsultation.addAll(myCategoryConsultation);
    filCategoryConsultation.addAll(myCategoryConsultation);
    setState(() {
      auxCategoryConsultation;
      myCategoryConsultation;
      filCategoryConsultation;
      dataLoaded = true;
    });
    print("myCategoryConsultationK ${myCategoryConsultation.keys.toString()}");
    print("myCategoryConsultationV ${myCategoryConsultation.values.toString()}");
    print("auxCategoryConsultation ${auxCategoryConsultation.toString()}");
  }

  String getTimeDifference(String uploadDateTime) {
    DateTime now = DateTime.now();
    DateTime uploadTime = DateFormat("dd/MM/yyyy HH:mm:ss").parse(uploadDateTime);
    Duration difference = now.difference(uploadTime);
    return "${difference.inDays}";
  }

  Map<Category, Consultation> filterCategoryConsultation(int index) {

    if (index == 0) {
      final sortedKeys = filCategoryConsultation.keys.toList()..sort((a, b) => a.name.compareTo(b.name));
      final sortedMap = Map.fromEntries(sortedKeys.map((key) => MapEntry(key, filCategoryConsultation[key]!)));
      print("SORT: $sortedMap");
      return sortedMap;
    } else if (index == 1) {
      final sortedKeys = filCategoryConsultation.keys.toList()..sort((a, b) => b.name.compareTo(a.name));
      final sortedMap = Map.fromEntries(sortedKeys.map((key) => MapEntry(key, filCategoryConsultation[key]!)));
      return sortedMap;
    } else if (index == 2) {
      final sortedEntries = filCategoryConsultation.entries.toList()..sort((a, b) => DateFormat("dd/MM/yyyy HH:mm:ss").parse(a.value.createdDate).compareTo(DateFormat("dd/MM/yyyy HH:mm:ss").parse(b.value.createdDate)));
      final sortedMap = Map.fromEntries(sortedEntries);
      return sortedMap;
    } else {
      final sortedEntries = filCategoryConsultation.entries.toList()..sort((a, b) => DateFormat("dd/MM/yyyy HH:mm:ss").parse(b.value.createdDate).compareTo(DateFormat("dd/MM/yyyy HH:mm:ss").parse(a.value.createdDate)));
      final sortedMap = Map.fromEntries(sortedEntries);
      return sortedMap;
    }

  }

  void setFilter(int index) {
    setState(() {
      if (selectedButtonIndex == index) {
        selectedButtonIndex = -1;
        print("NO HAY NADA");
        auxCategoryConsultation = myCategoryConsultation; // Deseleccionar y restablecer el mapa filtrado
      } else {
        selectedButtonIndex = index;
        auxCategoryConsultation = filterCategoryConsultation(index); // Realizar la operación de filtrado aquí
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(globals.isLoggedIn);
    globals.isLoggedIn? print("logged"): print("not logged");

    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Mis Lunares", style: TextStyle(color: Colors.white),), // Nombre de la página que puedes cambiar dinámicamente según la página actual.
            backgroundColor: const Color(0xFF00807E),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              Image.asset('assets/logo-nevuscheck.png', fit: BoxFit.contain),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(top: 5.w, left: 5.w, right:5.w),
                child: Column(
                  children: [

                    ToggleButtons(
                      isSelected: [selectedButtonIndex == 0, selectedButtonIndex == 1, selectedButtonIndex == 2, selectedButtonIndex == 3],
                      onPressed: (index) => setFilter(index),
                      selectedColor: Colors.white,
                      fillColor: const Color(0xFF00807E),
                      borderRadius: BorderRadius.circular(50.sp),
                      borderWidth: 0.5.w,
                      selectedBorderColor: const Color(0xFF00807E),
                      borderColor: const Color(0xFF00807E),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(1.w),
                          child: Text('A-Z', style: TextStyle(fontSize: 10.sp)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(1.w),
                          child: Text('Z-A', style: TextStyle(fontSize: 10.sp)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(1.w),
                          child: Text('ASC', style: TextStyle(fontSize: 10.sp)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(1.w),
                          child: Text('DES', style: TextStyle(fontSize: 10.sp)),
                        )
                      ],
                    ),

                    SizedBox(
                      height: 5.w,
                    ),

                    dataLoaded ?
                    auxCategoryConsultation.isEmpty ?
                    Center(
                      child: Text("No hay categorías disponibles", style: TextStyle(fontSize: 16.sp)),
                    ) :
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: auxCategoryConsultation!.keys.length, //myCategoryConsultation
                        itemBuilder: (context, index) {
                          return Slidable(
                            key: const ValueKey(0),
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (BuildContext context) async {
                                    var deletedCategoryId = auxCategoryConsultation!.keys.elementAt(index).idCategory;
                                    var result = await service.deleteCategoryById(deletedCategoryId);
                                    print(result);
                                    if (result == 1) {

                                      // Eliminación exitosa, actualiza el estado
                                      setState(() {
                                        categories.removeWhere((cat) =>
                                        cat.idCategory ==
                                            deletedCategoryId);
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Hubo un error al eliminar la categoría.",
                                            style: TextStyle(
                                                color: Colors.black),
                                          ),
                                          backgroundColor:
                                          Colors.tealAccent,
                                        ),
                                      );
                                    }
                                  },
                                  backgroundColor: Color(0xFF00807E),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  // label: 'Eliminar',
                                ),

                                SlidableAction(
                                  onPressed: (BuildContext context) {
                                    categoryName.text = auxCategoryConsultation!.keys.elementAt(index).name;

                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => Dialog(
                                        backgroundColor: Color(0XFFcce5e5),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child:Padding(
                                                  padding: EdgeInsets.all(1.h),
                                                  child: TextField(
                                                    controller: categoryName,
                                                    decoration: const InputDecoration(
                                                      border:InputBorder.none,
                                                      hintText: 'Nombre de categoría',
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: 2.5.h),

                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: const Color(0xFFffffff),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0), // Ajusta el valor según desees
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  if(categoryName.text.isNotEmpty){
                                                    var updateId = auxCategoryConsultation!.keys.elementAt(index).idCategory;
                                                    var result = await service.updateCategoryById(categoryName.text,updateId);
                                                    print(result);
                                                    if (result == 1) {

                                                      service.getCategoriesByUserId(globals.userId)
                                                          .then((allCategories) {
                                                        dataLoaded=false;
                                                        auxCategoryConsultation.clear();
                                                        myCategoryConsultation.clear();
                                                        filCategoryConsultation.clear();
                                                        processLastConsultationByCategoryId(allCategories);

                                                        Navigator.pop(context); // Cierra el diálogo
                                                      })
                                                          .catchError((error) {
                                                        print("Error while fetching categories: $error");
                                                        // Maneja el error si es necesario
                                                      });
                                                    }
                                                    else {
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            "Hubo un error al actualizar el nombre de la categoría.",
                                                            style: TextStyle(
                                                                color: Colors.black),
                                                          ),
                                                          backgroundColor:
                                                          Colors.tealAccent,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                  else{
                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                      content: Text("Debe colocar un nombre",
                                                          style: TextStyle(color: Colors.black)
                                                      ),
                                                      backgroundColor: Colors.tealAccent,
                                                    ));
                                                  }

                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(2.3.w),
                                                  child: Text("Guardar",style:TextStyle(
                                                    //fontWeight: FontWeight.bold,
                                                      fontSize: 12.sp,
                                                      color: Colors.black
                                                  )),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  backgroundColor: Color(0xFF5177A1),
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  // label: 'Editar',
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyConsultations(categoryId: auxCategoryConsultation!.keys.elementAt(index).idCategory, categoryName: auxCategoryConsultation!.keys.elementAt(index).name)));
                              },
                              child: Card(
                                color: const Color(0xFFf7fcfc),
                                child: Padding(
                                  padding: EdgeInsets.all(2.w),
                                  child: Row(
                                    children: [

                                      SizedBox(
                                        width: 12.h,
                                        height: 12.h,
                                        child: auxCategoryConsultation.values.elementAt(index).idConsultation !=0 ?
                                        ClipRRect(borderRadius: BorderRadius.circular(10.0),child: Image.memory(Base64Decoder().convert(auxCategoryConsultation.values.elementAt(index).photo), fit: BoxFit.cover)) :
                                        ClipRRect(borderRadius: BorderRadius.circular(10.0),child: Image.asset('assets/mole.png')),
                                      ),

                                      SizedBox(width: 2.5.w),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Text(auxCategoryConsultation.keys.elementAt(index).name,style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold)),

                                          SizedBox(height: 2.5.h),

                                          getTimeDifference(auxCategoryConsultation.values.elementAt(index).createdDate) == 1 ?
                                          SizedBox(
                                              width: 45.w,
                                              child: Text('Última foto tomada hace ${getTimeDifference(auxCategoryConsultation.values.elementAt(index).createdDate)} día', style: TextStyle(color: Colors.black, fontSize: 8.sp), maxLines: 3, overflow: TextOverflow.clip)
                                          ) :
                                          SizedBox(
                                              width: 45.w,
                                              child: Text('Última foto tomada hace ${getTimeDifference(auxCategoryConsultation.values.elementAt(index).createdDate)} días', style: TextStyle(color: Colors.black, fontSize: 8.sp), maxLines: 3, overflow: TextOverflow.clip)
                                          )

                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ) :
                    const Center(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00807E))),
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





