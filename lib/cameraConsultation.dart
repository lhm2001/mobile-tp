import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_tesis/api/consultation.dart';
import 'package:proyecto_tesis/api/service.dart';
import 'package:proyecto_tesis/compareResults.dart';
import 'package:proyecto_tesis/myCategories.dart';
import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:proyecto_tesis/globals.dart' as globals;
import 'api/category.dart';

class CameraConsultation extends StatefulWidget {
  const CameraConsultation({Key? key}) : super(key: key);

  @override
  State<CameraConsultation> createState() => _CameraConsultationState();
}

class _CameraConsultationState extends State<CameraConsultation> {

  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  File? _imageFile;

  List<Category> categories = [];
  List<Category> categoriesEvaluate = [];

  int? selectedId;
  late final Future _futureCategories;

  Consultation? consultation;
  bool? isDysplastic;

  MapEntry<DateTime, Map<Consultation, Category>>? lastConsultation;

  @override
  void initState() {
    super.initState();

    _futureCategories = service.getCategoriesByUserId(globals.userId);
    _futureCategories.then((value) => {
      categories = value,
      categoriesEvaluate = List<Category>.from(categories),
      if (categories.isNotEmpty) {
        selectedId = categories[0].idCategory,
      }
    });
  }

  Future<void> _takePhoto() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  int _generateUniqueId(List<Category> categories) {
    int newId = categories.isNotEmpty
        ? categories.map((category) => category.idCategory).reduce((a, b) => a > b ? a : b) + 1
        : 1;

    while (categories.any((category) => category.idCategory == newId)) {
      newId++;
    }

    return newId;
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newCategory = '';
        return AlertDialog(
          title: Text('Agregar una nueva categoría', style: TextStyle(fontSize: 12.sp)),
          content: TextField(
            onChanged: (value) {
              newCategory = value;
            },
            decoration: const InputDecoration(
              labelText: 'Nueva categoría',
              labelStyle: TextStyle(color: Color(0xFF00807E)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF00807E)), // Color del borde cuando el TextField no está enfocado
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB1D8D7)), // Color del borde cuando el TextField está enfocado
              ),
            ),
            cursorColor: Colors.black
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(fontSize: 10.sp, color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (newCategory.isNotEmpty) {
                  int newId = _generateUniqueId(categories);
                  Category auxCategory = Category(idCategory: newId, name: newCategory);
                  categories.add(auxCategory);
                  selectedId = categories[categories.length - 1].idCategory;
                }

                setState(() {
                  categories;
                  selectedId;
                  Navigator.of(context).pop();
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFB1D8D7),
              ),
              child: Text('Agregar', style: TextStyle(fontSize: 10.sp, color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  String _findCategory(int selectedId, List<Category> categories) {
    for (var category in categories) {
      if (category.idCategory == selectedId){
        return category.name;
      }
    }
    return 'No se encontro la categoría';
  }

  Future<int> _createCategory(String newCategory, String photo, BuildContext context) async {
    if (newCategory.isNotEmpty) {
      var categoryResult = await service.createCategory(globals.userId, newCategory, context);
      setState(() {
        categoryResult;
      });
      return categoryResult.idCategory;
    }
    return 0;
  }

  void _createConsultation(int categoryId, String photo, BuildContext context) async {
    var consultationResult = await service.createConsultation(categoryId, photo, context);
    setState(() {
      consultationResult;
    });
    if (consultationResult != null) {
      setState(() {
        isDysplastic;
        consultation;
      });
      consultation = consultationResult;
      isDysplastic = consultationResult.dysplastic;
    }
  }

  void _penultimateConsultation() async {
    try {
      List<Category> myCategories = await service.getCategoriesByUserId(globals.userId);
      Map<DateTime, Map<Consultation, Category>> dictionaryConsultations = {};

      for (Category category in myCategories) {
        List<Consultation> myConsultations = await service.getConsultationsByCategoryId(category.idCategory);
        Map<DateTime, Map<Consultation, Category>> myConsultationDates = {};

        for (Consultation c in myConsultations) {
          if (consultation!.idConsultation != c.idConsultation) {
            myConsultationDates[DateTime.parse(DateFormat("dd/MM/yyyy HH:mm:ss").parse(c.createdDate).toString())] = {c : category};
          }
        }

        if (myConsultationDates.isNotEmpty) {
          MapEntry<DateTime, Map<Consultation, Category>> lastConsultationByCategory = myConsultationDates.entries.reduce((maxEntry, entry) { return entry.key.isAfter(maxEntry.key) ? entry : maxEntry;});

          dictionaryConsultations[lastConsultationByCategory.key] = lastConsultationByCategory.value;
        }

      }

      lastConsultation = dictionaryConsultations.entries.reduce((maxEntry, entry) {
        return entry.key.isAfter(maxEntry.key) ? entry : maxEntry;
      });

      print("LAST CONSULTA: " + lastConsultation.toString());
      setState(() {
        lastConsultation;
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CompareResults(lastConsultation: lastConsultation!.value, consultation: consultation!, category: _findCategory(selectedId!, categories))),
      );

    } catch (e) {
      log('Error al obtener datos: $e');
    }
  }

  void _showCompareResultsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newCategory = '';
        return AlertDialog(
          title: Text('Comparar resultados', style: TextStyle(fontSize: 12.sp)),
          content: Text('¿Desea comparar los resultados con la penúltima consulta?', style: TextStyle(fontSize: 12.sp, color: Colors.black), textAlign: TextAlign.justify),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(fontSize: 10.sp, color: Colors.black)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyCategories()),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                _penultimateConsultation();
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFB1D8D7),
              ),
              child: Text('Aceptar', style: TextStyle(fontSize: 10.sp, color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Consulta",style: TextStyle(color: Colors.white)), // Nombre de la página que puedes cambiar dinámicamente según la página actual.
            backgroundColor: const Color(0xFF00807E),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              Image.asset('assets/logo-nevuscheck.png', fit: BoxFit.contain),
            ],
          ),

          body:  Column(
            children: [
              Theme(
                data: ThemeData(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: const Color(0xFF00807E),
                  ),
                ),
              child: Expanded(
                child: Stepper(
                  type: stepperType,
                  physics: const ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  // onStepContinue:  continued,
                  // onStepCancel: cancel,
                  controlsBuilder: (BuildContext context, ControlsDetails controls) {
                    return Row(
                      children: <Widget>[

                        TextButton(
                          onPressed: continued,
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFB1D8D7),
                          ),
                          child: Text('CONTINUAR', style: TextStyle(color: Colors.black, fontSize: 10.sp)),
                        ),

                        TextButton(
                          onPressed: cancel,
                          child: Text('CANCELAR', style: TextStyle(color: Colors.black, fontSize: 10.sp)),
                        ),
                      ],
                    );
                  },
                  steps: <Step>[
                    Step(
                      title: Text('Imagen', style: TextStyle(fontSize: 8.sp)),
                      content: Column(
                        children: <Widget>[
                          _imageFile != null ? Image.file(
                            _imageFile!,
                            height: 40.h,
                            width: 60.w,
                          ) : Image.asset('assets/upload.png'),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: _takePhoto,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00807E), // Aquí puedes cambiar el color
                                ),
                                child: Text('Tomar foto', style: TextStyle(fontSize: 10.sp, color: Colors.white)),
                              ),


                              ElevatedButton(
                                onPressed: _pickImageFromGallery,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00807E), // Aquí puedes cambiar el color
                                ),
                                child: Text('Subir imagen', style: TextStyle(fontSize: 10.sp, color: Colors.white)),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 10.w,
                          )
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0 ?
                      StepState.complete : StepState.disabled,
                    ),
                    Step(
                      title: Text('Categoría', style: TextStyle(fontSize: 8.sp)),
                      content: Column(
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            child: DropdownButton<String>(
                              value: selectedId.toString(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedId = int.parse(newValue!);
                                });
                              },
                              items: categories.isNotEmpty ? categories.map<DropdownMenuItem<String>>((Category category) {
                                return DropdownMenuItem<String>(
                                  value: category.idCategory.toString(),
                                  child: Text(category.name),
                                );
                              }).toList() : null, // Si la lista está vacía, pasa null a items para deshabilitar el DropdownButton
                              disabledHint: Text('No existe ninguna categoría', style: TextStyle(fontSize: 12.sp))
                            ),
                          ),

                          SizedBox(height: 2.5.h),

                          ElevatedButton(
                            onPressed: _showAddItemDialog,
                            child: Text('Agregar una nueva categoría', style: TextStyle(fontSize: 10.sp)),
                          ),

                          SizedBox(
                            height: 10.w,
                          )
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 1 ?
                      StepState.complete : StepState.disabled,
                    ),
                    Step(
                      title: Text('Resumen', style: TextStyle(fontSize: 8.sp)),
                      content: Column(
                        children: <Widget>[

                          _imageFile != null
                              ? Image.file(_imageFile!, height: 40.h, width: 60.w,) // Mostrar la imagen usando el widget Image
                              : Text('No se cargo la imagen  correctamente', style: TextStyle(fontSize: 8.sp)),

                          SizedBox(
                            height: 10.w,
                          ),

                          selectedId != null && categories.isNotEmpty ?
                            Text(_findCategory(selectedId!, categories), style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)) : const Center(),

                          SizedBox(
                              height: 10.w,
                          )

                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 2 ?
                      StepState.complete : StepState.disabled,
                    ),
                    Step(
                      title: Text('Resultado', style: TextStyle(fontSize: 8.sp)),
                      content: Column(
                        children: <Widget>[
                          Visibility(
                            visible: isDysplastic == null,
                            child: const LinearProgressIndicator(),
                          ),

                          SizedBox(
                            height: 5.w,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              selectedId != null && categories.isNotEmpty ?
                                Text(_findCategory(selectedId!, categories), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp))
                                : const Center(),

                              consultation != null ?
                              Text(consultation!.createdDate,style: TextStyle(fontSize: 14.sp))
                              : const Center(),
                            ],
                          ),

                          consultation != null ?
                          Image.memory(const Base64Decoder().convert(consultation!.photo), width: 80.w, height: 40.h)
                          : const Center(),

                          consultation != null ?
                          Text("Lunar ${consultation!.dysplastic ? "Displásico" : "No Displásico"}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.sp))
                          : const Center(),

                          SizedBox(height: 5.h),

                          consultation != null ?
                          Align(
                            alignment: Alignment.center,
                            child: Text("Resultados",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp)),
                          )
                          : const Center(),

                          SizedBox(height: 2.h),

                          consultation != null ?
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Asimetría : ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                                ),

                                Text(
                                  consultation!.resultAssymetry == 'Asymmetric' ? "Asimétrico" : "Simétrico",
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ],
                            ),
                          )
                          : const Center(),

                          SizedBox(height: 1.h),

                          consultation != null ?
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Borde        : ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                                ),

                                Text(
                                  consultation!.resultBorder,
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ],
                            ),
                          )
                          : const Center(),

                          SizedBox(height: 1.h),

                          consultation != null ?
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Color         : ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                                ),

                                Text(
                                  consultation!.resultColor == "Heterogeneous" ? "Heterogéneo" : "Homogéneo",
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ],
                            ),
                          )
                          : const Center(),

                          SizedBox(height: 1.h),

                          consultation != null ?
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Diámetro  : ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                                ),

                                Expanded(
                                  child: Text(
                                    consultation!.resultDiameter == "The diameter can measure manually. If the diameter is greater than 6mm, a specialist should be consulted." ? "El diámetro lo puede medir manualmente. En caso de que el diámetro sea mayor a 6mm, se debe dirigir a un especialista." : "",
                                    style: TextStyle(fontSize: 12.sp),
                                    maxLines: 6,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : const Center(),
                        ],
                      ),
                      isActive:_currentStep >= 0,
                      state: _currentStep >= 3 ?
                      StepState.complete : StepState.disabled,
                    ),
                  ],
                ),
              ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: switchStepsType,
            child: const Icon(Icons.list),
          ),
        );
      }
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step){
    setState(() => _currentStep = step);
  }

  continued() async {
    if (_currentStep == 2) {

      if (_imageFile != null && _findCategory(selectedId!, categories) != 'No se encontro la categoría') {
        List<int> imageBytes = _imageFile!.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);

        print(base64Image);

        String category = _findCategory(selectedId!, categories);
        print(category);

        bool categoryNew = true;
        int categoryId = 0;
        for (var categoryCompare in categoriesEvaluate) {
          if (categoryCompare.name == category){
            categoryNew = false;
            categoryId = categoryCompare.idCategory;
          }
        }
         if (categoryNew) {
           print("CATEGORIA NUEVA");
           int categoryNewId = await _createCategory(category, base64Image, context);
           _createConsultation(categoryNewId, base64Image, context);

         } else {
           print("CATEGORIA EXISTENTE");
           _createConsultation(categoryId, base64Image, context);
         }
        _currentStep < 3 ? setState(() => _currentStep += 1): null;

      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Completar los datos solicitados", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.redAccent,
        ));
        // _currentStep < 3 ? setState(() => _currentStep += 1): null; //BORRAR

      }
    } else if (_currentStep == 3 && consultation != null) {
      print("ENTROOO");
      _showCompareResultsDialog();
      // _currentStep < 3 ? setState(() => _currentStep += 1): null;
    } else {
      _currentStep < 3 ? setState(() => _currentStep += 1): null;
    }
  }
  cancel(){
    _currentStep > 0 ?
    setState(() => _currentStep -= 1) : null;
  }
}

