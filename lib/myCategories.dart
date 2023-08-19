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
                      fillColor: const Color(0xFF00807E), // Color de fondo del botón activo
                      borderRadius: BorderRadius.circular(50.sp),
                      borderWidth: 0.5.w,
                      selectedBorderColor: Colors.tealAccent,
                      borderColor: Colors.tealAccent,
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
                                  label: 'Eliminar',
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyConsultations(categoryId: auxCategoryConsultation!.keys.elementAt(index).idCategory, categoryName: auxCategoryConsultation!.keys.elementAt(index).name)));
                              },
                              child: Card(
                                color: const Color(0xFFB1D8D7),
                                child: Padding(
                                  padding: EdgeInsets.all(1.w),
                                  child: Row(
                                    children: [

                                      SizedBox(
                                        width: 15.h,
                                        height: 15.h,
                                        child: auxCategoryConsultation.values.elementAt(index).idConsultation !=0 ? Image.memory(Base64Decoder().convert(auxCategoryConsultation.values.elementAt(index).photo), fit: BoxFit.cover) : Image.asset('assets/mole.png'),
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
                      child: CircularProgressIndicator(),
                    ),


                    //COMENTADO

                    // FutureBuilder(
                    //   initialData: const [],
                    //   future: service.getCategoriesByUserId(userId),
                    //   builder: (context, AsyncSnapshot<List> snapshot){
                    //     return ListView.builder(
                    //       shrinkWrap: true,
                    //       itemCount: snapshot.data!.length,
                    //       itemBuilder: (context,index){
                    //         var category=snapshot.data![index];
                    //         if(snapshot.hasData){
                    //           return FutureBuilder<Consultation>(
                    //               future: service.getLastConsultationByCategoryId(category.idCategory),
                    //               builder: (context,snapshotMultimedia){
                    //                 if (snapshotMultimedia.hasData){
                    //                   var consultation=snapshotMultimedia.data!;
                    //                   return GestureDetector(
                    //                     onTap: (){
                    //                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyConsultations(categoryId: category.idCategory,categoryName:category.name)));
                    //                     },
                    //                     child: Card(
                    //                       color: const Color(0xFFB1D8D7),
                    //                       child: Padding(
                    //                         padding: EdgeInsets.all(1.w),
                    //                         child: Row(
                    //                           children: [
                    //
                    //                             SizedBox(
                    //                               width: 15.h,
                    //                               height: 15.h,
                    //                               child: consultation.idConsultation!=0 ? Image.memory(Base64Decoder().convert(consultation.photo), fit: BoxFit.cover) : Image.asset('assets/mole.png'),
                    //                             ),
                    //
                    //                             SizedBox(width: 2.5.w),
                    //
                    //                             Column(
                    //                               crossAxisAlignment: CrossAxisAlignment.start,
                    //                               children: [
                    //
                    //                                 Text(category.name.toString(),style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                    //
                    //                                 SizedBox(height: 2.5.h),
                    //
                    //                                 getTimeDifference(consultation.createdDate) == 1 ?
                    //                                 SizedBox(
                    //                                     width: 45.w,
                    //                                     child: Text('Última foto tomada hace ${getTimeDifference(consultation.createdDate)} día', style: TextStyle(color: Colors.black, fontSize: 8.sp), maxLines: 3, overflow: TextOverflow.clip)
                    //                                 ) :
                    //                                 SizedBox(
                    //                                   width: 45.w,
                    //                                   child: Text('Última foto tomada hace ${getTimeDifference(consultation.createdDate)} días', style: TextStyle(color: Colors.black, fontSize: 8.sp), maxLines: 3, overflow: TextOverflow.clip)
                    //                                 )
                    //
                    //                               ],
                    //                             )
                    //                           ],
                    //                         ),
                    //                       ),
                    //
                    //                     ),
                    //                   );
                    //                 }
                    //                 else {
                    //                   return const Center(
                    //                     child: CircularProgressIndicator(),
                    //                   );
                    //                 }
                    //
                    //               }
                    //
                    //           );
                    //         }
                    //       }
                    //     );
                    //   },
                    // ),

                    //ANTIGUO

                    // FutureBuilder(
                    //   initialData: [],
                    //   future:service.getProfile(),
                    //   builder: (context, AsyncSnapshot<List> snapshot){
                    //     return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2 ),
                    //         shrinkWrap: true,
                    //         itemCount: snapshot.data!.length,
                    //         // itemCount: 2,
                    //         itemBuilder: (context,index){
                    //           if(snapshot.hasData){
                    //             Profile profile=snapshot.data![index];
                    //             //var recipe=users[index];
                    //             return index<2 ?
                    //             Card(
                    //               color: Color(0xFF89250A),
                    //               child: Column(
                    //                 children: [
                    //                   Image.memory(Base64Decoder().convert(profile.profilePictureUrl),width: double.infinity,fit:BoxFit.fitWidth,height: 130,),
                    //                   // Image.network(profile.profilePictureUrl,width: double.infinity,fit:BoxFit.fitHeight,height: 130,),
                    //                   SizedBox(height: 10,),
                    //                   Text(profile.name.toString(),style: TextStyle(color: Colors.white),),
                    //                 ],
                    //               ),
                    //             )
                    //                 :
                    //             Container();
                    //           }
                    //           else {
                    //             return Container(
                    //               child: Center(
                    //                 child: CircularProgressIndicator(),
                    //               ),
                    //             );
                    //           }
                    //
                    //         });
                    //
                    //   },
                    // ),
                    // FutureBuilder(
                    //       initialData: [],
                    //       future:service.getRecipe(),
                    //       builder: (context, AsyncSnapshot<List> snapshot){
                    //         return Transform.scale(
                    //           alignment: FractionalOffset.topCenter,
                    //           scale: 0.4,
                    //           child: ScaledList(
                    //             itemCount: categories.length,
                    //             itemColor: (index) {
                    //               return kMixedColors[index % kMixedColors.length];
                    //             },
                    //             itemBuilder: (index,selectedIndex){
                    //               final category = categories[index];
                    //               return Column(
                    //
                    //                 children: [
                    //                   Container(
                    //
                    //                     height: selectedIndex == index
                    //                         ? 200
                    //                         : 150,
                    //
                    //                       child: FittedBox(
                    //                         fit: BoxFit.fill,
                    //                           child: ClipRRect(
                    //                               borderRadius: BorderRadius.circular(6),
                    //                               child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOjrcB7S_KmVCgLUB80RUCosy2GqgtrP-IyA&usqp=CAU',height: 100,))),
                    //
                    //
                    //                   ),
                    //                   SizedBox(height: 15),
                    //                   Text(
                    //                     category.name,
                    //                     style: TextStyle(
                    //                         color: Colors.white,
                    //                         fontSize: 15),
                    //                   )
                    //                 ],
                    //               );
                    //             },
                    //           ),
                    //         );
                    //
                    //       },
                    //     ),

                  ],
                )
            ),
          ),

        );
      }
    );
  }
}





