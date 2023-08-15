import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_tesis/api/consultation.dart';
import 'package:proyecto_tesis/api/service.dart';
import 'package:proyecto_tesis/myConsultations.dart';
import 'package:proyecto_tesis/preventiveInformation.dart';
import 'globals.dart' as globals;
import 'dart:convert';
import 'package:sizer/sizer.dart';


class MyCategories extends StatelessWidget {
  const MyCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    print(globals.isLoggedIn);
    final userId = globals.userId;

    globals.isLoggedIn? print("logged"): print("not logged");

    String getTimeDifference(String uploadDateTime) {
      DateTime now = DateTime.now();
      DateTime uploadTime = DateFormat("dd/MM/yyyy HH:mm:ss").parse(uploadDateTime);
      Duration difference = now.difference(uploadTime);
      return "${difference.inDays}";
    }

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
                padding: EdgeInsets.only(top: 10.w, left: 5.w, right:5.w),
                child: Column(
                  children: [
                    FutureBuilder(
                      initialData: const [],
                      future:service.getCategoriesByUserId(userId),
                      builder: (context, AsyncSnapshot<List> snapshot){
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context,index){
                            var category=snapshot.data![index];
                            if(snapshot.hasData){
                              return FutureBuilder<Consultation>(
                                  future: service.getLastConsultationByCategoryId(category.idCategory),
                                  builder: (context,snapshotMultimedia){
                                    if (snapshotMultimedia.hasData){
                                      var consultation=snapshotMultimedia.data!;
                                      return GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyConsultations(categoryId: category.idCategory,categoryName:category.name)));
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
                                                  child: consultation.idConsultation!=0 ? Image.memory(Base64Decoder().convert(consultation.photo), fit: BoxFit.cover) : Image.asset('assets/mole.png'),
                                                ),

                                                SizedBox(width: 2.5.w),

                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [

                                                    Text(category.name.toString(),style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold)),

                                                    SizedBox(height: 2.5.h),

                                                    getTimeDifference(consultation.createdDate) == 1 ?
                                                    SizedBox(
                                                        width: 45.w,
                                                        child: Text('Última foto tomada hace ${getTimeDifference(consultation.createdDate)} día', style: TextStyle(color: Colors.black, fontSize: 8.sp), maxLines: 3, overflow: TextOverflow.clip)
                                                    ) :
                                                    SizedBox(
                                                      width: 45.w,
                                                      child: Text('Última foto tomada hace ${getTimeDifference(consultation.createdDate)} días', style: TextStyle(color: Colors.black, fontSize: 8.sp), maxLines: 3, overflow: TextOverflow.clip)
                                                    )

                                                  ],
                                                )
                                              ],
                                            ),
                                          ),

                                        ),
                                      );
                                    }
                                    else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                  }

                              );
                            }
                          }
                        );
                      },
                    ),


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





