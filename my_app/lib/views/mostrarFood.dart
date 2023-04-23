import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:ffi' as ffi;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/controllers/registroHelpers.dart';
import 'package:my_app/model/Alimento.dart';
import 'package:my_app/views/listviewfood.dart';
import 'package:pie_chart/pie_chart.dart';
import 'mostrarFood.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:fl_chart/fl_chart.dart';

//final urlConexion1 = 'http://localhost:8080';
//final urlConexion1 = 'http://localhost:8080';
//final urlConexion1 = 'http://35.241.179.64:8080';
final urlConexion1 = 'http://35.189.241.218:8080';



class MostrarFood extends StatefulWidget {
  final int id;
  final String codigoDeBarras;
  final String nombreUsuario;
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
    required this.id,
    required this.codigoDeBarras,
    required this.nombreUsuario,
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
  @override
  _MostrarFoodState createState() => _MostrarFoodState();
}

class _MostrarFoodState extends State<MostrarFood> {
  RegistroHelper registrohelper = RegistroHelper();
  DateTime now = DateTime.now();
  late String formattedDate;



  DataBaseHelper dataBaseHelper = DataBaseHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
  }

  _navigateListAlimento(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ListAlimentos(nombreUsuario: widget.nombreUsuario)));
  }

  _recalucularInformacion(
      double informacion, double cantidad, double cantidadInicial) {
    return (cantidad * informacion) / cantidadInicial;
  }

  final bool isPremium = false;

  double cantidad = 0.0;
  var unidadesCantidad = 0.0;
  double calorias = 0.0;
  double proteinas = 0.0;
  double carbohidratos = 0.0;
  double grasas = 0.0;
  double fibra = 0.0;
  double sodio = 0.0;
  double azucar = 0.0;

  @override
  Widget build(BuildContext context) {
    var nueva_cantidad = cantidad != 0.0 ? cantidad : widget.cantidad;
    calorias = _recalucularInformacion(widget.calorias, nueva_cantidad, 100);
    proteinas = _recalucularInformacion(widget.proteinas, nueva_cantidad, 100);
    carbohidratos =
        _recalucularInformacion(widget.carbohidratos, nueva_cantidad, 100);
    grasas = _recalucularInformacion(widget.grasas, nueva_cantidad, 100);
    azucar = _recalucularInformacion(widget.azucar, nueva_cantidad, 100);
    sodio = _recalucularInformacion(widget.sodio, nueva_cantidad, 100);
    fibra = _recalucularInformacion(widget.fibra, nueva_cantidad, 100);
    double calculoCalorias = calorias;
    double calculoProteinas = proteinas;
    double calculoCarbohidratos = carbohidratos;
    double calculoGrasas = grasas;
    double calculoSodio = sodio;
    double calculoFibra = fibra;
    double calculoAzucar = azucar;
    Map<String, double> dataMap = {
      "Proteínas": calculoProteinas,
      "Hidratos": calculoCarbohidratos,
      "Grasas": calculoGrasas,
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
                                    widget.image != null && widget.image != ""
                                        ? FutureBuilder<http.Response>(
                                            future: http
                                                .get(Uri.parse(widget.image)),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                      ConnectionState.done &&
                                                  snapshot.hasData &&
                                                  snapshot.data!.statusCode ==
                                                      200 &&
                                                  ['http', 'https'].contains(
                                                      Uri.parse(widget.image)
                                                          .scheme)) {
                                                return FadeInImage.assetNetwork(
                                                  placeholder:
                                                      'assets/placeholder_image.png',
                                                  image: widget.image,
                                                  fit: BoxFit.cover,
                                                );
                                              } else {
                                                return Image.asset(
                                                  'assets/placeholder_image.png',
                                                  fit: BoxFit.cover,
                                                );
                                              }
                                            },
                                          )
                                        : Container(
                                            child: Image.asset(
                                            'assets/placeholder_image.png',
                                            fit: BoxFit.cover,
                                          )),
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
                                    widget.name,
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
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '$nueva_cantidad ${widget.unidadesCantidad}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 16.0),
                                        decoration: InputDecoration(
                                          hintText: '$nueva_cantidad',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: BorderSide(
                                              color: Colors.orange,
                                              width: 1.0,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 5.0),
                                          isDense: true,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            cantidad = (value.isNotEmpty
                                                ? double.tryParse(value)
                                                : 0.0)!;
                                            var nueva_cantidad = cantidad != 0.0
                                                ? cantidad
                                                : widget.cantidad;
                                            calorias = _recalucularInformacion(
                                                widget.calorias,
                                                nueva_cantidad,
                                                100);
                                            proteinas = _recalucularInformacion(
                                                widget.proteinas,
                                                nueva_cantidad,
                                                100);
                                            carbohidratos =
                                                _recalucularInformacion(
                                                    widget.carbohidratos,
                                                    nueva_cantidad,
                                                    100);
                                            grasas = _recalucularInformacion(
                                                widget.grasas,
                                                nueva_cantidad,
                                                100);
                                            azucar = _recalucularInformacion(
                                                widget.azucar,
                                                nueva_cantidad,
                                                100);
                                            sodio = _recalucularInformacion(
                                                widget.sodio,
                                                nueva_cantidad,
                                                100);
                                            fibra = _recalucularInformacion(
                                                widget.fibra,
                                                nueva_cantidad,
                                                100);
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                  ],

                                  // DropdownButton<String>(
                                  //   value: unidadesCantidad,
                                  //   onChanged: (String? newValue) {
                                  //     setState(() {
                                  //       unidadesCantidad = newValue ?? '';
                                  //     });
                                  //   },
                                  //   items: ['kg', 'g', 'oz', 'lb']
                                  //       .map<DropdownMenuItem<String>>(
                                  //           (String value) {
                                  //     return DropdownMenuItem<String>(
                                  //       value: value,
                                  //       child: Text(value),
                                  //     );
                                  //   }).toList(),
                                  // ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Proteinas: ${calculoProteinas.toStringAsFixed(2)} ',
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: const Color.fromARGB(
                                          238, 104, 201, 253)),
                                ),
                                Text(
                                  'Carbohidratos: ${calculoCarbohidratos.toStringAsFixed(2)} ',
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: const Color.fromARGB(
                                          251, 93, 223, 54)),
                                ),
                                Text(
                                  'Grasas: ${calculoGrasas.toStringAsFixed(2)}',
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
                                      nueva_cantidad != 100.0
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: SizedBox(
                                                  height: 20,
                                                  width: 80,
                                                  child: Center(
                                                      child: Text(
                                                    '$nueva_cantidad  ${widget.unidadesCantidad}',
                                                    style: TextStyle(
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white),
                                                  ))))
                                          : Container(),
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
                                                '100 ${widget.unidadesCantidad}',
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
                                            nueva_cantidad != 100.0
                                                ? Text(
                                                    '${calculoCalorias.toStringAsFixed(2)} Cal',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Color.fromARGB(
                                                          255, 194, 171, 3),
                                                    ),
                                                  )
                                                : Container(),
                                            Text(
                                              '${widget.calorias.toStringAsFixed(2)} Cal',
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
                                            nueva_cantidad != 100.0
                                                ? Text(
                                                    '${calculoProteinas.toStringAsFixed(2)} g',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Color.fromARGB(
                                                          238, 126, 185, 217),
                                                    ),
                                                  )
                                                : Container(),
                                            Text(
                                              '${widget.proteinas.toStringAsFixed(2)} g',
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
                                            nueva_cantidad != 100.0
                                                ? Text(
                                                    '${calculoCarbohidratos.toStringAsFixed(2)} g',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Color.fromARGB(
                                                          253, 10, 133, 16),
                                                    ),
                                                  )
                                                : Container(),
                                            Text(
                                              '${widget.carbohidratos.toStringAsFixed(2)} g',
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
                                            nueva_cantidad != 100.0
                                                ? Text(
                                                    '${calculoGrasas.toStringAsFixed(2)} g',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Color.fromARGB(
                                                          234, 236, 117, 109),
                                                    ),
                                                  )
                                                : Container(),
                                            Text(
                                              '${widget.grasas.toStringAsFixed(2)} g',
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
                                            nueva_cantidad != 100.0
                                                ? (isPremium)
                                                    ? Column(children: [
                                                        SizedBox(height: 8.0),
                                                        Text(
                                                          '${calculoSodio.toStringAsFixed(2)} g',
                                                          style: TextStyle(
                                                            fontSize: 13.0,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        SizedBox(height: 8.0)
                                                      ])
                                                    : IconButton(
                                                        icon: Icon(Icons
                                                            .workspace_premium),
                                                        color: Colors.amber,
                                                        iconSize: 15.0,
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Row(
                                                                    children: [
                                                                      Text(
                                                                          'Solo para premium'),
                                                                      Icon(
                                                                          Icons
                                                                              .workspace_premium,
                                                                          color:
                                                                              Colors.amberAccent)
                                                                    ]),
                                                                content: Text(
                                                                    'Esta funcionalidad está disponible solo para usuarios premium'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Cancelar'),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
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
                                                        hoverColor:
                                                            Colors.transparent,
                                                        mouseCursor:
                                                            MouseCursor.defer,
                                                      )
                                                : Container(),
                                            (isPremium)
                                                ? Column(children: [
                                                    SizedBox(height: 8.0),
                                                    Text(
                                                      '${widget.sodio.toStringAsFixed(2)} g',
                                                      style: TextStyle(
                                                        fontSize: 13.0,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8.0)
                                                  ])
                                                : IconButton(
                                                    icon: Icon(Icons
                                                        .workspace_premium),
                                                    color: Colors.amber,
                                                    iconSize: 15.0,
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title:
                                                                Row(children: [
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
                                                    hoverColor:
                                                        Colors.transparent,
                                                    mouseCursor:
                                                        MouseCursor.defer,
                                                  ),
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
                                            nueva_cantidad != 100.0
                                                ? (isPremium)
                                                    ? Column(children: [
                                                        SizedBox(height: 8.0),
                                                        Text(
                                                          '${calculoAzucar.toStringAsFixed(2)} g',
                                                          style: TextStyle(
                                                            fontSize: 13.0,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        SizedBox(height: 8.0)
                                                      ])
                                                    : IconButton(
                                                        icon: Icon(Icons
                                                            .workspace_premium),
                                                        color: Colors.amber,
                                                        iconSize: 15.0,
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Row(
                                                                    children: [
                                                                      Text(
                                                                          'Solo para premium'),
                                                                      Icon(
                                                                          Icons
                                                                              .workspace_premium,
                                                                          color:
                                                                              Colors.amberAccent)
                                                                    ]),
                                                                content: Text(
                                                                    'Esta funcionalidad está disponible solo para usuarios premium'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Cancelar'),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
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
                                                        hoverColor:
                                                            Colors.transparent,
                                                        mouseCursor:
                                                            MouseCursor.defer,
                                                      )
                                                : Container(),
                                            (isPremium)
                                                ? Column(children: [
                                                    SizedBox(height: 8.0),
                                                    Text(
                                                      '${widget.azucar.toStringAsFixed(2)} g',
                                                      style: TextStyle(
                                                        fontSize: 13.0,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8.0)
                                                  ])
                                                : IconButton(
                                                    icon: Icon(Icons
                                                        .workspace_premium),
                                                    color: Colors.amber,
                                                    iconSize: 15.0,
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title:
                                                                Row(children: [
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
                                                    hoverColor:
                                                        Colors.transparent,
                                                    mouseCursor:
                                                        MouseCursor.defer,
                                                  ),
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
                                            nueva_cantidad != 100.0
                                                ? (isPremium)
                                                    ? Column(children: [
                                                        SizedBox(height: 8.0),
                                                        Text(
                                                          '${calculoFibra.toStringAsFixed(2)} g',
                                                          style: TextStyle(
                                                            fontSize: 13.0,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        SizedBox(height: 8.0)
                                                      ])
                                                    : IconButton(
                                                        icon: Icon(Icons
                                                            .workspace_premium),
                                                        color: Colors.amber,
                                                        iconSize: 15.0,
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Row(
                                                                    children: [
                                                                      Text(
                                                                          'Solo para premium'),
                                                                      Icon(
                                                                          Icons
                                                                              .workspace_premium,
                                                                          color:
                                                                              Colors.amberAccent)
                                                                    ]),
                                                                content: Text(
                                                                    'Esta funcionalidad está disponible solo para usuarios premium'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Cancelar'),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
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
                                                        hoverColor:
                                                            Colors.transparent,
                                                        mouseCursor:
                                                            MouseCursor.defer,
                                                      )
                                                : Container(),
                                            if (isPremium) ...[
                                              Column(children: [
                                                SizedBox(height: 8.0),
                                                Text(
                                                  '${widget.fibra.toStringAsFixed(2)} g',
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
                          onPressed: () {
                            insertarAlimento(
                                widget.nombreUsuario,
                                widget.name,
                                widget.calorias,
                                widget.cantidad,
                                widget.unidadesCantidad,
                                widget.grasas,
                                widget.proteinas,
                                widget.carbohidratos,
                                widget.sodio,
                                widget.azucar,
                                widget.fibra,
                                widget.image,
                                widget.codigoDeBarras);
                          },
                          child: Text('Añadir "Mis alimentos"'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),

                            /// minimumSize: //Size(100, 40),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            //Lógica para el botón Registro
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                  title: Text('Elija un Registro'),
                                  content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                registrohelper.addRegistro(
                                                    widget.codigoDeBarras
                                                        .trim()
                                                        .toLowerCase(),
                                                    widget.cantidad,
                                                    widget.nombreUsuario
                                                        .trim()
                                                        .toLowerCase(),
                                                    formattedDate
                                                        .trim()
                                                        .toLowerCase(),
                                                    'Desayuno'
                                                        .trim()
                                                        .toLowerCase(),
                                                      widget.name.trim());

                                              },
                                              child: Text('Desayuno'),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                //  minimumSize: Size(100, 40),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                registrohelper.addRegistro(
                                                    widget.codigoDeBarras
                                                        .trim()
                                                        .toLowerCase(),
                                                    widget.cantidad,
                                                    widget.nombreUsuario
                                                        .trim()
                                                        .toLowerCase(),
                                                    formattedDate
                                                        .trim()
                                                        .toLowerCase(),
                                                    'Almuerzo'
                                                        .trim()
                                                        .toLowerCase(),
                                                    widget.name.trim());
                                              },
                                              child: Text('Almuerzo'),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                //minimumSize: Size(100, 40),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                registrohelper.addRegistro(
                                                    widget.codigoDeBarras
                                                        .trim()
                                                        .toLowerCase(),
                                                    widget.cantidad,
                                                    widget.nombreUsuario
                                                        .trim()
                                                        .toLowerCase(),
                                                    formattedDate
                                                        .trim()
                                                        .toLowerCase(),
                                                    'Comida'
                                                        .trim()
                                                        .toLowerCase(),
                                                      widget.name.trim());
                                              },
                                              child: Text('Comida'),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                // minimumSize: Size(100, 40),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                registrohelper.addRegistro(
                                                    widget.codigoDeBarras
                                                        .trim()
                                                        .toLowerCase(),
                                                    widget.cantidad,
                                                    widget.nombreUsuario
                                                        .trim()
                                                        .toLowerCase(),
                                                    formattedDate
                                                        .trim()
                                                        .toLowerCase(),
                                                    'Merienda'
                                                        .trim()
                                                        .toLowerCase(),
                                                      widget.name.trim());
                                              },
                                              child: Text('Merienda'),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                // minimumSize: Size(100, 40),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                registrohelper.addRegistro(
                                                    widget.codigoDeBarras
                                                        .trim()
                                                        .toLowerCase(),
                                                    widget.cantidad,
                                                    widget.nombreUsuario
                                                        .trim()
                                                        .toLowerCase(),
                                                    formattedDate
                                                        .trim()
                                                        .toLowerCase(),
                                                    'Cena'
                                                        .trim()
                                                        .toLowerCase(),
                                                      widget.name.trim());
                                              },
                                              child: Text('Cena'),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                // minimumSize: Size(100, 40),
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
                            // minimumSize: ffi.Size(100, 40),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Lógica para actualizar alimento
                          updateAlimento(
                              widget.id,
                              widget.name,
                              nueva_cantidad,
                              widget.unidadesCantidad,
                              widget.calorias,
                              widget.grasas,
                              widget.proteinas,
                              widget.carbohidratos,
                              widget.image,
                              widget.nombreUsuario,
                              widget.sodio,
                              widget.azucar,
                              widget.fibra,
                              widget.codigoDeBarras);

                          cantidad == 0;

                        },
                        child: Text('Guardar cambios'),
                      ),
                    ),
                    SizedBox(height: 20)
                  ],
                )),
          ],
        ));
  }

  Future<http.Response> updateAlimento(
      int idController,
      String nameController,
      double cantidadController,
      String unidadesCantidadController,
      double caloriasController,
      double grasasController,
      double proteinasController,
      double carbohidratosController,
      String imageController,
      String nombreUsuarioController,
      double sodioController,
      double azucarController,
      double fibraController,
      String codigoDeBarrasController) async {
    var url = "${urlConexion1}/foods/$idController";
    Map data = {
      'name': nameController,
      'cantidad': cantidadController,
      'unidadesCantidad': unidadesCantidadController,
      'calorias': caloriasController,
      'grasas': grasasController,
      'proteinas': proteinasController,
      'carbohidratos': carbohidratosController,
      'image': imageController,
      'nombreUsuario': nombreUsuarioController,
      'sodio': sodioController,
      'azucar': azucarController,
      'fibra': fibraController,
      'codigoDeBarras': codigoDeBarrasController,
    };
    var body = json.encode(data);
    var response = await http.put(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    //Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ListAlimentos(nombreUsuario: widget.nombreUsuario)));
    return response;
  }

  Future<http.Response> insertarAlimento(
      String nombreUsuario,
      String name,
      double calorias,
      double cantidad,
      String unidadesCantidad,
      double carbohidratos,
      double grasas,
      double proteinas,
      double sodio,
      double azucar,
      double fibra,
      String image,
      String codigoDeBarras) async {
    final response = await http.post(
      Uri.parse('${urlConexion1}/foods/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'calorias': calorias,
        'cantidad': cantidad,
        'unidadesCantidad': unidadesCantidad,
        'carbohidratos': carbohidratos,
        'grasas': grasas,
        'fibra': fibra,
        'proteinas': proteinas,
        'sodio': sodio,
        'azucar': azucar,
        'image': image,
        'nombreUsuario': nombreUsuario,
        'codigoDeBarras': codigoDeBarras
      }),
    );
    Navigator.pop(context);
    _navigateListAlimento(context);
    return response;
  }
}
