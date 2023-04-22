import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/model/Alimento.dart';
import 'package:my_app/views/listviewFood.dart';
import 'package:my_app/views/mostrarFood.dart';
import 'package:my_app/views/AddRecetasPage.dart';

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
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _onSubmitSearch,
            child: Text('Buscar'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listaDeAlimentos.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin:
                      EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Card(
                        margin: EdgeInsets.only(
                            bottom: 0), // establece el margen inferior en 0
                        color: Colors.orange[200],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: (_listaDeAlimentos[index]['image_url'] !=
                                      null) &&
                                  (_listaDeAlimentos[index]['image_url'] != "")
                              ? FutureBuilder(
                                  future: http.head(Uri.parse(
                                      _listaDeAlimentos[index]['image_url'])),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<http.Response> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.statusCode == 200) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              'assets/placeholder_image.png',
                                          image: _listaDeAlimentos[index]
                                              ['image_url'],
                                          fit: BoxFit.cover,
                                          width: 80,
                                          height: 80,
                                        ),
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  },
                                )
                              : SizedBox.shrink(),
                          title: Text(
                            _listaDeAlimentos[index]['product_name'] ?? "",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              widget.ingredientes.add(Alimento(
                                  name: _listaDeAlimentos[index]['product_name'] ??
                                      "",
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
                                  grasas: (_listaDeAlimentos[index]['nutriments']?['fat_100g'] is String)
                                      ? double.parse(_listaDeAlimentos[index]['nutriments']['fat_100g'])
                                      : _listaDeAlimentos[index]['nutriments']['fat_100g']?.toDouble() ?? 0.0,
                                  proteinas: (_listaDeAlimentos[index]['nutriments']?['proteins_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['proteins_100g']) : _listaDeAlimentos[index]['nutriments']['proteins_100g']?.toDouble() ?? 0.0,
                                  carbohidratos: (_listaDeAlimentos[index]['nutriments']?['carbohydrates_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['carbohydrates_100g']) : _listaDeAlimentos[index]['nutriments']['carbohydrates_100g']?.toDouble() ?? 0.0,
                                  sodio:(_listaDeAlimentos[index]['nutriments']
                                        ?['sodium_100g'] is String)
                                    ? double.parse(_listaDeAlimentos[index]
                                        ['nutriments']['sodium_100g'])
                                    : _listaDeAlimentos[index]['nutriments']
                                                ['sodium_100g']
                                            ?.toDouble() ??
                                        0.0,
                                azucar:(_listaDeAlimentos[index]['nutriments']
                                        ?['sugars_100g'] is String)
                                    ? double.parse(_listaDeAlimentos[index]
                                        ['nutriments']['sugars_100g'])
                                    : _listaDeAlimentos[index]['nutriments']
                                                ['sugars_100g']
                                            ?.toDouble() ??
                                        0.0,
                               fibra: (_listaDeAlimentos[index]['nutriments']
                                        ?['fiber_100g'] is String)
                                    ? double.parse(_listaDeAlimentos[index]
                                        ['nutriments']['fiber_100g'])
                                    : _listaDeAlimentos[index]['nutriments']
                                                ['fiber_100g']
                                            ?.toDouble() ??
                                        0.0,
                                  image: _listaDeAlimentos[index]['image_url'] ?? ""));
                              Navigator.of(context).pop(widget
                                  .onIngredientesUpdated(widget.ingredientes));
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 0), // Agrega un espacio de altura cero

                      Container(
                        margin: EdgeInsets.only(
                            top: 0), // establece el margen superior en 0
                        child: ElevatedButton(
                          onPressed: () {
                            print(_listaDeAlimentos[index]);
                            print(_listaDeAlimentos[index]['nutriments']
                                ['energy-kcal_100g']);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MostrarFood(
                                      id:0,
                                        nombreUsuario: widget.nombreUsuario,
                                        codigoDeBarras: _listaDeAlimentos[index]
                                                  ['codigoDeBarras'] ?? "",
                                          name: _listaDeAlimentos[index]
                                                  ['product_name'] ??
                                              "",
                                          cantidad: 100.0,
                                          unidadesCantidad: "grams",
                                          calorias: (_listaDeAlimentos[index]
                                                          ['nutriments']
                                                      ?['energy-kcal_100g']
                                                  is String)
                                              ? double.parse(
                                                  _listaDeAlimentos[index]
                                                          ['nutriments']
                                                      ['energy-kcal_100g'])
                                              : _listaDeAlimentos[index]
                                                              ['nutriments']
                                                          ['energy-kcal_100g']
                                                      ?.toDouble() ??
                                                  0.0,
                                          grasas: (_listaDeAlimentos[index]
                                                      ['nutriments']
                                                  ?['fat_100g'] is String)
                                              ? double.parse(
                                                  _listaDeAlimentos[index]
                                                          ['nutriments']
                                                      ['fat_100g'])
                                              : _listaDeAlimentos[index]
                                                              ['nutriments']
                                                          ['fat_100g']
                                                      ?.toDouble() ??
                                                  0.0,
                                          proteinas: (_listaDeAlimentos[index]
                                                      ['nutriments']
                                                  ?['proteins_100g'] is String)
                                              ? double.parse(
                                                  _listaDeAlimentos[index]
                                                          ['nutriments']
                                                      ['proteins_100g'])
                                              : _listaDeAlimentos[index]
                                                              ['nutriments']
                                                          ['proteins_100g']
                                                      ?.toDouble() ??
                                                  0.0,
                                          carbohidratos: (_listaDeAlimentos[
                                                          index]['nutriments']
                                                      ?['carbohydrates_100g']
                                                  is String)
                                              ? double.parse(
                                                  _listaDeAlimentos[index]
                                                          ['nutriments']
                                                      ['carbohydrates_100g'])
                                              : _listaDeAlimentos[index]
                                                              ['nutriments']
                                                          ['carbohydrates_100g']
                                                      ?.toDouble() ??
                                                  0.0,
                                          sodio: (_listaDeAlimentos[index]
                                                      ['nutriments']
                                                  ?['sodium_100g'] is String)
                                              ? double.parse(
                                                  _listaDeAlimentos[index]
                                                          ['nutriments']
                                                      ['sodium_100g'])
                                              : _listaDeAlimentos[index]
                                                              ['nutriments']
                                                          ['sodium_100g']
                                                      ?.toDouble() ??
                                                  0.0,
                                          azucar: (_listaDeAlimentos[index]
                                                      ['nutriments']
                                                  ?['sugars_100g'] is String)
                                              ? double.parse(
                                                  _listaDeAlimentos[index]
                                                          ['nutriments']
                                                      ['sugars_100g'])
                                              : _listaDeAlimentos[index]
                                                              ['nutriments']
                                                          ['sugars_100g']
                                                      ?.toDouble() ??
                                                  0.0,
                                          fibra: (_listaDeAlimentos[index]
                                                      ['nutriments']
                                                  ?['fiber_100g'] is String)
                                              ? double.parse(
                                                  _listaDeAlimentos[index]
                                                          ['nutriments']
                                                      ['fiber_100g'])
                                              : _listaDeAlimentos[index]
                                                              ['nutriments']
                                                          ['fiber_100g']
                                                      ?.toDouble() ??
                                                  0.0,
                                          image: _listaDeAlimentos[index]
                                                  ['image_url'] ??
                                              "",
                                        )));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ver más detalles',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
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
      print(listaDeAlimentos);
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
    final response = await http.post(
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
