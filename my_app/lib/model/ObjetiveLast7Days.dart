import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/controllers/registroHelpers.dart';
import 'package:my_app/model/ObjetiveComplete.dart';
import 'package:my_app/model/Usuario.dart';

class ObjetiveCard extends StatefulWidget {
  final String nombreUsuario;
  final DateTime fecha;
  final String token;

  const ObjetiveCard({
    required this.nombreUsuario,
    required this.fecha, required this.token,
  });

  @override
  _ObjetiveCardState createState() => _ObjetiveCardState();
}

class _ObjetiveCardState extends State<ObjetiveCard> {
  RegistroHelper dataRegistroHelper = RegistroHelper();
  List<DateTime> ultimos7Dias = [];
  List<String> fechaUtimos7Dias = [];
  List<List<double>> datos7Dias = [];
  List<List<double>> datosUltimos7Dias = [];

  late Future<Usuario> _futureUsuario;
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  late Map<String, dynamic> requerimientoCalorico;
  var _edad;
  var _peso;
  var _altura;
  var _sexo;
  var _objectiveSeleccionado;

  int calcularEdad(String fechaNacimiento) {
    List<String> fechaNacimientoArray = fechaNacimiento.split("/");
    int dia = int.parse(fechaNacimientoArray[0]);
    int mes = int.parse(fechaNacimientoArray[1]);
    int anio = int.parse(fechaNacimientoArray[2]);
    final fechaActual = DateTime.now();
    int edad = fechaActual.year - anio;
    if (fechaActual.month < mes ||
        (fechaActual.month == mes && fechaActual.day < dia)) {
      edad--;
    }
    return edad;
  }

  double _calculateTmb(double peso, double altura, String sexo, int edad) {
    double tmb = 0.0;
    if (sexo.trim().toLowerCase() == 'hombre') {
      tmb = (10 * peso) + (6.25 * altura) - (5 * edad) + 5;
    } else if (sexo.trim().toLowerCase() == 'mujer') {
      tmb = (10 * peso) + (6.25 * altura) - (5 * edad) - 161;
    }
    return tmb;
  }

  Map<String, dynamic> _factorActividad(String actividad, double tmb,
      String _objectiveSeleccionado, double weight) {
    var calorieRequirement;

    switch (actividad) {
      case 'sedentario':
        calorieRequirement = tmb * 1.2;
        break;
      case 'poco activo':
        calorieRequirement = tmb * 1.375;
        break;
      case 'moderadamente activo':
        calorieRequirement = tmb * 1.55;
        break;
      case 'activo':
        calorieRequirement = tmb * 1.725;
        break;
      case 'muy activo':
        calorieRequirement = tmb * 1.9;
        break;
      default:
        calorieRequirement = tmb;
        break;
    }

    switch (_objectiveSeleccionado) {
      case 'ninguno':
        calorieRequirement = calorieRequirement;
        break;
      case 'perder peso rapidamente':
        calorieRequirement *= 0.8;
        break;
      case 'perder peso lentamente':
        calorieRequirement *= 0.9;
        break;
      case 'mantener peso':
        calorieRequirement *= 1;
        break;
      case 'aumentar peso lentamente':
        calorieRequirement *= 1.1;
        break;
      case 'aumentar peso rapidamente':
        calorieRequirement *= 1.2;
        break;
      default:
        calorieRequirement = calorieRequirement;
        break;
    }

    // Calculate macronutrient ranges
    double protein = weight *
        (_objectiveSeleccionado == 'aumentar peso lentamente' ||
                _objectiveSeleccionado == 'aumentar peso rapidamente'
            ? 2.2
            : 1.8);
    double fat = calorieRequirement * 0.25 / 9;
    double carb = (calorieRequirement - (protein * 4) - (fat * 9)) / 4;

    return {
      'calories': calorieRequirement,
      'protein': protein,
      'fat': fat,
      'carb': carb,
    };
  }

