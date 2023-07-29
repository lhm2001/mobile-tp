import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/api/consultation.dart';
import 'package:proyecto_tesis/api/service.dart';
import 'package:proyecto_tesis/myConsultations.dart';
import 'package:proyecto_tesis/preventiveInformation.dart';
import 'globals.dart' as globals;
import 'dart:convert';

class myCategories extends StatelessWidget {
  const myCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    print(globals.isLoggedIn);
    final userId=globals.userId;

    globals.isLoggedIn? print("logged"): print("not logged");

    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Lunares",style: TextStyle(color: Colors.white),), // Nombre de la página que puedes cambiar dinámicamente según la página actual.
        backgroundColor: Color(0xFF00807E),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(top: 60,left: 20,right: 20),
            child: Column(
              children: [
                FutureBuilder(
                  initialData: [],
                  future:service.getCategoriesByUserId(userId),
                  builder: (context, AsyncSnapshot<List> snapshot){
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context,index){
                          var category=snapshot.data![index];
                          if(snapshot.hasData){
                            return FutureBuilder<Consultation>(
                                future:service.getFirstConsultationByCategoryId(category.idCategory),
                                builder: (context,snapshotMultimedia){
                                  if (snapshotMultimedia.hasData){
                                    var consultation=snapshotMultimedia.data!;
                                    return GestureDetector(
                                      onTap: (){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>myConsultations(categoryId: category.idCategory,categoryName:category.name)));
                                      },
                                      child: Card(
                                        color: Color(0xFFB1D8D7),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 90,
                                                height: 90,
                                                child: consultation.idConsultation!=0 ? Image.memory(Base64Decoder().convert(consultation.photo), fit: BoxFit.cover) : Image.asset('assets/mole.png'),
                                              ),
                                              SizedBox(width: 30,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(category.name.toString(),style: TextStyle(color: Colors.black,fontSize: 12),),
                                                  Text('Última foto tomada hace ',style: TextStyle(color: Colors.black,fontSize: 12),),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),

                                      ),
                                    );
                                  }
                                  else {
                                    return Container(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                }

                            );
                          }

                        });

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

}





