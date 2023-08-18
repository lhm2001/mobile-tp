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
  List<Category> categories = []; // Define una lista para almacenar categorías

  @override
  Widget build(BuildContext context) {
    print(globals.isLoggedIn);
    final userId = globals.userId;

    globals.isLoggedIn ? print("logged") : print("not logged");

    String getTimeDifference(String uploadDateTime) {
      DateTime now = DateTime.now();
      DateTime uploadTime =
      DateFormat("dd/MM/yyyy HH:mm:ss").parse(uploadDateTime);
      Duration difference = now.difference(uploadTime);
      return "${difference.inDays}";
    }

    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Mis Lunares",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF00807E),
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 10.w, left: 5.w, right: 5.w),
              child: Column(
                children: [
                  FutureBuilder(
                    initialData: const [],
                    future: service.getCategoriesByUserId(userId),
                    builder: (context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error al cargar las categorías.');
                      } else {
                        categories = (snapshot.data as List<Category>) ?? []; // Realiza una conversión
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            var category = categories[index];
                            if (snapshot.hasData) {
                              return FutureBuilder<Consultation>(
                                future: service.getLastConsultationByCategoryId(
                                    category.idCategory),
                                builder: (context, snapshotMultimedia) {
                                  if (snapshotMultimedia.hasData) {
                                    var consultation = snapshotMultimedia.data!;
                                    return Slidable(
                                      key: const ValueKey(0),
                                      endActionPane: ActionPane(
                                        motion: ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (BuildContext context) async {
                                              var deletedCategoryId = category.idCategory;
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
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MyConsultations(
                                                    categoryId: category.idCategory,
                                                    categoryName: category.name,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: EdgeInsets.all(2.w),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 12.h,
                                                  height: 12.h,
                                                  child: consultation.idConsultation !=
                                                      0
                                                      ? ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10.0),
                                                    child: Image.memory(
                                                      Base64Decoder()
                                                          .convert(consultation
                                                          .photo),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                      : ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10.0),
                                                    child: Image.asset(
                                                        'assets/mole.png'),
                                                  ),
                                                ),
                                                SizedBox(width: 2.5.w),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      category.name.toString(),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 2.5.h),
                                                    getTimeDifference(consultation
                                                        .createdDate) ==
                                                        1
                                                        ? SizedBox(
                                                      width: 45.w,
                                                      child: Text(
                                                        'Última foto tomada hace ${getTimeDifference(consultation.createdDate)} día',
                                                        style: TextStyle(
                                                          color:
                                                          Colors.black,
                                                          fontSize: 8.sp,
                                                        ),
                                                        maxLines: 3,
                                                        overflow:
                                                        TextOverflow
                                                            .clip,
                                                      ),
                                                    )
                                                        : SizedBox(
                                                      width: 45.w,
                                                      child: Text(
                                                        'Última foto tomada hace ${getTimeDifference(consultation.createdDate)} días',
                                                        style: TextStyle(
                                                          color:
                                                          Colors.black,
                                                          fontSize: 8.sp,
                                                        ),
                                                        maxLines: 3,
                                                        overflow:
                                                        TextOverflow
                                                            .clip,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
