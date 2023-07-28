import 'dart:convert';
import 'dart:ffi';

class Login{
  final int idUser;
  final String message;
  final bool status;

  Login({
    required this.idUser,
    required this.message,
    required this.status
  });

  static Login objJson(Map<String, dynamic> json){
    return Login(
      idUser: json['idUser'] as int,
      message:json['message'] as String,
      status:json['status'] as bool
    );
  }

}