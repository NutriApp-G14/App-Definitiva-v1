import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/views/listviewfood.dart';
import 'package:my_app/views/mostrarFood.dart';

class NuevoBuscador extends StatefulWidget {
  final String nombreUsuario;

  const NuevoBuscador({required this.nombreUsuario});

  @override
  _NuevoBuscadorState createState() => _NuevoBuscadorState();
}

class _NuevoBuscadorState extends State<NuevoBuscador> {
  String _query = '';
  List<String> _foodList = [];
  List<Map<String, dynamic>> _foods = [];
  var  _listaDeAlimentos = [];

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
      appBar: AppBar(
        title: Text(
          'Buscador de comidas',
          style: TextStyle(
            color: Colors.black,
          ),
          // automaticallyImplyLeading: false,
        ),
        leading: IconButton(
          icon: Icon(Icons
              .arrow_back_ios_new_sharp), // Agrega aquí la imagen personalizada de flecha
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.black,
        ),
      ),
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
              hintText: 'Introduce el nombre de la comida',
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
                          leading: (_listaDeAlimentos[index]['image_url'] != null) &&
                                  (_listaDeAlimentos[index]['image_url'] != "")
                              ? FutureBuilder(
                                  future: http
                                      .head(Uri.parse(_listaDeAlimentos[index]['image_url'])),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<http.Response> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.statusCode == 200) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              'assets/placeholder_image.png',
                                          image: _listaDeAlimentos[index]['image_url'],
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
                            _listaDeAlimentos[index]['product_name'] ?? "" ,
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
                              insertarAlimento(
                                          _listaDeAlimentos[index]['product_name'] ?? "",
                                          (_listaDeAlimentos[index]['nutriments']?['energy-kcal_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['energy-kcal_100g']) : _listaDeAlimentos[index]['nutriments']['energy-kcal_100g']?.toDouble() ?? 0.0,
                                          100.0,
                                          "grams",
                                          (_listaDeAlimentos[index]['nutriments']?['fat_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['fat_100g']) : _listaDeAlimentos[index]['nutriments']['fat_100g']?.toDouble() ?? 0.0,
                                          (_listaDeAlimentos[index]['nutriments']?['proteins_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['proteins_100g']) : _listaDeAlimentos[index]['nutriments']['proteins_100g']?.toDouble() ?? 0.0,
                                          (_listaDeAlimentos[index]['nutriments']?['carbohydrates_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['carbohydrates_100g']) : _listaDeAlimentos[index]['nutriments']['carbohydrates_100g']?.toDouble() ?? 0.0,
                                          (_listaDeAlimentos[index]['nutriments']?['sodium_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['sodium_100g']) : _listaDeAlimentos[index]['nutriments']['sodium_100g']?.toDouble() ?? 0.0,
                                          (_listaDeAlimentos[index]['nutriments']?['sugars_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['sugars_100g']) : _listaDeAlimentos[index]['nutriments']['sugars_100g']?.toDouble() ?? 0.0,
                                          (_listaDeAlimentos[index]['nutriments']?['fiber_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['fiber_100g']) : _listaDeAlimentos[index]['nutriments']['fiber_100g']?.toDouble() ?? 0.0,
                                          _listaDeAlimentos[index]['image_url'] ?? "",
                              );
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
                            print(_listaDeAlimentos[index]['nutriments']['energy-kcal_100g']);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MostrarFood(
                                          name: _listaDeAlimentos[index]['product_name'] ?? "",
                                          cantidad:  100.0,
                                          unidadesCantidad: "grams",
                                          calorias:(_listaDeAlimentos[index]['nutriments']?['energy-kcal_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['energy-kcal_100g']) : _listaDeAlimentos[index]['nutriments']['energy-kcal_100g']?.toDouble() ?? 0.0,
                                          grasas: (_listaDeAlimentos[index]['nutriments']?['fat_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['fat_100g']) : _listaDeAlimentos[index]['nutriments']['fat_100g']?.toDouble() ?? 0.0,
                                          proteinas: (_listaDeAlimentos[index]['nutriments']?['proteins_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['proteins_100g']) : _listaDeAlimentos[index]['nutriments']['proteins_100g']?.toDouble() ?? 0.0,
                                          carbohidratos: (_listaDeAlimentos[index]['nutriments']?['carbohydrates_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['carbohydrates_100g']) : _listaDeAlimentos[index]['nutriments']['carbohydrates_100g']?.toDouble() ?? 0.0,
                                          sodio: (_listaDeAlimentos[index]['nutriments']?['sodium_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['sodium_100g']) : _listaDeAlimentos[index]['nutriments']['sodium_100g']?.toDouble() ?? 0.0,
                                          azucar: (_listaDeAlimentos[index]['nutriments']?['sugars_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['sugars_100g']) : _listaDeAlimentos[index]['nutriments']['sugars_100g']?.toDouble() ?? 0.0,
                                          fibra:(_listaDeAlimentos[index]['nutriments']?['fiber_100g'] is String) ? double.parse(_listaDeAlimentos[index]['nutriments']['fiber_100g']) : _listaDeAlimentos[index]['nutriments']['fiber_100g']?.toDouble() ?? 0.0,
                                          image: _listaDeAlimentos[index]['image_url'] ?? "",
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

  Future<http.Response> searchFood(String searchTerm) async {
    var url =
        'https://api.edamam.com/api/food-database/v2/parser?app_id=2c2e2462&app_key=7b3486401bec7d7ccd46c6bc6e85b3cc&ingr=$searchTerm';
    return await http.get(Uri.parse(url));
  }

  Future<void> searchAndDisplayFood(String searchTerm) async {
    var response = await searchFood(searchTerm);

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var foodList =
          body['hints'].map((food) => food['food']['label']).toList();
      var foods = body['hints']
          .map((food) => food['food'])
          .toList()
          .cast<Map<String, dynamic>>();

      setState(() {
        _foodList = foodList.cast<String>(); // Convert foodList to List<String>
        _foods = foods;
      });
    } else {
      print('Error al realizar la búsqueda');
    }
  }
  Future<http.Response> searchFoodNuevaAPI(String searchTerm) async {
    var url = 'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$searchTerm&search_simple=1&action=process&json=true';
    return await http.get(Uri.parse(url));
  }

  Future<void> searchAndDisplayFoodNuevaAPI(String searchTerm) async {
    var response = await searchFoodNuevaAPI(searchTerm);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var listaDeAlimentos = body['products'].toList();//.cast<Map<String, dynamic>>();
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
      Uri.parse('http://localhost:8080/foods/add'),
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
