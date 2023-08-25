import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PreventiveInformation extends StatefulWidget {
  const PreventiveInformation({Key? key}) : super(key: key);

  @override
  State<PreventiveInformation> createState() => _PreventiveInformationState();
}

class _PreventiveInformationState extends State<PreventiveInformation> {
  List<Item> _data = generateItems();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Información Preventiva",
                style: TextStyle(color: Colors.white)),
            backgroundColor: const Color(0xFF00807E),
            automaticallyImplyLeading: false,
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(2.5.h),
                child: SingleChildScrollView(
                  child: ExpansionPanelList(
                    elevation: 1,
                    expandedHeaderPadding: EdgeInsets.all(0),
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        _data[index].isExpanded = !isExpanded;
                      });
                    },

                    children: _data.map<ExpansionPanel>((Item item) {
                      return ExpansionPanel(
                        backgroundColor: const Color(0xFFf7fcfc),
                        canTapOnHeader: true,
                        headerBuilder:(BuildContext context, bool isExpanded) {
                          return Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text(
                              item.headerValue,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                        body: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            item.expandedValue,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        isExpanded: item.isExpanded,
                      );
                    }).toList(),
                  ),
                ),
              ),

          ),
        );
      },
    );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems() {
  return [
    Item(
      headerValue: '1. ¿Qué es un nevus displásico?',
      expandedValue:
      'Un nevo displásico es un tipo de lunar que tiene características atípicas en su apariencia. Se considera una lesión precancerosa y debe ser monitoreada por un dermatólogo.',
    ),
    Item(
      headerValue: '2. ¿Qué es el melanoma?',
      expandedValue:
      'El melanoma es un tipo de cáncer de piel que se desarrolla a partir de los melanocitos, las células que producen el pigmento de la piel. Es el tipo más peligroso de cáncer de piel y debe ser tratado con prontitud.',
    ),
    Item(
      headerValue: '3. ¿Este diagnóstico reemplaza el de un doctor?',
      expandedValue:
      'No, el diagnóstico proporcionado por la aplicación no reemplaza la opinión de un médico. Siempre es recomendable consultar a un dermatólogo o profesional médico calificado para obtener un diagnóstico preciso y una evaluación adecuada de cualquier condición de la piel.',
    ),
    Item(
      headerValue: '4. ¿Cómo funciona el diagnóstico?',
      expandedValue:
      ' La aplicación utiliza un modelo de red neuronal convolucional para analizar imágenes de lunares. El modelo ha sido entrenado para identificar características asociadas con lunares displásicos. Sin embargo, es importante tener en cuenta que el diagnóstico se basa en la información visual proporcionada por la imagen y en los patrones que el modelo ha aprendido durante su entrenamiento.',
    ),
    Item(
      headerValue: '5. ¿Cuál es la precisión del resultado?',
      expandedValue:
      'La aplicación tiene una precisión de aproximadamente el 78%. Esto significa que el modelo es capaz de hacer una clasificación correcta en aproximadamente el 78% de los casos.',
    ),
    Item(
      headerValue: '6. ¿Cada cuánto tiempo es recomendable asistir a un especialista?',
      expandedValue:
      'Es recomendable asistir a un dermatólogo o especialista en piel al menos una vez al año para un examen de detección de lunares y otros problemas de la piel. Si tienes antecedentes familiares de cáncer de piel o cambios notables en tus lunares, podrías requerir visitas más frecuentes.',
    ),
  ];
}
