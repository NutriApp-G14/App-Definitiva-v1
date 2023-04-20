import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:my_app/model/NavBar.dart';
import 'package:my_app/model/TarjetaAlimento.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaginaTipoComida extends StatefulWidget {
  final String nombreUsuario;
  final String tipoDeComida;
  final String fecha;

  const PaginaTipoComida(
      {required this.nombreUsuario, required this.tipoDeComida,required this.fecha});

  @override
  _PaginaTipoComidaState createState() => _PaginaTipoComidaState();
}

class _PaginaTipoComidaState extends State<PaginaTipoComida> {
    late var _alimento;
    var list = {{1}};


  //   Future<http.Response> searchFoodNuevaAPI(int codigoDeBarras) async {
  //   var url =
  //       'https://world.openfoodfacts.org/cgi/search.pl?code=${widget.codigoDeBarras}&search_simple=1&action=process&json=true';
  //   return await http.get(Uri.parse(url));
  // }

  // Future<void> searchAndDisplayFoodNuevaAPI() async {
  //   var response = await searchFoodNuevaAPI(codigoDeBarras);
  //   if (response.statusCode == 200) {
  //     var body = json.decode(response.body);
  //     var alimentos = body['products'].toList();
  //     var alimento = alimentos[0];
  //     print(alimento['_id']);
  //     setState(() {
  //       _alimento = alimento;
  //     });
  //   } else {
  //     print('Error al realizar la búsqueda');
  //   }
  // }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(52),
            child: NutriAppBar(nombreUsuario: widget.nombreUsuario),
          ),
        ),
        body: Column(
          children: [
              Text("${widget.tipoDeComida}"),
              Text("${widget.fecha}"),
              Text("${widget.nombreUsuario}"), 
              LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                    if (constraints.maxWidth < 600) {
                      return SizedBox(
                        height: 250,
                        child:
                        GridView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: _alimento == null ? 0 : list.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemBuilder: (context, i) {
                          return TarjetaAlimento(nombreUsuario: widget.nombreUsuario ,codigoDeBarras: 3017620422003, cantidad: 100.0,
                              nombreAlimento:'Confitura de fresa 0% azúcares añadidos - Hacendado - 380 g' , imageUrl: 'https://images.openfoodfacts.org/images/products/848/000/015/0936/front_es.42.200.jpg',
                              scoreImages: ['https://static.openfoodfacts.org/images/attributes/nutriscore-b.svg', 'https://static.openfoodfacts.org/images/attributes/nova-group-4.svg', 'https://static.openfoodfacts.org/images/attributes/ecoscore-b.svg'],
                              scoreTitles: ['Nutri-Score B - Good nutritional quality', 'NOVA 4 - Ultra processed foods', 'Eco-Score B - Low environmental impact'],
                              );
                        }
                        )
                      );
                    } else if (constraints.maxWidth < 1100) {
                          return SizedBox(
                        height: 250,
                        child:
                             GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            itemCount: list == null ? 0 : list.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemBuilder: (context, i) {
                              return TarjetaAlimento(nombreUsuario: widget.nombreUsuario ,codigoDeBarras: 3017620422003, cantidad: 100.0,
                              nombreAlimento:'Confitura de fresa 0% azúcares añadidos - Hacendado - 380 g' , imageUrl: 'https://images.openfoodfacts.org/images/products/848/000/015/0936/front_es.42.200.jpg',
                              scoreImages: ['https://static.openfoodfacts.org/images/attributes/nutriscore-b.svg', 'https://static.openfoodfacts.org/images/attributes/nova-group-4.svg', 'https://static.openfoodfacts.org/images/attributes/ecoscore-b.svg'],
                              scoreTitles: ['Nutri-Score B - Good nutritional quality', 'NOVA 4 - Ultra processed foods', 'Eco-Score B - Low environmental impact'],
                              );
                            }
                          )
                          );
                    } else {
                          return SizedBox(
                        height: 250,
                        child: GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            itemCount: list == null ? 0 : list.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemBuilder: (context, i) {
                              return TarjetaAlimento(nombreUsuario: widget.nombreUsuario ,codigoDeBarras: 3017620422003, cantidad: 100.0,
                              nombreAlimento:'Confitura de fresa 0% azúcares añadidos - Hacendado - 380 g' , imageUrl: 'https://images.openfoodfacts.org/images/products/848/000/015/0936/front_es.42.200.jpg',
                              scoreImages: ['https://static.openfoodfacts.org/images/attributes/nutriscore-b.svg', 'https://static.openfoodfacts.org/images/attributes/nova-group-4.svg', 'https://static.openfoodfacts.org/images/attributes/ecoscore-b.svg'],
                              scoreTitles: ['Nutri-Score B - Good nutritional quality', 'NOVA 4 - Ultra processed foods', 'Eco-Score B - Low environmental impact'],
                              );
                            }
                          )
                          );
                    }
                }
              ),
          ],
        )
      );
  }
}