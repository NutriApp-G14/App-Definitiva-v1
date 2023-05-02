import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/model/Alimento.dart';
import 'package:my_app/views/listviewFood.dart';
import 'package:my_app/views/mostrarFood.dart';
import 'package:my_app/views/AddRecetasPage.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BuscadorIngredientes extends StatefulWidget {
  final String nombreUsuario;
  final List<Alimento> ingredientes;
  final Function(List<Alimento>) onIngredientesUpdated;

  const BuscadorIngredientes(
      {required this.nombreUsuario,
      required this.ingredientes,
      required this.onIngredientesUpdated});

  @override
  _BuscadorIngredientesState createState() => _BuscadorIngredientesState();
}

class _BuscadorIngredientesState extends State<BuscadorIngredientes> {
  String _query = '';
  List<String> _foodList = [];
  List<Map<String, dynamic>> _foods = [];
  var _listaDeAlimentos = [];

  void _onSubmitSearch() async {
    if (_query.isNotEmpty) {
      //await searchAndDisplayFood(_query);
      await searchAndDisplayFoodNuevaAPI(_query);
    }
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

  Future<http.Response> searchFoodNuevaAPIBarCode(String barcode) async {
    var url1 = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';
    return await http.get(Uri.parse(url1));
  }

  Future<void> _fetchFood(barcode) async {
    var response = await searchFoodNuevaAPIBarCode(barcode);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var alimentoCodBar = body['product'];
      widget.ingredientes.add(Alimento(
        name: alimentoCodBar['product_name'] ?? "",
        cantidad: 100.0,
        unidadesCantidad: "grams",
        calorias: (alimentoCodBar['nutriments']?['energy-kcal_100g'] is String)
            ? double.parse(alimentoCodBar['nutriments']['energy-kcal_100g'])
            : alimentoCodBar['nutriments']['energy-kcal_100g']?.toDouble() ??
                0.0,
        grasas: (alimentoCodBar['nutriments']?['fat_100g'] is String)
            ? double.parse(alimentoCodBar['nutriments']['fat_100g'])
            : alimentoCodBar['nutriments']['fat_100g']?.toDouble() ?? 0.0,
        proteinas: (alimentoCodBar['nutriments']?['proteins_100g'] is String)
            ? double.parse(alimentoCodBar['nutriments']['proteins_100g'])
            : alimentoCodBar['nutriments']['proteins_100g']?.toDouble() ?? 0.0,
        carbohidratos: (alimentoCodBar['nutriments']?['carbohydrates_100g']
                is String)
            ? double.parse(alimentoCodBar['nutriments']['carbohydrates_100g'])
            : alimentoCodBar['nutriments']['carbohydrates_100g']?.toDouble() ??
                0.0,
        sodio: (alimentoCodBar['nutriments']?['sodium_100g'] is String)
            ? double.parse(alimentoCodBar['nutriments']['sodium_100g'])
            : alimentoCodBar['nutriments']['sodium_100g']?.toDouble() ?? 0.0,
        azucar: (alimentoCodBar['nutriments']?['sugars_100g'] is String)
            ? double.parse(alimentoCodBar['nutriments']['sugars_100g'])
            : alimentoCodBar['nutriments']['sugars_100g']?.toDouble() ?? 0.0,
        fibra: (alimentoCodBar['nutriments']?['fiber_100g'] is String)
            ? double.parse(alimentoCodBar['nutriments']['fiber_100g'])
            : alimentoCodBar['nutriments']['fiber_100g']?.toDouble() ?? 0.0,
        image: alimentoCodBar['image_url'] ?? "",
      ));
      Navigator.of(context)
          .pop(widget.onIngredientesUpdated(widget.ingredientes));
      setState(() {
        _listaDeAlimentos = alimentoCodBar;
      });
    } else {
      print('Error al realizar la búsqueda');
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
      body: Column(
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
              hintText: 'Introduce el ingrediente',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              suffixIcon: IconButton(
                icon: Icon(Icons.qr_code_scanner),
                onPressed: _scanBarcode,
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _onSubmitSearch,
            child: Text('Buscar'),
          ),
          Expanded(
              child: GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount:
                      _listaDeAlimentos == null ? 0 : _listaDeAlimentos.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        widget.ingredientes.add(Alimento(
                            name:
                                _listaDeAlimentos[index]['product_name'] ?? "",
                            calorias: (_listaDeAlimentos[index]['nutriments']
                                    ?['energy-kcal_100g'] is String)
                                ? double.parse(_listaDeAlimentos[index]
                                    ['nutriments']['energy-kcal_100g'])
                                : _listaDeAlimentos[index]['nutriments']
                                            ['energy-kcal_100g']
                                        ?.toDouble() ??
                                    0.0,
                            cantidad: 100.0,
                            unidadesCantidad: "grams",
                            grasas: (_listaDeAlimentos[index]['nutriments']
                                    ?['fat_100g'] is String)
                                ? double.parse(_listaDeAlimentos[index]['nutriments']['fat_100g'])
                                : _listaDeAlimentos[index]['nutriments']['fat_100g']?.toDouble() ?? 0.0,
                            proteinas: (_listaDeAlimentos[index]['nutriments']?['proteins_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['proteins_100g']) : _listaDeAlimentos[index]['nutriments']['proteins_100g']?.toDouble() ?? 0.0,
                            carbohidratos: (_listaDeAlimentos[index]['nutriments']?['carbohydrates_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['carbohydrates_100g']) : _listaDeAlimentos[index]['nutriments']['carbohydrates_100g']?.toDouble() ?? 0.0,
                            sodio: (_listaDeAlimentos[index]['nutriments']?['sodium_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['sodium_100g']) : _listaDeAlimentos[index]['nutriments']['sodium_100g']?.toDouble() ?? 0.0,
                            azucar: (_listaDeAlimentos[index]['nutriments']?['sugars_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['sugars_100g']) : _listaDeAlimentos[index]['nutriments']['sugars_100g']?.toDouble() ?? 0.0,
                            fibra: (_listaDeAlimentos[index]['nutriments']?['fiber_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['fiber_100g']) : _listaDeAlimentos[index]['nutriments']['fiber_100g']?.toDouble() ?? 0.0,
                            image: _listaDeAlimentos[index]['image_url'] ?? ""));
                        Navigator.of(context).pop(
                            widget.onIngredientesUpdated(widget.ingredientes));
                      },
                      child: Card(
                        margin: EdgeInsets.only(
                            bottom: 0), // establece el margen inferior en 0
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              (_listaDeAlimentos[index]['image_url'] != null) &&
                                      (_listaDeAlimentos[index]['image_url'] !=
                                          "")
                                  ? FutureBuilder(
                                      future: http.head(Uri.parse(
                                          _listaDeAlimentos[index]
                                              ['image_url'])),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<http.Response>
                                              snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data!.statusCode == 200) {
                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  'assets/placeholder_image.png',
                                              image: _listaDeAlimentos[index]
                                                  ['image_url'],
                                              fit: BoxFit.fitWidth,
                                              width: 150,
                                              height: 150,
                                            ),
                                          );
                                        } else {
                                          return Container(
                                              child: Image.asset(
                                            'assets/placeholder_image.png',
                                            fit: BoxFit.fitWidth,
                                            height: 150,
                                            width: 150,
                                          ));
                                        }
                                      },
                                    )
                                  : Container(
                                      child: Image.asset(
                                      'assets/placeholder_image.png',
                                      fit: BoxFit.fitWidth,
                                      height: 150,
                                      width: 150,
                                    )),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                _listaDeAlimentos[index]['product_name'] ?? "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ]),
                      ),
                    );
                  }))
        ],
      ),
    );
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

  Future<http.Response> insertarAlimento(
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
        'nombreUsuario': widget.nombreUsuario
      }),
    );
    Navigator.pop(context);
    _navigateListAlimento(context);
    return response;
  }
}
