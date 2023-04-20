import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'mostrarFood.dart';
//import 'package:fl_chart/fl_chart.dart';

class MostrarFood extends StatelessWidget {
  final String name;
  final double cantidad;
  final String unidadesCantidad;
  final double calorias;
  final double grasas;
  final double proteinas;
  final double carbohidratos;
  final double sodio;
  final double azucar;
  final double fibra;
  final String image;

  const MostrarFood({
    required this.name,
    required this.cantidad,
    required this.unidadesCantidad,
    required this.calorias,
    required this.grasas,
    required this.proteinas,
    required this.carbohidratos,
    required this.sodio,
    required this.azucar,
    required this.fibra,
    required this.image,
  });
  final bool isPremium = false;

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Proteínas": proteinas,
      "Hidratos": carbohidratos,
      "Grasas": grasas,
    };
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            height: 60.0,
            decoration: BoxDecoration(color: Colors.orange),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Informacion del alimento',
                      style: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  iconSize: 20,
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
        body: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 5.0),
                //child: SizedBox(height: 10.0) ,)
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 4,
                            child: Container(
                              // Altura personalizada
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 30, 10, 0),
                                  child: Column(children: [
                                    FutureBuilder<http.Response>(
                                      future: http.get(Uri.parse(image)),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.hasData &&
                                            snapshot.data!.statusCode == 200 &&
                                            ['http', 'https'].contains(
                                                Uri.parse(image).scheme)) {
                                          return FadeInImage.assetNetwork(
                                            placeholder:
                                                'assets/placeholder_image.png',
                                            image: image,
                                            fit: BoxFit.cover,
                                          );
                                        } else {
                                          return Image.asset(
                                            'assets/placeholder_image.png',
                                            fit: BoxFit.cover,
                                          );
                                        }
                                      },
                                    ),
                                  ])),
                            )),
                        Expanded(
                          flex: 5,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15),
                                Wrap(children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange),
                                  ),
                                ]),
                                SizedBox(height: 8),
                                Text(
                                  'Cantidad: ',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  '$cantidad $unidadesCantidad',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Proteinas: ${proteinas} ',
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: const Color.fromARGB(
                                          238, 104, 201, 253)),
                                ),
                                Text(
                                  'Carbohidratos: ${carbohidratos} ',
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: const Color.fromARGB(
                                          251, 93, 223, 54)),
                                ),
                                Text(
                                  'Grasas: ${grasas}',
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: const Color.fromARGB(
                                          234, 236, 97, 87)),
                                ),
                              ]),
                        ),
                        Expanded(
                          flex: 6,
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 30),
                                  Center(
                                    child: PieChart(
                                      dataMap: dataMap,
                                      chartRadius: 100,
                                      ringStrokeWidth: 10,
                                      colorList: [
                                        Color.fromARGB(238, 104, 201, 253),
                                        Color.fromARGB(251, 93, 223, 54),
                                        Color.fromARGB(234, 236, 97, 87),
                                      ], // especifica colores para los segmentos
                                      legendOptions: LegendOptions(
                                        showLegends: false,
                                        legendPosition: LegendPosition
                                            .right, // coloca la leyenda a la derecha del gráfico
                                        legendTextStyle: TextStyle(
                                            fontSize: 5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      chartValuesOptions: ChartValuesOptions(
                                        showChartValueBackground: true,
                                        chartValueBackgroundColor:
                                            Colors.grey[200],
                                        chartValueStyle: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        showChartValuesInPercentage: true,
                                        // coloca un fondo gris para los valores del gráfico
                                      ),
                                      chartType: ChartType.ring,
                                      //ringStrokeWidthFactor: 0.3,
                                      // utiliza un gráfico de pastel de anillo
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50.0),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: SizedBox(
                                              height: 20,
                                              width: 150,
                                              child: Center(
                                                  child: Text(
                                                'Información nutricional:',
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              )))),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: SizedBox(
                                              height: 20,
                                              width: 80,
                                              child: Center(
                                                  child: Text(
                                                '45 g',
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              )))),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: SizedBox(
                                              height: 20,
                                              width: 80,
                                              child: Center(
                                                  child: Text(
                                                '${cantidad} ${unidadesCantidad}',
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                              ))))
                                    ]),
                                SizedBox(height: 10),
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(4)),
                                    child: SizedBox(
                                      height: 3,
                                      width: double.maxFinite,
                                    )),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Calorías (Cal):               ',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Color.fromARGB(
                                                    255, 194, 171, 3),
                                              ),
                                            ),
                                            Text(
                                              '${calorias.toStringAsFixed(2)} Cal',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Color.fromARGB(
                                                    255, 194, 171, 3),
                                              ),
                                            ),
                                            Text(
                                              '${calorias.toStringAsFixed(2)} Cal',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Color.fromARGB(
                                                    255, 194, 171, 3),
                                              ),
                                            )
                                          ]),
                                      SizedBox(height: 8.0),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  209, 209, 209, 209),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: SizedBox(
                                            height: 2,
                                            width: double.maxFinite,
                                          )),
                                      SizedBox(height: 8.0),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Proteínas                   ',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Color.fromARGB(
                                                    238, 126, 185, 217),
                                              ),
                                            ),
                                            Text(
                                              '${proteinas.toStringAsFixed(2)} g',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Color.fromARGB(
                                                    238, 126, 185, 217),
                                              ),
                                            ),
                                            Text(
                                              '${proteinas.toStringAsFixed(2)} g',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Color.fromARGB(
                                                    238, 126, 185, 217),
                                              ),
                                            )
                                          ]),
                                      SizedBox(height: 8.0),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  209, 209, 209, 209),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: SizedBox(
                                            height: 2,
                                            width: double.maxFinite,
                                          )),
                                      SizedBox(height: 8.0),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Carbohidratos            ',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Color.fromARGB(
                                                    253, 10, 133, 16),
                                              ),
                                            ),
                                            Text(
                                              '${carbohidratos.toStringAsFixed(2)} g',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Color.fromARGB(
                                                    253, 10, 133, 16),
                                              ),
                                            ),
                                            Text(
                                              '${carbohidratos.toStringAsFixed(2)} g',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Color.fromARGB(
                                                    253, 10, 133, 16),
                                              ),
                                            )
                                          ]),
                                      SizedBox(height: 8.0),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  209, 209, 209, 209),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: SizedBox(
                                            height: 2,
                                            width: double.maxFinite,
                                          )),
                                      SizedBox(height: 8.0),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Grasas                        ',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Color.fromARGB(
                                                    234, 236, 117, 109),
                                              ),
                                            ),
                                            Text(
                                              '${grasas.toStringAsFixed(2)} g',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Color.fromARGB(
                                                    234, 236, 117, 109),
                                              ),
                                            ),
                                            Text(
                                              '${grasas.toStringAsFixed(2)} g',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Color.fromARGB(
                                                    234, 236, 117, 109),
                                              ),
                                            )
                                          ]),
                                      SizedBox(height: 8.0),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  209, 209, 209, 209),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: SizedBox(
                                            height: 2,
                                            width: double.maxFinite,
                                          )),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Sodio                           ',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            if (isPremium) ...[
                                              Column(children: [
                                                SizedBox(height: 8.0),
                                                Text(
                                                  '${sodio.toStringAsFixed(2)} g',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                SizedBox(height: 8.0)
                                              ])
                                            ] else ...[
                                              IconButton(
                                                icon: Icon(
                                                    Icons.workspace_premium),
                                                color: Colors.amber,
                                                iconSize: 15.0,
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Row(children: [
                                                          Text(
                                                              'Solo para premium'),
                                                          Icon(
                                                              Icons
                                                                  .workspace_premium,
                                                              color: Colors
                                                                  .amberAccent)
                                                        ]),
                                                        content: Text(
                                                            'Esta funcionalidad está disponible solo para usuarios premium'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                'Cancelar'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                'Comprar premium'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                hoverColor: Colors.transparent,
                                                mouseCursor: MouseCursor.defer,
                                              ),
                                            ],
                                            if (isPremium) ...[
                                              Column(children: [
                                                SizedBox(height: 8.0),
                                                Text(
                                                  '${sodio.toStringAsFixed(2)} g',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                SizedBox(height: 8.0)
                                              ])
                                            ] else ...[
                                              IconButton(
                                                icon: Icon(
                                                    Icons.workspace_premium),
                                                color: Colors.amber,
                                                iconSize: 15.0,
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Row(children: [
                                                          Text(
                                                              'Solo para premium'),
                                                          Icon(
                                                              Icons
                                                                  .workspace_premium,
                                                              color: Colors
                                                                  .amberAccent)
                                                        ]),
                                                        content: Text(
                                                            'Esta funcionalidad está disponible solo para usuarios premium'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                'Cancelar'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                'Comprar premium'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                hoverColor: Colors.transparent,
                                                mouseCursor: MouseCursor.defer,
                                              ),
                                            ],
                                          ]),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  209, 209, 209, 209),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: SizedBox(
                                            height: 2,
                                            width: double.maxFinite,
                                          )),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Azúcar                          ',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            if (isPremium) ...[
                                              Column(children: [
                                                SizedBox(height: 8.0),
                                                Text(
                                                  '${azucar.toStringAsFixed(2)} g',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                SizedBox(height: 8.0)
                                              ])
                                            ] else ...[
                                              IconButton(
                                                icon: Icon(
                                                    Icons.workspace_premium),
                                                color: Colors.amber,
                                                iconSize: 15.0,
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Row(children: [
                                                          Text(
                                                              'Solo para premium'),
                                                          Icon(
                                                              Icons
                                                                  .workspace_premium,
                                                              color: Colors
                                                                  .amberAccent)
                                                        ]),
                                                        content: Text(
                                                            'Esta funcionalidad está disponible solo para usuarios premium'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                'Cancelar'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                'Comprar premium'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                hoverColor: Colors.transparent,
                                                mouseCursor: MouseCursor.defer,
                                              ),
                                            ],
                                            if (isPremium) ...[
                                              Column(children: [
                                                SizedBox(height: 8.0),
                                                Text(
                                                  '${azucar.toStringAsFixed(2)} g',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                SizedBox(height: 8.0)
                                              ])
                                            ] else ...[
                                              IconButton(
                                                icon: Icon(
                                                    Icons.workspace_premium),
                                                color: Colors.amber,
                                                iconSize: 15.0,
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Row(children: [
                                                          Text(
                                                              'Solo para premium'),
                                                          Icon(
                                                              Icons
                                                                  .workspace_premium,
                                                              color: Colors
                                                                  .amberAccent)
                                                        ]),
                                                        content: Text(
                                                            'Esta funcionalidad está disponible solo para usuarios premium'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                'Cancelar'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                'Comprar premium'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                hoverColor: Colors.transparent,
                                                mouseCursor: MouseCursor.defer,
                                              ),
                                            ],
                                          ]),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  209, 209, 209, 209),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: SizedBox(
                                            height: 2,
                                            width: double.maxFinite,
                                          )),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Fibra                             ',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            if (isPremium) ...[
                                              Column(children: [
                                                SizedBox(height: 8.0),
                                                Text(
                                                  '${fibra.toStringAsFixed(2)} g',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                SizedBox(height: 8.0)
                                              ])
                                            ] else ...[
                                              IconButton(
                                                icon: Icon(
                                                    Icons.workspace_premium),
                                                color: Colors.amber,
                                                iconSize: 15.0,
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Row(children: [
                                                          Text(
                                                              'Solo para premium'),
                                                          Icon(
                                                              Icons
                                                                  .workspace_premium,
                                                              color: Colors
                                                                  .amberAccent)
                                                        ]),
                                                        content: Text(
                                                            'Esta funcionalidad está disponible solo para usuarios premium'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                'Cancelar'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                'Comprar premium'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                hoverColor: Colors.transparent,
                                                mouseCursor: MouseCursor.defer,
                                              ),
                                            ],
                                            if (isPremium) ...[
                                              Column(children: [
                                                SizedBox(height: 8.0),
                                                Text(
                                                  '${fibra.toStringAsFixed(2)} g',
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                SizedBox(height: 8.0)
                                              ])
                                            ] else ...[
                                              IconButton(
                                                icon: Icon(
                                                    Icons.workspace_premium),
                                                color: Colors.amber,
                                                iconSize: 15.0,
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Row(children: [
                                                          Text(
                                                              'Solo para premium'),
                                                          Icon(
                                                              Icons
                                                                  .workspace_premium,
                                                              color: Colors
                                                                  .amberAccent)
                                                        ]),
                                                        content: Text(
                                                            'Esta funcionalidad está disponible solo para usuarios premium'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                'Cancelar'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                'Comprar premium'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                hoverColor: Colors.transparent,
                                                mouseCursor: MouseCursor.defer,
                                              ),
                                            ],
                                          ]),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  209, 209, 209, 209),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: SizedBox(
                                            height: 2,
                                            width: double.maxFinite,
                                          )),
                                      SizedBox(height: 10.0),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 5, 10),
                                  child: Text(""),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Añadir "Mis alimentos"'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            minimumSize: Size(100, 40),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Lógica para el botón Registro
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                  title: Text('Elija un Registro'),
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:  CrossAxisAlignment.center,
                                    children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Text('Desayuno'),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            minimumSize: Size(100, 40),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Text('Almuerzo'),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            minimumSize: Size(100, 40),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Text('Comida'),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            minimumSize: Size(100, 40),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Text('Merienda'),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            minimumSize: Size(100, 40),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Text('Cena'),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            minimumSize: Size(100, 40),
                                          ),
                                        )
                                      ],
                                    ),
                                  ])),
                            );
                          },
                          child: Text('Registro'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            minimumSize: Size(100, 40),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20)
                  ],
                ))
          ],
        ));
  }
}
