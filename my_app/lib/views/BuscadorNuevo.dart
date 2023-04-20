import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/model/TarjetaAlimento.dart';
import 'package:my_app/views/listviewfood.dart';
import 'package:my_app/views/mostrarFood.dart';

class BuscadorNuevo extends StatefulWidget {
  final String nombreUsuario;

  const BuscadorNuevo({required this.nombreUsuario});

  @override
  _BuscadorNuevoState createState() => _BuscadorNuevoState();
}

class _BuscadorNuevoState extends State<BuscadorNuevo> {
  String _query = '';
  var _listaDeAlimentos = [];

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
          icon: Icon(Icons
              .arrow_back_ios_new_sharp
              ), 
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Expanded(flex: 2, 
          child: Column(
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
         ] 
         ), 
          ), 
          Expanded(
            flex:9,
            child: Column(
          children: [
                 LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                    if (constraints.maxWidth < 600) {
                      return SizedBox(
                        height: 100,
                        child:
                        GridView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: _listaDeAlimentos == null ? 0 : _listaDeAlimentos.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemBuilder: (context, i) {
                          var nombreUsuario = widget.nombreUsuario;
                          var codigoDeBarras = _listaDeAlimentos[i]['_id'];
                          var cantidad = 100.0;
                          var nombreAlimento = _listaDeAlimentos[i]['product_name'] ?? "";
                          var imageUrl =  _listaDeAlimentos[i]['image_url'] ??"";
                          var nutriscore = _listaDeAlimentos[i]['nutriscore_grade'] ?? "";
                          var nova_group = _listaDeAlimentos[i]['"nova-group"'] ?? "";
                          var ecoscore = _listaDeAlimentos[i]['ecoscore_grade'] ?? "";

                          return TarjetaAlimento(nombreUsuario: nombreUsuario ,codigoDeBarras: _listaDeAlimentos[i]['_id'], cantidad: 100.0,
                              nombreAlimento:_listaDeAlimentos[i]['product_name'] , imageUrl: 'https://images.openfoodfacts.org/images/products/848/000/015/0936/front_es.42.200.jpg',
                              scoreImages: ['https://static.openfoodfacts.org/images/attributes/nutriscore-${nutriscore}.svg', 'https://static.openfoodfacts.org/images/attributes/nova-group-${nova_group}.svg', 'https://static.openfoodfacts.org/images/attributes/ecoscore-${ecoscore}.svg'],
                              scoreTitles: ['Nutri-Score ${nutriscore}' , 'NOVA Group ${nova_group}', 'Eco-Score ${ecoscore}'],
                              );
                        }
                        )
                      );
                    } else if (constraints.maxWidth < 1100) {
                          return 
                        //   SizedBox(
                        // height: 200,
                        // child:
                        Column(children: [GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            itemCount: _listaDeAlimentos == null ? 0 : _listaDeAlimentos.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemBuilder: (context, i) {

                            var nombreUsuario = widget.nombreUsuario;
                            var codigoDeBarras = int.parse(_listaDeAlimentos[i]['_id'])?? 0;
                            var cantidad = 100.0;
                            var nombreAlimento = _listaDeAlimentos[i]['product_name'] ?? "";
                            var imageUrl =  _listaDeAlimentos[i]['image_url'] ??"";
                            var nutriscore = _listaDeAlimentos[i]['nutriscore_grade'] ?? "" ;
                            var novaGroup = _listaDeAlimentos[i]['nova_group'] ?? "" ;
                            var ecoscore = _listaDeAlimentos[i]['ecoscore_grade'] ?? "";

                             return TarjetaAlimento(nombreUsuario: nombreUsuario ,codigoDeBarras: codigoDeBarras, cantidad:cantidad,
                              nombreAlimento:nombreAlimento, imageUrl:imageUrl ,
                              scoreImages: ['https://static.openfoodfacts.org/images/attributes/nutriscore-$nutriscore.svg', 'https://static.openfoodfacts.org/images/attributes/nova-group-$novaGroup.svg', 'https://static.openfoodfacts.org/images/attributes/ecoscore-$ecoscore.svg'],
                              scoreTitles: ['Nutri-Score $nutriscore' , 'NOVA Group $novaGroup', 'Eco-Score $ecoscore'],
                              );
                            }
                         // )
                          )],
                          );
                             
                    } else {
                          return SizedBox(
                        height: 100,
                        child: GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            itemCount: _listaDeAlimentos == null ? 0 : _listaDeAlimentos.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemBuilder: (context, i) {

                              var nombreUsuario = widget.nombreUsuario;
                              var codigoDeBarras = _listaDeAlimentos[i]['_id'];
                              var cantidad = 100.0;
                              var nombreAlimento = _listaDeAlimentos[i]['product_name'] ?? "";
                              var imageUrl =  _listaDeAlimentos[i]['image_url'] ??"";
                              var nutriscore = _listaDeAlimentos[i]['nutriscore_grade'] ?? "";
                              var nova_group = _listaDeAlimentos[i]['"nova-group"'] ?? "";
                              var ecoscore = _listaDeAlimentos[i]['ecoscore_grade'] ?? "";

                             return TarjetaAlimento(nombreUsuario: nombreUsuario ,codigoDeBarras: _listaDeAlimentos[i]['_id'], cantidad: 100.0,
                              nombreAlimento:_listaDeAlimentos[i]['product_name'] , imageUrl: 'https://images.openfoodfacts.org/images/products/848/000/015/0936/front_es.42.200.jpg',
                              scoreImages: ['https://static.openfoodfacts.org/images/attributes/nutriscore-${nutriscore}.svg', 'https://static.openfoodfacts.org/images/attributes/nova-group-${nova_group}.svg', 'https://static.openfoodfacts.org/images/attributes/ecoscore-${ecoscore}.svg'],
                              scoreTitles: ['Nutri-Score ${nutriscore}' , 'NOVA Group ${nova_group}', 'Eco-Score ${ecoscore}'],
                              );
                            }
                          )
                          );
                    }
                }
              ),
          ],
        )
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
