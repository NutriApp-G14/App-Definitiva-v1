import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/controllers/registroHelpers.dart';
import 'package:my_app/model/ObjetiveComplete.dart';
import 'package:my_app/model/ObjetiveLast7Days.dart';
import 'package:my_app/model/Usuario.dart';

class StaticsCard extends StatefulWidget {
  final String nombreUsuario;
  final String fecha;
  final DateTime day;
  final double totalProteinas;
  final double totalCalorias;
  final double totalCarbohidratos;
  final double totalGrasas;

  const StaticsCard(
      {required this.nombreUsuario,
      required this.fecha,
      required this.day,
      required this.totalProteinas,
      required this.totalCalorias,
      required this.totalCarbohidratos,
      required this.totalGrasas});

  @override
  _StaticsCardState createState() => _StaticsCardState();
}

class _StaticsCardState extends State<StaticsCard> {
  RegistroHelper dataRegistroHelper = RegistroHelper();
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
    _futureUsuario = dataBaseHelper.getUsuarioById(widget.nombreUsuario);
    super.initState();
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
    return FutureBuilder(
        future: dataRegistroHelper.getRegistroDiario(
          widget.nombreUsuario,
          widget.fecha,
        ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List registros = snapshot.data;
            var totalCalorias = widget.totalCalorias;
            var totalProteinas = widget.totalProteinas;
            var totalCarbohidratos = widget.totalCarbohidratos;
            var totalGrasas = widget.totalGrasas;
            for (var registro in registros) {
              for (var alimento in registro['alimentos']) {
                totalCalorias +=
                    alimento['calorias'] * alimento['cantidad'] / 100;
              }
            }
            for (var registro in registros) {
              for (var alimento in registro['alimentos']) {
                totalProteinas +=
                    alimento['proteinas'] * alimento['cantidad'] / 100;
              }
            }
            for (var registro in registros) {
              for (var alimento in registro['alimentos']) {
                totalCarbohidratos +=
                    alimento['carbohidratos'] * alimento['cantidad'] / 100;
              }
            }
            for (var registro in registros) {
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
            return SingleChildScrollView(
                child: Column(children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: SizedBox(
                    height: 400, // Establecer altura máxima
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
                              totalCalorias == 0
                                  ? Center(
                                      child: Text(
                                          'No se ha introducido ningún alimento hoy'))
                                  : Expanded(
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
                                          labels: [
                                            'Calorías',
                                            'Proteínas',
                                            'Carbohidratos',
                                            'Grasas'
                                          ],
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
              FutureBuilder<Usuario>(
                  future: _futureUsuario,
                  builder:
                      (BuildContext context, AsyncSnapshot<Usuario> snapshot) {
                    if (snapshot.hasData) {
                      final usuario = snapshot.data!;

                      _edad = calcularEdad(usuario
                          .age); // llamamos a la función para calcular la edad
                      _peso = double.parse(usuario.weight);
                      _altura = double.parse(usuario.height);
                      _sexo = usuario.gender;
                      _objectiveSeleccionado = usuario.objective;
                      double _tmb = _calculateTmb(_peso, _altura, _sexo, _edad);
                      if (_objectiveSeleccionado != "ninguno") {
                        requerimientoCalorico = _factorActividad(
                            usuario.activity,
                            _tmb,
                            _objectiveSeleccionado,
                            _peso);
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Card(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 140,
                                  child: PageView.builder(
                                    itemCount: 4,
                                    itemBuilder: (context, index) {
                                      switch (index) {
                                        case 0:
                                          return buildNutrientCard(
                                              'Calorías',
                                              requerimientoCalorico[
                                                      'calories'] -
                                                  totalCalorias,
                                              totalCalorias,
                                              false,
                                              true);
                                        case 1:
                                          return buildNutrientCard(
                                              'Proteínas',
                                              requerimientoCalorico['protein'] -
                                                  totalProteinas,
                                              totalProteinas,
                                              true,
                                              true);
                                        case 2:
                                          return buildNutrientCard(
                                              'Carbohidratos',
                                              requerimientoCalorico['carb'] -
                                                  totalCarbohidratos,
                                              totalCarbohidratos,
                                              true,
                                              true);
                                        case 3:
                                          return buildNutrientCard(
                                              'Grasas',
                                              requerimientoCalorico['fat'] -
                                                  totalGrasas,
                                              totalGrasas,
                                              true,
                                              false);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
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
              ObjetiveCard(
                  nombreUsuario: widget.nombreUsuario, fecha: widget.day)
            ]));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

class BarChart extends StatelessWidget {
  final List<double> data;
  final List<Color> colors;
  final List<String>? labels;

  BarChart({required this.data, required this.colors, this.labels});

  @override
  Widget build(BuildContext context) {
    final legendHeight = 16.0; // Altura de la leyenda
    final height = 300.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: height,
          child: CustomPaint(
            painter: BarChartPainter(data: data, colors: colors),
          ),
        ),
        if (labels != null)
          SizedBox(
            height: legendHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                data.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: colors[index],
                      ),
                      SizedBox(width: 8),
                      Text(labels![index]),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<double> data;
  final List<Color> colors;

  BarChartPainter({required this.data, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / data.length;
    final maxValue = data.reduce(max);
    final padding = 16.0; // Espacio adicional para la leyenda

    for (var i = 0; i < data.length; i++) {
      final barHeight = data[i] / maxValue * (size.height - padding);
      final x = i * barWidth;
      final y = (size.height - padding) - barHeight;
      final rect = Rect.fromLTWH(x, y, barWidth, barHeight);
      final paint = Paint()..color = colors[i];
      canvas.drawRect(rect, paint);

      // Añadir texto de leyenda a cada barra
      // final label = data[i].toStringAsFixed(1);
      // final textPainter = TextPainter(
      //   text: TextSpan(
      //     text: '$label\n',
      //     style: TextStyle(color: Colors.black, fontSize: 12),
      //   ),
      //   textDirection: TextDirection.ltr,
      // );
      // textPainter.layout();
      // textPainter.paint(canvas, Offset(x, y - textPainter.height));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
