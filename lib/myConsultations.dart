import 'dart:collection';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_tesis/api/consultation.dart';
import 'package:proyecto_tesis/api/category.dart';
import 'package:proyecto_tesis/api/service.dart';
import 'package:proyecto_tesis/moleDetail.dart';
import 'package:proyecto_tesis/preventiveInformation.dart';
import 'package:sizer/sizer.dart';
import 'compareResults.dart';
import 'globals.dart' as globals;
import 'dart:convert';

class MyConsultations extends StatefulWidget {

  final int categoryId;
  final String categoryName;

  const MyConsultations({required this.categoryId,required this.categoryName});

  @override
  State<MyConsultations> createState() => _MyConsultationsState();
}

class _MyConsultationsState extends State<MyConsultations> {

  late final Future futureConsultationsByCategoryId;
  List<Consultation> myConsultations = [];
  List<Consultation> auxConsultations = [];
  List<Consultation> filterConsultations = [];

  bool dataLoaded = false;

  int selectedButtonIndex = -1;

  bool isMultiSelectionEnabled=false;
  HashSet selectedItem = HashSet();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    futureConsultationsByCategoryId = service.getConsultationsByCategoryId(widget.categoryId);
    futureConsultationsByCategoryId.then((consultations) => {
      myConsultations = consultations,
      auxConsultations = List<Consultation>.from(myConsultations),
      filterConsultations = List<Consultation>.from(myConsultations),
      print(auxConsultations[0].createdDate),
      print(myConsultations[0].createdDate),
      setState(() {
        myConsultations;
        dataLoaded = true;
      }),
    });
  }

  List<Consultation> filterConsultation(int index) {
    if (index == 0) {
      final sorted = filterConsultations..sort((a, b) => DateFormat("dd/MM/yyyy HH:mm:ss").parse(a.createdDate).compareTo(DateFormat("dd/MM/yyyy HH:mm:ss").parse(b.createdDate)));
      return sorted;
    } else {
      final sorted = filterConsultations..sort((a, b) => DateFormat("dd/MM/yyyy HH:mm:ss").parse(b.createdDate).compareTo(DateFormat("dd/MM/yyyy HH:mm:ss").parse(a.createdDate)));
      return sorted;
    }
  }

  void setFilter(int index) {
    setState(() {
      if (selectedButtonIndex == index) {
        selectedButtonIndex = -1;
        auxConsultations = myConsultations;
      } else {
        selectedButtonIndex = index;
        auxConsultations = filterConsultation(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          appBar: AppBar(
            leading: isMultiSelectionEnabled?
            IconButton(onPressed: (){
              setState(() {
                isMultiSelectionEnabled=false;
                selectedItem.clear();
                print('selecteditem');
                print(selectedItem);
              });
            }, icon: const Icon(Icons.close)) :null,
            title: Text(isMultiSelectionEnabled? getHeaderCountText(): 'Mis consultas', style: TextStyle(color: Colors.white),),
            backgroundColor: const Color(0xFF00807E),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(top: 5.w, left: 5.w, right:5.w),
                child: Column(
                  children: [

                    ToggleButtons(
                      isSelected: [selectedButtonIndex == 0, selectedButtonIndex == 1],
                      onPressed: (index) => setFilter(index),
                      selectedColor: Colors.white,
                      fillColor: const Color(0xFF00807E), // Color de fondo del botón activo
                      borderRadius: BorderRadius.circular(50.sp),
                      borderWidth: 0.5.w,
                      selectedBorderColor: const Color(0xFF00807E),
                      borderColor: const Color(0xFF00807E),
                      children: [
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
                    auxConsultations.isEmpty ?
                    Center(
                      child: Text("No hay consultas disponibles", style: TextStyle(fontSize: 16.sp)),
                    ) :
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: 1, //myCategoryConsultation
                        itemBuilder: (context, index) {
                          // final startIndex = index * 3;
                          // final endIndex = startIndex + 3;
                          // final currentConsultations = auxConsultations.sublist(startIndex, endIndex < auxConsultations.length ? endIndex : auxConsultations.length);
                          return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 1.h, mainAxisSpacing: 1.h),
                            shrinkWrap: true,
                            itemCount: auxConsultations.length,
                            itemBuilder: (context,index){
                              var consultation = auxConsultations[index];

                              String date = consultation.createdDate;
                              String datePart = date.split(' ')[0];

                              return GestureDetector(
                                onTap: (){
                                  doMultiSelection(consultation.idConsultation,consultation);
                                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MoleDetail(consultation: consultation,categoryName:widget.categoryName)));
                                },
                                onLongPress: () {
                                  if(!isMultiSelectionEnabled){
                                    isMultiSelectionEnabled=true;
                                  }
                                  doMultiSelection(consultation.idConsultation,consultation);
                                },
                                child: Column(
                                  children: [

                                    Expanded(
                                      child: Stack(
                                        children: [
                                          _buildConsultationImage(consultation),

                                          if(selectedItem.contains(consultation.idConsultation))
                                            const Positioned.fill(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Icon(Icons.check,color:Colors.white,size:30),
                                              )
                                            )
                                        ],
                                      ),
                                    ),

                                    // Expanded(child: Image.memory(const Base64Decoder().convert(consultation.photo),width: 20.w,height: 20.h, fit: BoxFit.cover)),

                                    SizedBox(height: 0.5.h),

                                    Text(datePart,style: TextStyle(color: Colors.black,fontSize: 10.sp,fontWeight: FontWeight.bold)),

                                    SizedBox(height: 2.5.h),
                                  ],
                                ),
                              );

                            });
                          }
                      ),
                    ) :
                    const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00807E)))),

                  ],
                )
            ),
          ),
          bottomNavigationBar: isMultiSelectionEnabled ?
            BottomAppBar(
            height: 12.h,
            color: Color(0xFFB1D8D7),
            child: SizedBox(
              height: 10.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () async {

                          bool allSuccessful = true;

                          for (var id in selectedItem) {
                            var result = await service.deleteConsultationById(id);
                            if (result != 1) {
                              allSuccessful = false;
                              break; // Si alguna respuesta no es 1, no es necesario seguir iterando.
                            }
                          }

                          if (allSuccessful) {
                            setState(() {
                              myConsultations.removeWhere((consultation) => selectedItem.contains(consultation.idConsultation));
                              filterConsultations.removeWhere((consultation) => selectedItem.contains(consultation.idConsultation));
                              auxConsultations.removeWhere((consultation) => selectedItem.contains(consultation.idConsultation));
                              selectedItem.clear();
                            });
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Hubo un error al eliminar la consulta.",
                                  style: TextStyle(
                                      color: Colors.black),
                                ),
                                backgroundColor: Color(0xFF00807E),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.delete),
                        color: const Color(0xFF00807E),
                      ),
                      Text("Eliminar", style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold,color: const Color(0xFF00807E))),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (selectedItem.isEmpty || selectedItem.length != 2) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Seleccionar 2 consultas para comparar", style: TextStyle(color: Colors.black)),
                              backgroundColor: Colors.redAccent,
                            ));
                          } else {
                            // myConsultations;
                            SplayTreeSet<int> sortSelectedItem = SplayTreeSet<int>.from(selectedItem);
                            List<Consultation> selectedConsultations = myConsultations
                              .where((c) => sortSelectedItem.contains(c.idConsultation))
                              .toList();

                            Map<Consultation, Category> convertToMap = {
                              selectedConsultations[0]: Category(idCategory: widget.categoryId, name: widget.categoryName),
                            };

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CompareResults(lastConsultation: convertToMap, consultation: selectedConsultations[1], category: widget.categoryName)),
                            );

                          }
                        },
                        icon: const Icon(Icons.compare),
                        color: const Color(0xFF00807E),
                      ),
                      Text("Comparar", style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold,color: const Color(0xFF00807E))),
                    ],
                  ),
                  // You can add more buttons or widgets here
                ],
              ),
            ),
          ) : null,
        );
      }
    );
  }
  Widget _buildConsultationImage(Consultation consultation) {
    return Image.memory(
      const Base64Decoder().convert(consultation.photo),
      width: 25.w,
      height: 30.h,
      fit: BoxFit.cover,
    );
  }

  String getHeaderCountText(){
    return selectedItem.isNotEmpty? "${selectedItem.length} foto(s) seleccionada(s)" : "Ninguna imagen seleccionada";
  }

  void doMultiSelection(int path,consultation) {

    if(isMultiSelectionEnabled){
      setState(() {
        if (selectedItem.contains(path)) {
          selectedItem.remove(path);
        } else {
          selectedItem.add(path);
        }
      });
    }
    else{
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MoleDetail(consultation: consultation,categoryName:widget.categoryName)));
    }

    print(selectedItem);
  }
}






