import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
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
      print('RB: ${response.body}');

      final data=Login.objJson(jsonDecode(response.body));
      log('Data: $data');

      final userId= data.idUser;

      return userId;
    } else {
      log('200 NO');
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return 0;
    }
  }

  static Future<int> validateEmail(String email) async {
    String apiKey = '3156cd45c78f4ed5a7df37da0c83aa39';
    String apiUrl = 'https://emailvalidation.abstractapi.com/v1/?api_key=$apiKey&email=$email';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['deliverability'] == 'DELIVERABLE'
            && double.parse(data['quality_score']) >= 0.8
            && data['is_valid_format']['value'] == true
            && data['is_disposable_email']['value'] == false) {
          return 1;
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    } catch (error) {
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

  static Future<Category> createCategory(int userId, String name, BuildContext context) async {

    final response = await http.post(

      Uri.parse('${globals.url}users/$userId/categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name
      }),
    );


    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Se creó correctamente la categoría", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.tealAccent,
      ));

      final data = Category.objJson(jsonResponse);

      return data;
    } else {
      log('Code: ' + response.statusCode.toString() + ' Body: ' + response.body);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No se creó correctamente la categoría", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.redAccent,
      ));
      return Future.value(null);
    }
  }

  static Future<Consultation> createConsultation(int categoryId, String photo, BuildContext context) async {

    final response = await http.post(

      Uri.parse('${globals.url}categories/$categoryId/consultations'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br'
      },
      body: jsonEncode(<String, String>{
        'photo': photo
      }),
    ).timeout(const Duration(seconds: 90)).catchError((error) {
      print(error);
    });


    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Se creó correctamente la consulta", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.tealAccent,
      ));

      final data = Consultation.objJson(jsonResponse);

      return data;
    } else {
      log('200 NO');
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No se creó correctamente la consulta", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.redAccent,
      ));
      return Future.value(null);
    }
  }

}