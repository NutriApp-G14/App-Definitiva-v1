import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/controllers/registroHelpers.dart';
import 'package:my_app/model/Alergias.dart';
import 'dart:math';

import 'package:my_app/model/NavBar.dart';
import 'package:my_app/model/ObjetiveComplete.dart';
import 'package:my_app/model/ObjetiveLast7Days.dart';
import 'package:my_app/model/StaticsCard.dart';
import 'package:my_app/model/Usuario.dart';

class StatisticsPage extends StatefulWidget {
  final String token;
  final nombreUsuario;
  final registros;

  const StatisticsPage({required this.nombreUsuario, required this.registros, required this.token});
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final TextEditingController dayController = TextEditingController();

  DateTime now = DateTime.now();
  late String formattedDate;
  DateTime fecha = DateTime.now();

  final dateController = TextEditingController();

  DataBaseHelper dataBaseHelper = DataBaseHelper();

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
            child: NutriAppBar(nombreUsuario: widget.nombreUsuario,token: widget.token),
          ),
        ),
        //
        body: KeyedSubtree(
            child: SingleChildScrollView(
                child: Column(children: [
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
                    fecha = selectedDate;
                  });
                  print(dateController.text);
                }
              },
              decoration: InputDecoration(
                labelText: 'Fecha',
              ),
            ),
          ),
          StaticsCard(
              nombreUsuario: widget.nombreUsuario,
              fecha: dateController.text,
              day: fecha,
              totalProteinas: 0,
              totalCalorias: 0,
              totalCarbohidratos: 0,
              totalGrasas: 0,
              token: widget.token),
        ]))));

    // //

    //       })
    // ]));
  }
}
