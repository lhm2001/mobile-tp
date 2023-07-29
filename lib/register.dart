import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'bottomNavigation.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:image_picker/image_picker.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {

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

  // Future selImagen(op) async {
  //
  //   try {
  //     var pickerFile;
  //     if (op == 1) {
  //       pickerFile = await picker.pickImage(source: ImageSource.camera);
  //     } else {
  //       pickerFile = await picker.pickImage(source: ImageSource.gallery);
  //     }
  //
  //     if (pickerFile != null) {
  //       imagen = File(pickerFile.path);
  //       //namePhoto = pickerFile.path.toString().substring(38);
  //       img = pickerFile.path;
  //
  //       File imgFile = File(img);
  //       Uint8List imgBytes = await imgFile.readAsBytes();
  //       base64string = base64.encode(imgBytes);
  //       print('BASE64 ' + base64string);
  //       setState(() {
  //
  //       });
  //     } else {
  //       print('No seleccionaste ninguna foto');
  //     }
  //
  //     Navigator.of(context).pop();
  //
  //   } catch (e) {
  //     print("Error while picking file");
  //   }
  // }
  //
  // opciones(context) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           contentPadding: const EdgeInsets.all(0),
  //           content: SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 InkWell(
  //                   onTap: () {
  //                     photo = 1;
  //                     selImagen(1);
  //                     setState((){
  //
  //                     });
  //                   },
  //                   child: Container(
  //                     padding: const EdgeInsets.all(20),
  //                     decoration: const BoxDecoration(
  //                         border: Border(bottom: BorderSide(width: 1, color: Colors.grey))
  //                     ),
  //                     child: Row(
  //                       children: const [
  //                         Expanded(
  //                           child: Text('Tomar una foto', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w100)),
  //                         ),
  //                         Icon(Icons.camera_alt_outlined, color: Colors.black),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //
  //                 InkWell(
  //                   onTap: () {
  //                     photo = 1;
  //                     selImagen(2);
  //                     setState((){
  //
  //                     });
  //                   },
  //                   child: Container(
  //                     padding: const EdgeInsets.all(20),
  //                     child: Row(
  //                       children: const [
  //                         Expanded(
  //                           child: Text('Seleccionar una foto', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w100)),
  //                         ),
  //                         Icon(Icons.collections, color: Colors.black)
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //
  //                 InkWell(
  //                   onTap: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Container(
  //                     padding: const EdgeInsets.all(20),
  //                     decoration: const BoxDecoration(
  //                       color: Color(0xFFC44C04),
  //                     ),
  //                     child: Row(
  //                       children: const [
  //                         Expanded(
  //                           child: Text('Cancelar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       }
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFF00807E),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 75),

            const Text('Crea tu cuenta',style: TextStyle(
              //fontWeight: FontWeight.bold,
              fontSize: 32, color: Colors.white,
            ),),

            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  //borderRadius: BorderRadius.circular(15),
                ),
                child:Padding(
                  padding: const EdgeInsets.all(10.0),
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
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  //borderRadius: BorderRadius.circular(15),
                ),
                child:Padding(
                  padding: const EdgeInsets.all(10.0),
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

            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: InkWell(
            //     onTap: () {
            //       opciones(context);
            //     },
            //     child: Container(
            //       padding: const EdgeInsets.only(bottom: 18, top: 18, left: 10, right: 10),
            //       //color: Colors.brown[200],
            //       color: Colors.white,
            //       child: Row(
            //         children: const [
            //           Expanded(
            //             child: Text('Adjuntar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w100)),
            //           ),
            //           Icon(Icons.camera_alt, color: Colors.black)
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            // if (photo == 1)
            //   imagen == null ? const Center() : Padding(
            //     padding: const EdgeInsets.all(10.0),
            //     child: Image.file(imagen),
            //   ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  //borderRadius: BorderRadius.circular(15),
                ),
                child:Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    //obscureText: true,
                    decoration: const InputDecoration(
                      border:InputBorder.none,
                      hintText: 'Email',
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  //borderRadius: BorderRadius.circular(15),
                ),
                child:Padding(
                  padding: const EdgeInsets.all(10.0),
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

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        onPressed: () {
                          //print('PHOTOOOOO ' + base64string);
                          if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty && nameController.text.isNotEmpty && lastNameController.text.isNotEmpty){
                            registerUser(emailController.text, passwordController.text, nameController.text , lastNameController.text);
                            globals.isLoggedIn = true;
                            globals.idNavigation = 0;
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>bottomNavigation()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Revise los datos ingresados"),
                              backgroundColor: Colors.brown,
                            ));
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text("Registrarse",style:TextStyle(
                            //fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black
                          )),
                        ),
                      ),
                    ),
                  ],
                ),

              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("¿Ya tienes una cuenta? ", style: TextStyle(
                  color: Colors.white,
                ),),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>login()));
                  },
                  child: const Text("Inicia Sesión", style: TextStyle(
                    fontWeight: FontWeight.bold,color:Colors.white,
                  ),),
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
}
