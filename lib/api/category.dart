import 'dart:convert';
import 'dart:ffi';

class Category{
  final int idCategory;
  final String name;

  Category({
    required this.idCategory,
    required this.name,
  });

  static Category objJson(Map<String, dynamic> json){
    return Category(
        idCategory: json['idCategory'] as int,
        name:json['name'] as String
    );
  }

}