import 'dart:convert';

class User{
  final int idUser;
  final String email;
  final String password;
  final String name;
  final String lastName;

  User({
    required this.idUser,
    required this.email,
    required this.password,
    required this.name,
    required this.lastName,
  });

  static User objJson(Map<String, dynamic> json){
    return User(
      idUser: json['idUser'] as int,
      email:json['email'] as String,
      password:json['password'] as String,
      name:json['name'] as String,
      lastName:json['lastName'] as String,
    );
  }

}