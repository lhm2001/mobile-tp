import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/api/service.dart';
import 'bottomNavigation.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  var userId = 0;
  var profileId = 0;

  final ImagePicker picker = ImagePicker();
  var imagen;
  String img = "";
  int photo = 0;
  String base64string = "";

  late int _validate;
  bool validateAnswer = false;

  bool isChecked = false;

  registerUser(String email, String password, String name, String lastName) async {
    var jsonResponse = null;
    Uri myUri = Uri.parse("${globals.url}users");

    var response = await http.post(myUri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String, String>{
        'name':name,
        'lastName':lastName,
        'email': email,
        'password': password,
      }),
    );

    if(response.statusCode == 201) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if(jsonResponse != null) {
        userId = jsonResponse["idUser"];
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Se registro correctamente"),
          backgroundColor: Color(0xFF00807E),
        ));
      }
    } else {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Correo o contrasena invalida"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return Scaffold(
            backgroundColor:const Color(0xFF00807E),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(
                      height: 15.h,
                      child: Image.asset('assets/logo-nevuscheck.png', fit: BoxFit.contain)
                  ),

                  Text('Crea tu cuenta',
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 32.sp,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 2.5.h),

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
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            border:InputBorder.none,
                            hintText: 'Nombre',
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
                          controller: lastNameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border:InputBorder.none,
                            hintText: 'Apellidos',
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
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          //obscureText: true,
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
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border:InputBorder.none,
                            hintText: 'Contraseña',
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 0.5.h),

                  Padding(
                    padding: EdgeInsets.only(left: 1.0.h),
                    child: Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          side: MaterialStateBorderSide.resolveWith(
                                (states) => BorderSide(width: 3.0, color: Colors.white),
                          ),
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                // Cambia el color del cuadro cuando está seleccionado
                                return Colors.white;
                              }
                              // Cambia el color del cuadro cuando no está seleccionado
                              return Color(0xFF00807E);
                            },
                          ),
                          checkColor: const Color(0xFF00807E),
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        TextButton(
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => Dialog.fullscreen(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Política de Privacidad',style: TextStyle(
                                            fontSize: 16.sp,fontWeight: FontWeight.bold
                                        ),),
                                        Text('Esta política de privacidad se aplica a la aplicación móvil NEVUSCHECK que se utiliza para detectar lunares displásicos.'),
                                        SizedBox(height: 15),
                                        Text('1.Recopilación de información personal',style: TextStyle(
                                            fontSize: 12.sp,fontWeight: FontWeight.bold
                                        ),),
                                        Text('Cuando utiliza la aplicación, podemos recopilar la siguiente información personal sobre usted:'),
                                        SizedBox(height: 10),
                                        Text('•Tu nombre y apellido'),
                                        Text('•Su dirección de correo electrónico'),
                                        Text('•Tu contraseña'),
                                        Text('•Fotos de tus lunares'),
                                        SizedBox(height: 10),
                                        Text('Recopilamos esta información para brindarle los servicios de la aplicación, tales como:'),
                                        SizedBox(height: 10),
                                        Text('•Analizar las fotos de tus lunares para detectar lunares displásicos'),
                                        Text('•Enviar notificaciones de seguimiento en caso activa la opción.'),
                                        SizedBox(height: 15),
                                        Text('2.Uso de información personal',style: TextStyle(
                                          fontSize: 12.sp,fontWeight: FontWeight.bold,
                                        ),),
                                        Text('Utilizamos su información personal para los siguientes propósitos:'),
                                        SizedBox(height: 10),
                                        Text('•Para proporcionarle los servicios de la aplicación.'),
                                        Text('•Para mejorar los servicios de la aplicación.'),
                                        Text('•Para enviarle notificaciones sobre los servicios de la aplicación.'),
                                        Text('•Para proteger la seguridad de la aplicación.'),
                                        Text('•Para cumplir con las leyes y regulaciones aplicables.'),
                                        SizedBox(height: 15),
                                        Text('3.Intercambio de información personal',style: TextStyle(
                                            fontSize: 12.sp,fontWeight: FontWeight.bold
                                        ),),
                                        Text('Podemos compartir su información personal con los siguientes terceros:'),
                                        SizedBox(height: 10),
                                        Text('•Nuestros proveedores de servicios externos que nos ayudan a proporcionar los servicios de la Aplicación, como la plataforma de computación en la nube Amazon Web Services (AWS).'),
                                        Text('•Agencias encargadas de hacer cumplir la ley si así lo exige la ley.'),
                                        SizedBox(height: 15),
                                        Text('4.Tus derechos',style: TextStyle(
                                            fontSize: 12.sp,fontWeight: FontWeight.bold
                                        ),),
                                        Text('Tiene los siguientes derechos con respecto a su información personal:'),
                                        SizedBox(height: 10),
                                        Text('•El derecho a acceder a su información personal.'),
                                        Text('•El derecho a corregir su información personal.'),
                                        Text('•El derecho a eliminar su información personal.'),
                                        Text('•El derecho a oponerse al procesamiento de su información personal.'),
                                        SizedBox(height: 15),
                                        Text('5.Cómo contactarnos',style: TextStyle(
                                            fontSize: 12.sp,fontWeight: FontWeight.bold
                                        ),),
                                        Text('Si tiene alguna pregunta sobre esta política de privacidad, contáctenos en: support-nevuscheck@gmail.com'),
                                        SizedBox(height: 15),
                                        Text('6.Descargo de responsabilidad',style: TextStyle(
                                            fontSize: 12.sp,fontWeight: FontWeight.bold
                                        ),),
                                        Text('Los resultados del análisis de tus lunares mediante la aplicación no ​​son 100% fiables. Siempre debes consultar con un médico para un diagnóstico definitivo.'),
                                        SizedBox(height: 15),
                                        Text('7.Cambios a esta Política de Privacidad',style: TextStyle(
                                            fontSize: 12.sp,fontWeight: FontWeight.bold
                                        ),),
                                        Text('Podemos actualizar esta política de privacidad de vez en cuando. La última versión de la política de privacidad siempre estará publicada en la aplicación.'),
                                        SizedBox(height: 15),
                                        Text('Información adicional:',style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),),
                                        Text('•Las fotos de tus lunares se almacenan en servidores de AWS.'),
                                        Text('•AWS es una plataforma segura de computación en la nube que cumple con el Reglamento General de Protección de Datos (GDPR) de la Unión Europea.'),
                                        Text('•Tomamos medidas para proteger la seguridad de su información personal, como el uso de cifrado y controles de acceso.'),
                                        Text('•Solo conservaremos su información personal durante el tiempo necesario para brindarle los servicios de la aplicación.'),


                                        const SizedBox(height: 15),
                                        Align(
                                          alignment: Alignment.center,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cerrar',style: TextStyle(
                                              color:  Color(0xFF00807E),
                                            ),),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          child: Text(
                            'Acepto la política de privacidad',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.5.h),

                  Padding(
                    padding: EdgeInsets.all(1.h),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              ),
                              onPressed: () async {
                                if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty && nameController.text.isNotEmpty && lastNameController.text.isNotEmpty && isChecked){
                                  try {
                                    _validate = await service.validateEmail(emailController.text);
                                    setState(() {
                                      _validate;
                                    });

                                    if (_validate == 1) {
                                      registerUser(emailController.text, passwordController.text, nameController.text , lastNameController.text);
                                      globals.isLoggedIn = true;
                                      globals.idNavigation = 0;
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const BottomNavigation()));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("No se logro validar el correo electrónico",
                                            style: TextStyle(color: Colors.black)
                                        ),
                                        backgroundColor: Colors.tealAccent,
                                      ));
                                    }
                                  } catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text("No se logro validar el correo electrónico",
                                          style: TextStyle(color: Colors.black)
                                      ),
                                      backgroundColor: Colors.tealAccent,
                                    ));
                                  }
                                }
                                else if (!isChecked) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Es necesario aceptar los términos y condiciones",
                                        style: TextStyle(color: Colors.black)
                                    ),
                                    backgroundColor: Colors.tealAccent,
                                  ));
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Revisar los datos ingresados",
                                        style: TextStyle(color: Colors.black)
                                    ),
                                    backgroundColor: Colors.tealAccent,
                                  ));
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.all(2.3.w),
                                child: Text("Registrarse",
                                    style:TextStyle(
                                      //fontWeight: FontWeight.bold,
                                        fontSize: 15.sp,
                                        color: Colors.black
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ),
                  ),

                  SizedBox(height: 2.5.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿Ya tienes una cuenta? ",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Login()));
                        },
                        child: Text("Inicia Sesión",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color:Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),
          );
        }
    );

  }
}