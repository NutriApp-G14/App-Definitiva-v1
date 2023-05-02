import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/model/TarjetaBuscador.dart';
import 'package:my_app/views/listviewfood.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:my_app/views/mostrarFood.dart';

class BuscadorNuevo extends StatefulWidget {
  final String nombreUsuario;
  final String fecha;
  final String tipoDeComida = "";

  const BuscadorNuevo({required this.nombreUsuario, required this.fecha});

  @override
  _BuscadorNuevoState createState() => _BuscadorNuevoState();
}

class _BuscadorNuevoState extends State<BuscadorNuevo> {
  String _query = '';
  var _listaDeAlimentos = [];
  var alimentoCodBar = [];

  void _onSubmitSearch() async {
    if (_query.isNotEmpty) {
      await searchAndDisplayFoodNuevaAPI(_query);
    }
  }

  _navigateListAlimento(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ListAlimentos(nombreUsuario: widget.nombreUsuario)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Buscador de comidas',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_sharp),
            onPressed: () {
              _navigateListAlimento(context);
            },
            color: Colors.black,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextField(
              onChanged: (query) {
                setState(() {
                  _query = query;
                });
              },
              onSubmitted: (value) {
                _onSubmitSearch();
              },
              decoration: InputDecoration(
                hintText: 'Introduce el nombre de la comida',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                suffixIcon: IconButton(
                  icon: Icon(Icons.barcode_reader),
                  onPressed: _scanBarcode,
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _onSubmitSearch,
              child: Text('Buscar'),
            ),
            Flexible(child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 600) {
                return GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: _listaDeAlimentos == null
                        ? 0
                        : _listaDeAlimentos.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemBuilder: (context, i) {
                      var nombreUsuario = widget.nombreUsuario;
                      var codigoDeBarras = _listaDeAlimentos[i]['_id'];
                      var cantidad = 100.0;
                      var nombreAlimento =
                          _listaDeAlimentos[i]['product_name'] ?? "";
                      var imageUrl = _listaDeAlimentos[i]['image_url'] ?? "";
                      var nutriscore =
                          _listaDeAlimentos[i]['nutriscore_grade'] ?? "";
                      var novaGroup = _listaDeAlimentos[i]['nova_group'] ?? "";
                      var ecoscore =
                          _listaDeAlimentos[i]['ecoscore_grade'] ?? "";

                      var unidadesCantidad = "gramos";
                      var calorias = (_listaDeAlimentos[i]['nutriments']
                              ?['energy-kcal_100g'] is String)
                          ? double.parse(_listaDeAlimentos[i]['nutriments']
                              ['energy-kcal_100g'])
                          : _listaDeAlimentos[i]['nutriments']
                                      ['energy-kcal_100g']
                                  ?.toDouble() ??
                              0.0;
                      var grasas = (_listaDeAlimentos[i]['nutriments']
                              ?['fat_100g'] is String)
                          ? double.parse(
                              _listaDeAlimentos[i]['nutriments']['fat_100g'])
                          : _listaDeAlimentos[i]['nutriments']['fat_100g']
                                  ?.toDouble() ??
                              0.0;
                      var proteinas = (_listaDeAlimentos[i]['nutriments']
                              ?['proteins_100g'] is String)
                          ? double.parse(_listaDeAlimentos[i]['nutriments']
                              ['proteins_100g'])
                          : _listaDeAlimentos[i]['nutriments']['proteins_100g']
                                  ?.toDouble() ??
                              0.0;
                      var carbohidratos = (_listaDeAlimentos[i]['nutriments']
                              ?['carbohydrates_100g'] is String)
                          ? double.parse(_listaDeAlimentos[i]['nutriments']
                              ['carbohydrates_100g'])
                          : _listaDeAlimentos[i]['nutriments']
                                      ['carbohydrates_100g']
                                  ?.toDouble() ??
                              0.0;
                      var sodio = (_listaDeAlimentos[i]['nutriments']
                              ?['sodium_100g'] is String)
                          ? double.parse(
                              _listaDeAlimentos[i]['nutriments']['sodium_100g'])
                          : _listaDeAlimentos[i]['nutriments']['sodium_100g']
                                  ?.toDouble() ??
                              0.0;
                      var azucar = (_listaDeAlimentos[i]['nutriments']
                              ?['sugars_100g'] is String)
                          ? double.parse(
                              _listaDeAlimentos[i]['nutriments']['sugars_100g'])
                          : _listaDeAlimentos[i]['nutriments']['sugars_100g']
                                  ?.toDouble() ??
                              0.0;
                      var fibra = (_listaDeAlimentos[i]['nutriments']
                              ?['fiber_100g'] is String)
                          ? double.parse(
                              _listaDeAlimentos[i]['nutriments']['fiber_100g'])
                          : _listaDeAlimentos[i]['nutriments']['fiber_100g']
                                  ?.toDouble() ??
                              0.0;

                      return TarjetaBuscador(
                        tipoDeComida: widget.tipoDeComida,
                        id: 0,
                        nombreUsuario: nombreUsuario,
                        codigoDeBarras: codigoDeBarras,
                        cantidad: cantidad,
                        nombreAlimento: nombreAlimento,
                        imageUrl: imageUrl,
                        scoreImages: [
                          nutriscore == ""
                              ? ""
                              : 'https://static.openfoodfacts.org/images/attributes/nutriscore-$nutriscore.svg',
                          novaGroup == ""
                              ? ""
                              : 'https://static.openfoodfacts.org/images/attributes/nova-group-$novaGroup.svg',
                          ecoscore == ""
                              ? ""
                              : 'https://static.openfoodfacts.org/images/attributes/ecoscore-$ecoscore.svg'
                        ],
                        scoreTitles: [
                          'Nutri-Score $nutriscore',
                          'NOVA Group $novaGroup',
                          'Eco-Score $ecoscore'
                        ],
                        calorias: calorias,
                        grasas: grasas,
                        proteinas: proteinas,
                        unidadesCantidad: unidadesCantidad,
                        carbohidratos: carbohidratos,
                        sodio: sodio,
                        azucar: azucar,
                        fibra: fibra,
                        anadirRegistro: false,
                        day: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                      );
                    });
              } else if (constraints.maxWidth < 1100) {
                return GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: _listaDeAlimentos == null
                        ? 0
                        : _listaDeAlimentos.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemBuilder: (context, i) {
                      var nombreUsuario = widget.nombreUsuario;
                      var codigoDeBarras = _listaDeAlimentos[i]['_id'];
                      var cantidad = 100.0;
                      var nombreAlimento =
                          _listaDeAlimentos[i]['product_name'] ?? "";
                      var imageUrl = _listaDeAlimentos[i]['image_url'] ?? "";
                      var nutriscore =
                          _listaDeAlimentos[i]['nutriscore_grade'] ?? "";
                      var novaGroup = _listaDeAlimentos[i]['nova_group'] ?? "";
                      var ecoscore =
                          _listaDeAlimentos[i]['ecoscore_grade'] ?? "";

                      var unidadesCantidad = "gramos";
                      var calorias = (_listaDeAlimentos[i]['nutriments']
                              ?['energy-kcal_100g'] is String)
                          ? double.parse(_listaDeAlimentos[i]['nutriments']
                              ['energy-kcal_100g'])
                          : _listaDeAlimentos[i]['nutriments']
                                      ['energy-kcal_100g']
                                  ?.toDouble() ??
                              0.0;
                      var grasas = (_listaDeAlimentos[i]['nutriments']
                              ?['fat_100g'] is String)
                          ? double.parse(
                              _listaDeAlimentos[i]['nutriments']['fat_100g'])
                          : _listaDeAlimentos[i]['nutriments']['fat_100g']
                                  ?.toDouble() ??
                              0.0;
                      var proteinas = (_listaDeAlimentos[i]['nutriments']
                              ?['proteins_100g'] is String)
                          ? double.parse(_listaDeAlimentos[i]['nutriments']
                              ['proteins_100g'])
                          : _listaDeAlimentos[i]['nutriments']['proteins_100g']
                                  ?.toDouble() ??
                              0.0;
                      var carbohidratos = (_listaDeAlimentos[i]['nutriments']
                              ?['carbohydrates_100g'] is String)
                          ? double.parse(_listaDeAlimentos[i]['nutriments']
                              ['carbohydrates_100g'])
                          : _listaDeAlimentos[i]['nutriments']
                                      ['carbohydrates_100g']
                                  ?.toDouble() ??
                              0.0;
                      var sodio = (_listaDeAlimentos[i]['nutriments']
                              ?['sodium_100g'] is String)
                          ? double.parse(
                              _listaDeAlimentos[i]['nutriments']['sodium_100g'])
                          : _listaDeAlimentos[i]['nutriments']['sodium_100g']
                                  ?.toDouble() ??
                              0.0;
                      var azucar = (_listaDeAlimentos[i]['nutriments']
                              ?['sugars_100g'] is String)
                          ? double.parse(
                              _listaDeAlimentos[i]['nutriments']['sugars_100g'])
                          : _listaDeAlimentos[i]['nutriments']['sugars_100g']
                                  ?.toDouble() ??
                              0.0;
                      var fibra = (_listaDeAlimentos[i]['nutriments']
                              ?['fiber_100g'] is String)
                          ? double.parse(
                              _listaDeAlimentos[i]['nutriments']['fiber_100g'])
                          : _listaDeAlimentos[i]['nutriments']['fiber_100g']
                                  ?.toDouble() ??
                              0.0;

                      return TarjetaBuscador(
                        tipoDeComida: widget.tipoDeComida,
                        id: 0,
                        nombreUsuario: nombreUsuario,
                        codigoDeBarras: codigoDeBarras,
                        cantidad: cantidad,
                        nombreAlimento: nombreAlimento,
                        imageUrl: imageUrl,
                        scoreImages: [
                          nutriscore == ""
                              ? ""
                              : 'https://static.openfoodfacts.org/images/attributes/nutriscore-$nutriscore.svg',
                          novaGroup == ""
                              ? ""
                              : 'https://static.openfoodfacts.org/images/attributes/nova-group-$novaGroup.svg',
                          ecoscore == ""
                              ? ""
                              : 'https://static.openfoodfacts.org/images/attributes/ecoscore-$ecoscore.svg'
                        ],
                        scoreTitles: [
                          'Nutri-Score $nutriscore',
                          'NOVA Group $novaGroup',
                          'Eco-Score $ecoscore'
                        ],
                        calorias: calorias,
                        grasas: grasas,
                        proteinas: proteinas,
                        unidadesCantidad: unidadesCantidad,
                        carbohidratos: carbohidratos,
                        sodio: sodio,
                        azucar: azucar,
                        fibra: fibra,
                        anadirRegistro: false,
                        day: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                      );
                    });
              } else {
                return GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: _listaDeAlimentos == null
                        ? 0
                        : _listaDeAlimentos.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemBuilder: (context, i) {
                      var nombreUsuario = widget.nombreUsuario;
                      var codigoDeBarras = _listaDeAlimentos[i]['_id'];
                      var cantidad = 100.0;
                      var nombreAlimento =
                          _listaDeAlimentos[i]['product_name'] ?? "";
                      var imageUrl = _listaDeAlimentos[i]['image_url'] ?? "";
                      var nutriscore =
                          _listaDeAlimentos[i]['nutriscore_grade'] ?? "";
                      var novaGroup = _listaDeAlimentos[i]['nova_group'] ?? "";
                      var ecoscore =
                          _listaDeAlimentos[i]['ecoscore_grade'] ?? "";

                      var unidadesCantidad = "gramos";
                      var calorias = (_listaDeAlimentos[i]['nutriments']
                              ?['energy-kcal_100g'] is String)
                          ? double.parse(_listaDeAlimentos[i]['nutriments']
                              ['energy-kcal_100g'])
                          : _listaDeAlimentos[i]['nutriments']
                                      ['energy-kcal_100g']
                                  ?.toDouble() ??
                              0.0;
                      var grasas = (_listaDeAlimentos[i]['nutriments']
                              ?['fat_100g'] is String)
                          ? double.parse(
                              _listaDeAlimentos[i]['nutriments']['fat_100g'])
                          : _listaDeAlimentos[i]['nutriments']['fat_100g']
                                  ?.toDouble() ??
                              0.0;
                      var proteinas = (_listaDeAlimentos[i]['nutriments']
                              ?['proteins_100g'] is String)
                          ? double.parse(_listaDeAlimentos[i]['nutriments']
                              ['proteins_100g'])
                          : _listaDeAlimentos[i]['nutriments']['proteins_100g']
                                  ?.toDouble() ??
                              0.0;
                      var carbohidratos = (_listaDeAlimentos[i]['nutriments']
                              ?['carbohydrates_100g'] is String)
                          ? double.parse(_listaDeAlimentos[i]['nutriments']
                              ['carbohydrates_100g'])
                          : _listaDeAlimentos[i]['nutriments']
                                      ['carbohydrates_100g']
                                  ?.toDouble() ??
                              0.0;
                      var sodio = (_listaDeAlimentos[i]['nutriments']
                              ?['sodium_100g'] is String)
                          ? double.parse(
                              _listaDeAlimentos[i]['nutriments']['sodium_100g'])
                          : _listaDeAlimentos[i]['nutriments']['sodium_100g']
                                  ?.toDouble() ??
                              0.0;
                      var azucar = (_listaDeAlimentos[i]['nutriments']
                              ?['sugars_100g'] is String)
                          ? double.parse(
                              _listaDeAlimentos[i]['nutriments']['sugars_100g'])
                          : _listaDeAlimentos[i]['nutriments']['sugars_100g']
                                  ?.toDouble() ??
                              0.0;
                      var fibra = (_listaDeAlimentos[i]['nutriments']
                              ?['fiber_100g'] is String)
                          ? double.parse(
                              _listaDeAlimentos[i]['nutriments']['fiber_100g'])
                          : _listaDeAlimentos[i]['nutriments']['fiber_100g']
                                  ?.toDouble() ??
                              0.0;

                      return TarjetaBuscador(
                        tipoDeComida: widget.tipoDeComida,
                        id: 0,
                        nombreUsuario: nombreUsuario,
                        codigoDeBarras: codigoDeBarras,
                        cantidad: cantidad,
                        nombreAlimento: nombreAlimento,
                        imageUrl: imageUrl,
                        scoreImages: [
                          nutriscore == ""
                              ? ""
                              : 'https://static.openfoodfacts.org/images/attributes/nutriscore-$nutriscore.svg',
                          novaGroup == ""
                              ? ""
                              : 'https://static.openfoodfacts.org/images/attributes/nova-group-$novaGroup.svg',
                          ecoscore == ""
                              ? ""
                              : 'https://static.openfoodfacts.org/images/attributes/ecoscore-$ecoscore.svg'
                        ],
                        scoreTitles: [
                          'Nutri-Score $nutriscore',
                          'NOVA Group $novaGroup',
                          'Eco-Score $ecoscore'
                        ],
                        calorias: calorias,
                        grasas: grasas,
                        proteinas: proteinas,
                        unidadesCantidad: unidadesCantidad,
                        carbohidratos: carbohidratos,
                        sodio: sodio,
                        azucar: azucar,
                        fibra: fibra,
                        anadirRegistro: false,
                        day: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                      );
                    });
              }
            }))
          ],
        ));
  }

  String _barcode = '';

  Future<void> _scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
          '#FF0000', 'Cancel', true, ScanMode.BARCODE);

      if (barcode != '-1') {
        setState(() {
          _barcode = barcode;
          print(_barcode);
        });
        await _fetchFood(_barcode);
      }
    } catch (e) {
      print('Error al escanear el código de barras: $e');
    }
  }

  Future<http.Response> searchFoodNuevaAPI(String searchTerm) async {
    var url =
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$searchTerm&search_simple=1&action=process&json=true';
    return await http.get(Uri.parse(url));
  }

  Future<void> searchAndDisplayFoodNuevaAPI(String searchTerm) async {
    var response = await searchFoodNuevaAPI(searchTerm);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var listaDeAlimentos =
          body['products'].toList(); //.cast<Map<String, dynamic>>();
      setState(() {
        _listaDeAlimentos = listaDeAlimentos;
      });
    } else {
      print('Error al realizar la búsqueda');
    }
  }

  Future<http.Response> searchFoodNuevaAPIBarCode(String barcode) async {
    var url1 = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';
    return await http.get(Uri.parse(url1));
  }

  Future<void> _fetchFood(barcode) async {
    var response = await searchFoodNuevaAPIBarCode(barcode);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var alimentoCodBar = body['product'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MostrarFood(
                    id: 0,
                    codigoDeBarras: alimentoCodBar['_id'],
                    nombreUsuario: widget.nombreUsuario,
                    name: alimentoCodBar['product_name'] ?? "",
                    cantidad: 100.0,
                    unidadesCantidad: "grams",
                    calorias: (alimentoCodBar['nutriments']?['energy-kcal_100g']
                            is String)
                        ? double.parse(
                            alimentoCodBar['nutriments']['energy-kcal_100g'])
                        : alimentoCodBar['nutriments']['energy-kcal_100g']
                                ?.toDouble() ??
                            0.0,
                    grasas: (alimentoCodBar['nutriments']?['fat_100g']
                            is String)
                        ? double.parse(alimentoCodBar['nutriments']['fat_100g'])
                        : alimentoCodBar['nutriments']['fat_100g']
                                ?.toDouble() ??
                            0.0,
                    proteinas: (alimentoCodBar['nutriments']?['proteins_100g']
                            is String)
                        ? double.parse(
                            alimentoCodBar['nutriments']['proteins_100g'])
                        : alimentoCodBar['nutriments']['proteins_100g']
                                ?.toDouble() ??
                            0.0,
                    carbohidratos: (alimentoCodBar['nutriments']
                            ?['carbohydrates_100g'] is String)
                        ? double.parse(
                            alimentoCodBar['nutriments']['carbohydrates_100g'])
                        : alimentoCodBar['nutriments']['carbohydrates_100g']
                                ?.toDouble() ??
                            0.0,
                    sodio:
                        (alimentoCodBar['nutriments']?['sodium_100g'] is String)
                            ? double.parse(
                                alimentoCodBar['nutriments']['sodium_100g'])
                            : alimentoCodBar['nutriments']['sodium_100g']
                                    ?.toDouble() ??
                                0.0,
                    azucar:
                        (alimentoCodBar['nutriments']?['sugars_100g'] is String)
                            ? double.parse(
                                alimentoCodBar['nutriments']['sugars_100g'])
                            : alimentoCodBar['nutriments']['sugars_100g']
                                    ?.toDouble() ??
                                0.0,
                    fibra:
                        (alimentoCodBar['nutriments']?['fiber_100g'] is String)
                            ? double.parse(
                                alimentoCodBar['nutriments']['fiber_100g'])
                            : alimentoCodBar['nutriments']['fiber_100g']
                                    ?.toDouble() ??
                                0.0,
                    image: alimentoCodBar['image_url'] ?? "",
                    showBotonAlimentos: true,
                    showBotonRegistro: true,
                    showBotonGuardar: false,
                  )));
      setState(() {
        _listaDeAlimentos = alimentoCodBar;
      });
    } else {
      print('Error al realizar la búsqueda');
    }
  }

  Future<http.Response> insertarAlimento(
      String codigoDeBarras,
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
      String image) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    final response = await ioClient.post(
      Uri.parse('${urlConexion}/foods/add'),
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
        'nombreUsuario': widget.nombreUsuario,
        'codigoDeBarras': codigoDeBarras
      }),
    );
    Navigator.pop(context);
    _navigateListAlimento(context);
    return response;
  }
}
