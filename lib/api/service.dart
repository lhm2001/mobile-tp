import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/api/category.dart';
import 'package:proyecto_tesis/api/consultation.dart';
import 'package:proyecto_tesis/api/loginDTO.dart';
import 'user.dart';
import 'package:proyecto_tesis/globals.dart' as globals;
import 'listCategory.dart';
import 'listConsultation.dart';


class service{

  static Future<int> login(String email, String password) async {
    final response = await http.post(

      Uri.parse('${globals.url}auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password':password
      }),
    );


    if (response.statusCode == 200) {
      log('200');
      log(response.body);

      final data=Login.objJson(jsonDecode(response.body));

      final userId= data.idUser;

      return userId;
    } else {
      log('200 NO');
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return 0;
    }
  }

  static Future<List<Category>> getCategoriesByUserId(int userId) async{

    log('service');
    log('${globals.url}users/$userId/categories');
    final rspta=await http.get(Uri.parse('${globals.url}users/$userId/categories'));
    if(rspta.statusCode==200){
      log('200');
      final rsptaJson=json.decode(rspta.body);
      // final rsptacero=rsptaJson[0];
      // log('rsptaJson: $rsptacero');
      final todosRecipe=listCategory.listaCategory(rsptaJson);
      log('data222: $todosRecipe');
      inspect(todosRecipe);

      return todosRecipe;
    }
    return <Category>[];
  }

  static Future<List<Consultation>> getConsultationsByCategoryId(int categoryId) async{

    final rspta=await http.get(Uri.parse('${globals.url}categories/$categoryId/consultations'));
    if(rspta.statusCode==200){
      log('200');
      final rsptaJson=json.decode(rspta.body);
      final todosRecipe=listConsultation.listaConsultation(rsptaJson);

      return todosRecipe;
    }
    return <Consultation>[];
  }

  static Future<Consultation> getFirstConsultationByCategoryId(int categoryId) async{

    final rspta=await http.get(Uri.parse('${globals.url}categories/$categoryId/consultations'));

    log('rspta: $rspta');
    //inspect(rspta);
    log('${globals.url}categories/$categoryId/consultations');

    if(rspta.statusCode==200){
      final rsptaJson=json.decode(rspta.body);
      inspect(rsptaJson);
      //inspect(rsptaJson[0]);
      //log('data: ${rsptaJson[0]}');

      if(rsptaJson.length>0){
        final rsptaFirst=rsptaJson[0];
        final recipe=Consultation.objJson(rsptaFirst);

        return recipe;
      }
      else{
        return Consultation.empty();
      }


    }
    else{
      //log("else");
      throw Exception('Failed to load consultation');
    }
  }

  static Future<Consultation> getLastConsultationByCategoryId(int categoryId) async{

    final rspta=await http.get(Uri.parse('${globals.url}categories/$categoryId/consultations'));

    if(rspta.statusCode==200){
      final rsptaJson=json.decode(rspta.body);

      if(rsptaJson.length>0){
        final rsptaLast=rsptaJson[rsptaJson.length-1];
        final recipe=Consultation.objJson(rsptaLast);

        return recipe;
      }
      else{
        return Consultation.empty();
      }


    }
    else{
      throw Exception('Failed to load consultation');
    }
  }


  static Future<User> getUserById(userId) async {

    log("service");

    final rspta=await http.get(Uri.parse('${globals.url}users/$userId'));

    log("rspta");

    if(rspta.statusCode==200){
      log("200");
      final rsptaJson=json.decode(rspta.body);
      final user=User.objJson(rsptaJson);
      log("user: $user");
      return user;
    }
    else{
      throw Exception('Failed to load user');
    }
    // return <Profile>[];
  }
}