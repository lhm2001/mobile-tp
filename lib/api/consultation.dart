import 'dart:convert';
import 'dart:ffi';

class Consultation{
  final int idConsultation;
  final String photo;
  final String createdDate;
  final bool dysplastic;
  final String resultAssymetry;
  final String resultBorder;
  final String resultColor;
  final String resultDiameter;

  Consultation({
    required this.idConsultation,
    required this.photo,
    required this.createdDate,
    required this.dysplastic,
    required this.resultAssymetry,
    required this.resultBorder,
    required this.resultColor,
    required this.resultDiameter,
  });

  Consultation.empty()
      : idConsultation = 0,
        photo = '',
        createdDate = '',
        dysplastic = false,
        resultAssymetry = '',
        resultBorder = '',
        resultColor = '',
        resultDiameter = '';

  static Consultation objJson(Map<String, dynamic> json){
    return Consultation(
        idConsultation: json['idConsultation'] as int,
        photo:json['photo'] as String,
        createdDate:json['createdDate'] as String,
        dysplastic:json['dysplastic'] as bool,
        resultAssymetry:json['resultAssymetry'] as String,
        resultBorder:json['resultBorder'] as String,
        resultColor:json['resultColor'] as String,
        resultDiameter:json['resultDiameter'] as String,
    );
  }

}