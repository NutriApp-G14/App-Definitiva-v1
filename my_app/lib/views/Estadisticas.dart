import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/controllers/registroHelpers.dart';
import 'dart:math';

import 'package:my_app/model/NavBar.dart';
import 'package:my_app/model/Usuario.dart';

double totalCalorias = 0;
double totalProteinas = 0;
double totalCarbohidratos = 0;
double totalGrasas = 0;

class StatisticsPage extends StatefulWidget {
  final nombreUsuario;
  final registros;

  const StatisticsPage({required this.nombreUsuario, required this.registros});
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late Future<Usuario> _futureUsuario;
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  late Map<String, dynamic> requerimientoCalorico;
  var _edad;
  var _peso;
  var _altura;
  var _sexo;
  var _objectiveSeleccionado;

  @override
  void initState() {
    //super.initState();
    _futureUsuario = dataBaseHelper.getUsuarioById(widget.nombreUsuario);
  }

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
    }

    switch (_objectiveSeleccionado) {
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

  @override
  Widget build(BuildContext context) {
    for (var registro in widget.registros) {
      for (var alimento in registro['alimentos']) {
        totalCalorias += alimento['calorias'] * alimento['cantidad'] / 100;
      }
    }
    for (var registro in widget.registros) {
      for (var alimento in registro['alimentos']) {
        totalProteinas += alimento['proteinas'] * alimento['cantidad'] / 100;
      }
    }
    for (var registro in widget.registros) {
      for (var alimento in registro['alimentos']) {
        totalCarbohidratos +=
            alimento['carbohidratos'] * alimento['cantidad'] / 100;
      }
    }
    for (var registro in widget.registros) {
      for (var alimento in registro['alimentos']) {
        totalGrasas += alimento['grasas'] * alimento['cantidad'] / 100;
      }
    }
    List<double> data = [
      totalCalorias,
      totalProteinas,
      totalCarbohidratos,
      totalGrasas
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(52),
          child: NutriAppBar(nombreUsuario: widget.nombreUsuario),
        ),
      ),
      //
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                  margin: EdgeInsets.only(bottom: 0),
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: BarChart(
                              data: data,
                              colors: [
                                Color.fromARGB(255, 255, 241, 134),
                                Color.fromARGB(238, 104, 201, 253),
                                Color.fromARGB(251, 93, 223, 54),
                                Color.fromARGB(234, 236, 97, 87)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )))),
    );

    //ListView(children: [

    //   FutureBuilder<Usuario>(
    //       future: _futureUsuario,
    //       builder: (BuildContext context, AsyncSnapshot<Usuario> snapshot) {
    //         if (snapshot.hasData) {
    //           final usuario = snapshot.data!;

    //           _edad = calcularEdad(usuario
    //               .age); // llamamos a la función para calcular la edad
    //           _peso = double.parse(usuario.weight);
    //           _altura = double.parse(usuario.height);
    //           _sexo = usuario.gender;
    //           _objectiveSeleccionado = usuario.objective;
    //           double _tmb = _calculateTmb(_peso, _altura, _sexo, _edad);
    //           if (_objectiveSeleccionado != "ninguno") {
    //             requerimientoCalorico = _factorActividad(
    //                 usuario.activity, _tmb, _objectiveSeleccionado, _peso);
    //           }

    //           return Padding(
    //               padding: const EdgeInsets.symmetric(
    //                   vertical: 10, horizontal: 10),
    //               child: Container(
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(20),
    //                     boxShadow: [
    //                       BoxShadow(
    //                         color: Colors.grey.withOpacity(0.5),
    //                         spreadRadius: 5,
    //                         blurRadius: 7,
    //                         offset:
    //                             Offset(0, 3), // changes position of shadow
    //                       ),
    //                     ],
    //                   ),
    //                   child: Card(
    //                     child: Column(
    //                       children: [
    //                         // Consumo de calorías
    //                         ListTile(
    //                           title: Text('Calorías'),
    //                           trailing: Row(
    //                             mainAxisSize: MainAxisSize.min,
    //                             children: [
    //                               Text(
    //                                   '${requerimientoCalorico['calories'] - totalCalorias} restantes'),
    //                               SizedBox(width: 10),
    //                               Text('$totalCalorias consumidas'),
    //                             ],
    //                           ),
    //                         ),
    //                         Divider(),

    //                         // Consumo de proteínas
    //                         ListTile(
    //                           title: Text('Proteínas'),
    //                           trailing: Row(
    //                             mainAxisSize: MainAxisSize.min,
    //                             children: [
    //                               Text(
    //                                   '${requerimientoCalorico['protein'] - totalProteinas} restantes'),
    //                               SizedBox(width: 10),
    //                               Text('$totalProteinas consumidas'),
    //                             ],
    //                           ),
    //                         ),
    //                         Divider(),

    //                         // Consumo de carbohidratos
    //                         ListTile(
    //                           title: Text('Carbohidratos'),
    //                           trailing: Row(
    //                             mainAxisSize: MainAxisSize.min,
    //                             children: [
    //                               Text(
    //                                   '${requerimientoCalorico['carb'] - totalCarbohidratos} restantes'),
    //                               SizedBox(width: 10),
    //                               Text('$totalCarbohidratos consumidos'),
    //                             ],
    //                           ),
    //                         ),
    //                         Divider(),

    //                         // Consumo de grasas
    //                         ListTile(
    //                           title: Text('Grasas'),
    //                           trailing: Row(
    //                             mainAxisSize: MainAxisSize.min,
    //                             children: [
    //                               Text(
    //                                   '${requerimientoCalorico['fat'] - totalGrasas} restantes'),
    //                               SizedBox(width: 10),
    //                               Text('$totalGrasas consumidas'),
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   )));
    //         } else if (snapshot.hasError) {
    //           return Center(
    //             child: Text("Error: ${snapshot.error}"),
    //           );
    //         } else {
    //           return Center(
    //               child: Column(
    //             children: [
    //               SizedBox(height: 305),
    //               CircularProgressIndicator(),
    //             ],
    //           ));
    //         }
    //       })
    // ]));
  }
}

class BarChart extends StatelessWidget {
  final List<double> data;
  final List<Color> colors;

  BarChart({required this.data, required this.colors});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BarChartPainter(data: data, color: colors),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<double> data;
  final List<Color> color;

  BarChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / data.length;
    final maxValue = data.reduce(max);

    for (var i = 0; i < data.length; i++) {
      final barHeight = data[i] / maxValue * size.height;
      final x = i * barWidth;
      final y = size.height - barHeight;
      final rect = Rect.fromLTWH(x, y, barWidth, barHeight);
      final paint = Paint()..color = color[i];
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
