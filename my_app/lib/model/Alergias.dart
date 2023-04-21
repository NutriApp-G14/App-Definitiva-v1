//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class Alergias {
  final String nombreUsuario;
  final bool cacahuetes;
  final bool leche;
  final bool huevo;
  final bool trigo;
  final bool soja;
  final bool mariscos;
  final bool frutosSecos;
  final bool pescado;

  Alergias(this.nombreUsuario, this.cacahuetes, this.leche, this.huevo,
      this.trigo, this.soja, this.mariscos, this.frutosSecos, this.pescado);

  factory Alergias.fromJson(Map<String, dynamic> json) {
    return Alergias(
      json['nombreUsuario'],
      json['cacahuetes'],
      json['leche'],
      json['huevo'],
      json['trigo'],
      json['soja'],
      json['mariscos'],
      json['frutosSecos'],
      json['pescado'],
    );
  }
}

List selected = [];
List<String> seleccionadas = [];

List valorInicial = [];

class AlergiasWidget extends StatefulWidget {
  @override
  _AlergiasWidgetState createState() => _AlergiasWidgetState();
}

class _AlergiasWidgetState extends State<AlergiasWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(30, 5, 10, 10),
        child: MultiSelectFormField(
          autovalidate: AutovalidateMode.disabled,
          chipBackGroundColor: Color.fromARGB(255, 255, 210, 143),
          //chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          checkBoxActiveColor: Color.fromARGB(255, 255, 210, 143),
          checkBoxCheckColor: Colors.white,
          dialogShapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          title: Text(
            'Alergias',
          ),
          validator: (value) {
            if (value == null || value.length == 0) {
              return 'Please select one or more options';
            }
            return null;
          },
          dataSource: [
            {
              "display": 'Cacahuetes',
              "value": 'Cacahuetes',
            },
            {
              "display": 'Leche',
              "value": 'Leche',
            },
            {
              "display": 'Huevo',
              "value": 'Huevo',
            },
            {
              "display": 'Trigo',
              "value": 'Trigo',
            },
            {
              "display": 'Soja',
              "value": 'Soja',
            },
            {
              "display": 'Mariscos',
              "value": 'Mariscos',
            },
            {
              "display": 'Frutos secos',
              "value": 'Frutos secos',
            },
            {
              "display": 'Pescado',
              "value": 'Pescado',
            },
          ],
          textField: 'display',
          valueField: 'value',
          okButtonLabel: 'Aceptar',
          cancelButtonLabel: 'Cancelar',
          hintWidget: Text(
            'Seleccione uno o más alérgenos',
            style: TextStyle(fontSize: 10),
          ),
          initialValue: valorInicial,
          onSaved: (value) {
            if (value == null) return;
            setState(() {
              valorInicial = value;
            });
            selected = value;
            seleccionadas = selected.map((item) => item.toString()).toList();
          },
        ));
  }
}