  // List _fetchRegistroData(String fecha) async {
  //   return await dataRegistroHelper.getRegistroDiario(widget.nombreUsuario, fecha);
  // }
  @override
  void initState() {
    _futureUsuario = dataBaseHelper.getUsuarioById(widget.nombreUsuario);
    for (int i = 0; i < 7; i++) {
      DateTime fecha = widget.fecha.subtract(Duration(days: i));
      ultimos7Dias.add(fecha);
    }

    for (int i = 0; i < 7; i++) {
      datosUltimos7Dias.add([0, 0, 0, 0]);
    }

    Future.wait(ultimos7Dias.map((fecha) async {
      String fechaString = DateFormat('dd-MM-yyyy').format(fecha);
      fechaUtimos7Dias.add(fechaString);
      List<dynamic> registros = await dataRegistroHelper.getRegistroDiario(
          widget.nombreUsuario, fechaString, widget.token);
      var totalCalorias = 0.0;
      var totalProteinas = 0.0;
      var totalCarbohidratos = 0.0;
      var totalGrasas = 0.0;
      for (var registro in registros) {
        for (var alimento in registro['alimentos']) {
          totalCalorias += alimento['calorias'] * alimento['cantidad'] / 100;
          totalProteinas += alimento['proteinas'] * alimento['cantidad'] / 100;
          totalCarbohidratos +=
              alimento['carbohidratos'] * alimento['cantidad'] / 100;
          totalGrasas += alimento['grasas'] * alimento['cantidad'] / 100;
        }
      }
      datosUltimos7Dias[ultimos7Dias.indexOf(fecha)][0] = totalCalorias;
      datosUltimos7Dias[ultimos7Dias.indexOf(fecha)][1] = totalProteinas;
      datosUltimos7Dias[ultimos7Dias.indexOf(fecha)][2] = totalCarbohidratos;
      datosUltimos7Dias[ultimos7Dias.indexOf(fecha)][3] = totalGrasas;
    })).then((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // rest of the code here
    return Column(children: [
      FutureBuilder<Usuario>(
          future: _futureUsuario,
          builder: (BuildContext context, AsyncSnapshot<Usuario> snapshot) {
            if (snapshot.hasData) {
              final usuario = snapshot.data!;

              _edad = calcularEdad(
                  usuario.age); // llamamos a la función para calcular la edad
              _peso = double.parse(usuario.weight);
              _altura = double.parse(usuario.height);
              _sexo = usuario.gender;
              _objectiveSeleccionado = usuario.objective;
              double _tmb = _calculateTmb(_peso, _altura, _sexo, _edad);
              requerimientoCalorico = _factorActividad(
                  usuario.activity, _tmb, _objectiveSeleccionado, _peso);

              print(fechaUtimos7Dias);
              return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Card(
                          child: Column(children: [
                        Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                                child: Text(
                              'Objetivos cumplidos últimos 7 días',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ))),
                        Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(children: [
                                    Icon(
                                      datosUltimos7Dias[0][0] >=
                                              requerimientoCalorico['calories']
                                          ? Icons.check_circle
                                          : Icons.check_circle_outline,
                                      color: datosUltimos7Dias[0][0] >=
                                              requerimientoCalorico['calories']
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    Text('${fechaUtimos7Dias[0]}',
                                        style: TextStyle(fontSize: 7))
                                  ]),
                                  Column(children: [
                                    Icon(
                                      datosUltimos7Dias[1][0] >=
                                              requerimientoCalorico['calories']
                                          ? Icons.check_circle
                                          : Icons.check_circle_outline,
                                      color: datosUltimos7Dias[1][0] >=
                                              requerimientoCalorico['calories']
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    Text('${fechaUtimos7Dias[1]}',
                                        style: TextStyle(fontSize: 7))
                                  ]),
                                  Column(children: [
                                    Icon(
                                      datosUltimos7Dias[2][0] >=
                                              requerimientoCalorico['calories']
                                          ? Icons.check_circle
                                          : Icons.check_circle_outline,
                                      color: datosUltimos7Dias[2][0] >=
                                              requerimientoCalorico['calories']
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    Text('${fechaUtimos7Dias[2]}',
                                        style: TextStyle(fontSize: 7))
                                  ]),
                                  Column(children: [
                                    Icon(
                                      datosUltimos7Dias[3][0] >=
                                              requerimientoCalorico['calories']
                                          ? Icons.check_circle
                                          : Icons.check_circle_outline,
                                      color: datosUltimos7Dias[3][0] >=
                                              requerimientoCalorico['calories']
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    Text(
                                      '${fechaUtimos7Dias[3]}',
                                      style: TextStyle(fontSize: 7),
                                    )
                                  ]),
                                  Column(children: [
                                    Icon(
                                      datosUltimos7Dias[4][0] >=
                                              requerimientoCalorico['calories']
                                          ? Icons.check_circle
                                          : Icons.check_circle_outline,
                                      color: datosUltimos7Dias[4][0] >=
                                              requerimientoCalorico['calories']
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    Text('${fechaUtimos7Dias[4]}',
                                        style: TextStyle(fontSize: 7))
                                  ]),
                                  Column(children: [
                                    Icon(
                                      datosUltimos7Dias[5][0] >=
                                              requerimientoCalorico['calories']
                                          ? Icons.check_circle
                                          : Icons.check_circle_outline,
                                      color: datosUltimos7Dias[5][0] >=
                                              requerimientoCalorico['calories']
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    Text('${fechaUtimos7Dias[5]}',
                                        style: TextStyle(fontSize: 7))
                                  ]),
                                  Column(children: [
                                    Icon(
                                      datosUltimos7Dias[6][0] >=
                                              requerimientoCalorico['calories']
                                          ? Icons.check_circle
                                          : Icons.check_circle_outline,
                                      color: datosUltimos7Dias[6][0] >=
                                              requerimientoCalorico['calories']
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    Text('${fechaUtimos7Dias[6]}',
                                        style: TextStyle(fontSize: 7))
                                  ]),
                                ])),
                      ]))));
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              return Center(
                  child: Column(
                children: [
                  SizedBox(height: 305),
                  CircularProgressIndicator(),
                ],
              ));
            }
          }),
      Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Últimos 7 días',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: List.generate(7, (index) {
                  List<double> datosDia = datosUltimos7Dias[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${fechaUtimos7Dias[index]}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 7),
                        ),
                        // },
                        Text('Cal: ${datosDia[0].toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Color.fromARGB(255, 205, 184, 31),
                                fontSize: 10)),
                        Text('P: ${datosDia[1].toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Color.fromARGB(238, 104, 201, 253),
                                fontSize: 10)),
                        Text('H: ${datosDia[2].toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Color.fromARGB(251, 93, 223, 54),
                                fontSize: 10)),
                        Text('G: ${datosDia[3].toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Color.fromARGB(234, 236, 97, 87),
                                fontSize: 10)),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      )
    ]);
  }
}



// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:my_app/controllers/registroHelpers.dart';

//  RegistroHelper dataRegistroHelper = RegistroHelper();

// DateTime now = DateTime.now();
// List<DateTime> ultimos7Dias = [];
// for (int i = 0; i < 7; i++) {
//   DateTime fecha = now.subtract(Duration(days: i));
//   ultimos7Dias.add(fecha);
// }

// List<List<double>> datosUltimos7Dias = [];
// for (int i = 0; i < 7; i++) {
//   datosUltimos7Dias.add([0, 0, 0, 0]);
// }

// for (int i = 0; i < 7; i++) {
//   String fecha = DateFormat('yyyy-MM-dd').format(ultimos7Dias[i]);
//   List registros = await dataRegistroHelper.getRegistroDiario(widget.nombreUsuario, fecha);
//   var totalCalorias = 0.0;
//   var totalProteinas = 0.0;
//   var totalCarbohidratos = 0.0;
//   var totalGrasas = 0.0;
//   for (var registro in registros) {
//     for (var alimento in registro['alimentos']) {
//       totalCalorias += alimento['calorias'] * alimento['cantidad'] / 100;
//       totalProteinas += alimento['proteinas'] * alimento['cantidad'] / 100;
//       totalCarbohidratos += alimento['carbohidratos'] * alimento['cantidad'] / 100;
//       totalGrasas += alimento['grasas'] * alimento['cantidad'] / 100;
//     }
//   }
//   datosUltimos7Dias[i][0] = totalCalorias;
//   datosUltimos7Dias[i][1] = totalProteinas;
//   datosUltimos7Dias[i][2] = totalCarbohidratos;
//   datosUltimos7Dias[i][3] = totalGrasas;
// }
