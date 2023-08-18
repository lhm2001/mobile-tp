import 'dart:collection';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/api/consultation.dart';
import 'package:proyecto_tesis/api/service.dart';
import 'package:proyecto_tesis/moleDetail.dart';
import 'package:proyecto_tesis/preventiveInformation.dart';
import 'package:sizer/sizer.dart';
import 'globals.dart' as globals;
import 'dart:convert';

class MyConsultations extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const MyConsultations({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  _MyConsultationsState createState() => _MyConsultationsState();
}

class _MyConsultationsState extends State<MyConsultations> {
  late Future<List<Consultation>> consultationsFuture;

  bool isMultiSelectionEnabled=false;
  HashSet selectedItem = HashSet();

  @override
  void initState() {
    super.initState();
    consultationsFuture = service.getConsultationsByCategoryId(widget.categoryId);
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
            }, icon: Icon(Icons.close)) :null,
            title: Text(isMultiSelectionEnabled? getHeaderCountText(): 'Mis consultas', style: TextStyle(color: Colors.white),),
            backgroundColor: const Color(0xFF00807E),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 10.w, left: 5.w, right: 5.w),
              child: Column(
                children: [
                  FutureBuilder(
                    future: consultationsFuture,
                    builder: (context, AsyncSnapshot<List<Consultation>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        final consultations = snapshot.data;

                        if (consultations == null || consultations.isEmpty) {
                          return Center(
                            child: Text("No hay consultas disponibles", style: TextStyle(fontSize: 16.sp)),
                          );
                        } else {
                          return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 0.h, mainAxisSpacing: 0.h),
                            shrinkWrap: true,
                            itemCount: consultations.length,
                            itemBuilder: (context, index) {
                              var consultation = consultations[index];
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
                                            Positioned.fill(child: Align(
                                              alignment: Alignment.center,
                                              child: Icon(Icons.check,color:Colors.white,size:30),
                                            ))
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 0.3.h),
                                    Text(datePart, style: TextStyle(color: Colors.black, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 2.5.h),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: isMultiSelectionEnabled
              ? BottomAppBar(
            color: Color(0xFFB1D8D7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Handle the delete action here
                          // You can call a method to delete selected items
                        },
                        icon: Icon(Icons.delete),
                      ),
                      Text("Eliminar"),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Handle the delete action here
                          // You can call a method to delete selected items
                        },
                        icon: Icon(Icons.compare),
                      ),
                      Text("Comparar"),
                    ],
                  ),
                  // You can add more buttons or widgets here
                ],
              ),

          )
              : null,
        );
      },
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
    return selectedItem.isNotEmpty? selectedItem.length.toString()+" fotos seleccionados" : "Ninguna imagen seleccionada";
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





