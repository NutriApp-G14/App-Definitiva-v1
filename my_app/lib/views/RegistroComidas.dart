import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_app/model/NavBar.dart';
import 'package:my_app/model/TipoComidaCard.dart';

class RegistroComidasPage extends StatefulWidget {
  final String nombreUsuario;
  final String token;

  RegistroComidasPage({
    required this.nombreUsuario, required this.token,
  });

  @override
  _RegistroComidasPageState createState() => _RegistroComidasPageState();
}

class _RegistroComidasPageState extends State<RegistroComidasPage> {
  final TextEditingController dayController = TextEditingController();

  DateTime now = DateTime.now();
  late String formattedDate;

  final dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
    dateController.text = formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(52),
            child: NutriAppBar(nombreUsuario: widget.nombreUsuario,token:widget.token),
          ),
        ),
        body: KeyedSubtree(
            child: SingleChildScrollView(
                child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: dateController,
                onTap: () async {
                  final DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      formattedDate =
                          DateFormat('dd-MM-yyyy').format(selectedDate);
                      dateController.text = formattedDate;
                    });
                    print(dateController.text);
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Fecha',
                ),
              ),
            ),
            TipoComidaCard(
              nombreUsuario: widget.nombreUsuario,
              tipoDeComida: "Desayuno",
              day: dateController.text,
              proteinasFoods: 0,
              carbohidratosFoods: 0,
              caloriasFoods: 0,
              grasasFoods: 0,
              token:widget.token
            ),
            TipoComidaCard(
              nombreUsuario: widget.nombreUsuario,
              tipoDeComida: "Almuerzo",
              day: dateController.text,
              proteinasFoods: 0,
              carbohidratosFoods: 0,
              caloriasFoods: 0,
              grasasFoods: 0,
              token:widget.token
            ),
            TipoComidaCard(
              nombreUsuario: widget.nombreUsuario,
              tipoDeComida: "Comida",
              day: dateController.text,
              proteinasFoods: 0,
              carbohidratosFoods: 0,
              caloriasFoods: 0,
              grasasFoods: 0,
              token:widget.token
            ),
            TipoComidaCard(
              nombreUsuario: widget.nombreUsuario,
              tipoDeComida: "Merienda",
              day: dateController.text,
              proteinasFoods: 0,
              carbohidratosFoods: 0,
              caloriasFoods: 0,
              grasasFoods: 0,
              token:widget.token
            ),
            TipoComidaCard(
              nombreUsuario: widget.nombreUsuario,
              tipoDeComida: "Cena",
              day: dateController.text,
              proteinasFoods: 0,
              carbohidratosFoods: 0,
              caloriasFoods: 0,
              grasasFoods: 0,
              token:widget.token
            ),
          ],
        ))));
  }
}
