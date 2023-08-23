import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_tesis/api/user.dart';
import 'package:proyecto_tesis/bottomNavigation.dart';
import 'package:proyecto_tesis/notification.dart';
import 'package:proyecto_tesis/register.dart';
import 'api/category.dart';
import 'api/consultation.dart';
import 'globals.dart' as globals;
import 'package:proyecto_tesis/api/service.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

Future<void> fetchDataAndProcess() async {
  try {
    List<Category> categories = await service.getCategoriesByUserId(globals.userId);

    for (Category category in categories) {
      Consultation consultation = await service.getLastConsultationByCategoryId(category.idCategory);

      if(consultation.createdDate != ''){

        DateTime dateTime = DateTime.parse(DateFormat("dd/MM/yyyy HH:mm:ss").parse(consultation.createdDate).toString());

        // Ajustar la fecha para que sea un mes después
        dateTime = DateTime(dateTime.year, dateTime.month + 1, dateTime.day, 12, 0, 0);

        NotificationService().scheduleNotification(id: category.idCategory,title: 'Scheduled Notification',body: 'Scheduled', scheduledNotificationDateTime: dateTime);
      }
    }
  } catch (e) {
    log('Error al obtener datos: $e');
  }
}

class _LoginState extends State<Login> {

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  late int _user;
  late bool logged=false;

  @override
  void initState() {
    super.initState();

    checkCredentials();

  }

  Future<void> checkCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email=prefs.getString('email');
    String? pass=prefs.getString('password');

    if(email!=null && email!=''  && pass!=null && pass!=''){

      logged=true;
      _user= await service.login(email,pass);
      globals.userId = _user;
      globals.isLoggedIn = true;
      globals.idNavigation = 0;
      fetchDataAndProcess();

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const BottomNavigation()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color(0xFF00807E),
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(height: 10.h),

                  Text('Iniciar Sesión',
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 32.sp,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 10.h),


                  logged ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0XFFFFFFFF))) : Container(),


                  Padding(
                    padding: EdgeInsets.all(2.5.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:Padding(
                        padding: EdgeInsets.all(1.h),
                        child: TextField(
                          controller: _email,
                          decoration: const InputDecoration(
                            border:InputBorder.none,
                            hintText: 'Correo electrónico',
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(2.5.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:Padding(
                        padding: EdgeInsets.all(1.h),
                        child: TextField(
                          controller: _password,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border:InputBorder.none,
                            hintText: 'Contraseña',
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 7.5.h),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Ajusta el valor según desees
                      ),
                    ),
                    onPressed: () async {
                      _user= await service.login(_email.text,_password.text);
                      log('user: $_user');
                      setState(() {
                        //log('result: $_user');
                      });
                      if(_user!=0){
                        globals.userId = _user;
                        print("USERID: $_user");
                        globals.isLoggedIn = true;
                        globals.idNavigation = 0;
                        fetchDataAndProcess();

                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('email', _email.text);
                        prefs.setString('password', _password.text);

                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const BottomNavigation()));

                      }
                      else{
                        // _showSnackBar(context);
                        // log('no login');
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Contraseña incorrecta",
                                    style: TextStyle(color: Colors.black)
                                ),
                                backgroundColor: Colors.tealAccent
                            )
                        );
                      }

                    },
                    child: Padding(
                      padding: EdgeInsets.all(2.3.w),
                      child: Text("Ingresar",style:TextStyle(
                        //fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                          color: Colors.black
                      )),
                    ),
                  ),

                  SizedBox(height: 2.5.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text("¿No tienes una cuenta? ",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Register()));
                        },
                        child: Text("Regístrate",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,color:Colors.white,
                          ),
                        ),
                      )
                    ],
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
