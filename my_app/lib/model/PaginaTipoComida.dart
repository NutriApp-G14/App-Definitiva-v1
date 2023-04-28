import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controllers/registroHelpers.dart';
import 'dart:convert';

import 'package:my_app/model/NavBar.dart';
import 'package:my_app/model/TarjetaAlimento.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/views/AddAlimentoPage.dart';
import 'package:my_app/views/BuscadorAlimentos.dart';

class PaginaTipoComida extends StatefulWidget {
  final String nombreUsuario;
  final String tipoDeComida;
  final String fecha;
  final List registros;

  const PaginaTipoComida(
      {required this.nombreUsuario,
      required this.tipoDeComida,
      required this.fecha,
      required this.registros});

  @override
  _PaginaTipoComidaState createState() => _PaginaTipoComidaState();
}

class _PaginaTipoComidaState extends State<PaginaTipoComida> {
  RegistroHelper dataBaseHelper = RegistroHelper();
  late List<dynamic> _alimento;

  // Agregar una variable para almacenar los datos obtenidos del Future
  late Future<List<dynamic>> _alimentoFuture;

  // Llamar al método una sola vez antes de construir la pantalla
  @override
  void initState() {
    super.initState();
    _alimentoFuture = searchAndDisplayFoodNuevaAPIList(widget.registros
        .map((registro) => registro['codigoDeBarras'])
        .toList());
  }

  _navigateBuscadorAlimentos(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BuscadorAlimentos(
                nombreUsuario: widget.nombreUsuario,
                fecha: widget.fecha,
                tipoDeComida: widget.tipoDeComida)));
  }

  Future<List<dynamic>> searchAndDisplayFoodNuevaAPI(
      String codigoDeBarras) async {
    var url =
        'https://world.openfoodfacts.org/cgi/search.pl?code=$codigoDeBarras&search_simple=1&action=process&json=true';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var alimento = body['products'].toList();
      return alimento;
    } else {
      print('Error al realizar la búsqueda');
      return [];
    }
  }

  // Agregar un nuevo método para llamar al método de búsqueda para varios códigos de barras
  Future<List<dynamic>> searchAndDisplayFoodNuevaAPIList(
      List codigosDeBarras) async {
    var alimentos = [];
    for (var codigoDeBarras in codigosDeBarras) {
      var alimento = await searchAndDisplayFoodNuevaAPI(codigoDeBarras);
      alimentos.add(alimento);
    }
    return alimentos;
  }

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
        body: FutureBuilder<List<dynamic>>(
            future: _alimentoFuture,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                var alimentos = snapshot.data!;

                return Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 56,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () =>
                                  _navigateBuscadorAlimentos(context),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 8.0),
                                decoration: BoxDecoration(color: Colors.orange
                                    //borderRadius: BorderRadius.circular(20.0),
                                    ),
                                child: Text(
                                  'Añadir alimento',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 8,
                        child: LayoutBuilder(builder:
                            (BuildContext context, BoxConstraints constraints) {
                          if (constraints.maxWidth < 600) {
                            return SizedBox(
                                height: 250,
                                child: GridView.builder(
                                    padding: const EdgeInsets.all(10.0),
                                    itemCount: widget.registros == null
                                        ? 0
                                        : widget.registros.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                    ),
                                    itemBuilder: (context, i) {
                                      var nombreUsuario = widget.nombreUsuario;
                                      var codigoDeBarras =
                                          alimentos[i][0]['_id'];
                                      var cantidad =
                                          widget.registros[i]['cantidad'];
                                      var nombreAlimento =
                                          alimentos[i][0]['product_name'] ?? "";
                                      var imageUrl =
                                          alimentos[i][0]['image_url'] ?? "";
                                      var nutriscore = alimentos[i][0]
                                              ['nutriscore_grade'] ??
                                          "";
                                      var novaGroup =
                                          alimentos[i][0]['nova_group'] ?? "";
                                      var ecoscore = alimentos[i][0]
                                              ['ecoscore_grade'] ??
                                          "";

                                      return TarjetaAlimento(
                                          id: widget.registros[i]['id'],
                                          nombreUsuario: nombreUsuario,
                                          codigoDeBarras: codigoDeBarras,
                                          cantidad: cantidad,
                                          nombreAlimento: nombreAlimento,
                                          imageUrl: imageUrl,
                                          scoreImages: [
                                            'https://static.openfoodfacts.org/images/attributes/nutriscore-${nutriscore}.svg',
                                            'https://static.openfoodfacts.org/images/attributes/nova-group-${novaGroup}.svg',
                                            'https://static.openfoodfacts.org/images/attributes/ecoscore-${ecoscore}.svg'
                                          ],
                                          scoreTitles: [
                                            'Nutri-Score ${nutriscore}',
                                            'NOVA Group ${novaGroup}',
                                            'Eco-Score ${ecoscore}'
                                          ],
                                          fecha: widget.fecha,
                                          registros: widget.registros,
                                          tipodeComida: widget.tipoDeComida);
                                    }));
                          } else if (constraints.maxWidth < 1100) {
                            return SizedBox(
                                height: 250,
                                child: GridView.builder(
                                    padding: const EdgeInsets.all(10.0),
                                    itemCount: widget.registros == null
                                        ? 0
                                        : widget.registros.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                    ),
                                    itemBuilder: (context, i) {
                                      var nombreUsuario = widget.nombreUsuario;
                                      var codigoDeBarras =
                                          alimentos[i][0]['_id'];
                                      var cantidad = 100.0;
                                      var nombreAlimento =
                                          alimentos[i][0]['product_name'] ?? "";
                                      var imageUrl =
                                          alimentos[i][0]['image_url'] ?? "";
                                      var nutriscore = alimentos[i][0]
                                              ['nutriscore_grade'] ??
                                          "";
                                      var novaGroup =
                                          alimentos[i][0]['nova_group'] ?? "";
                                      var ecoscore = alimentos[i][0]
                                              ['ecoscore_grade'] ??
                                          "";

                                      return TarjetaAlimento(
                                          id: widget.registros[i]['id'],
                                          nombreUsuario: nombreUsuario,
                                          codigoDeBarras: codigoDeBarras,
                                          cantidad: cantidad,
                                          nombreAlimento: nombreAlimento,
                                          imageUrl: imageUrl,
                                          scoreImages: [
                                            'https://static.openfoodfacts.org/images/attributes/nutriscore-${nutriscore}.svg',
                                            'https://static.openfoodfacts.org/images/attributes/nova-group-${novaGroup}.svg',
                                            'https://static.openfoodfacts.org/images/attributes/ecoscore-${ecoscore}.svg'
                                          ],
                                          scoreTitles: [
                                            'Nutri-Score ${nutriscore}',
                                            'NOVA Group ${novaGroup}',
                                            'Eco-Score ${ecoscore}'
                                          ],
                                          fecha: widget.fecha,
                                          registros: widget.registros,
                                          tipodeComida: widget.tipoDeComida);
                                    }));
                          } else {
                            return SizedBox(
                                height: 250,
                                child: GridView.builder(
                                    padding: const EdgeInsets.all(10.0),
                                    itemCount: widget.registros == null
                                        ? 0
                                        : widget.registros.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 6,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                    ),
                                    itemBuilder: (context, i) {
                                      var nombreUsuario = widget.nombreUsuario;
                                      var codigoDeBarras =
                                          alimentos[i][0]['_id'];
                                      var cantidad = 100.0;
                                      var nombreAlimento =
                                          alimentos[i][0]['product_name'] ?? "";
                                      var imageUrl =
                                          alimentos[i][0]['image_url'] ?? "";
                                      var nutriscore = alimentos[i][0]
                                              ['nutriscore_grade'] ??
                                          "";
                                      var novaGroup =
                                          alimentos[i][0]['nova_group'] ?? "";
                                      var ecoscore = alimentos[i][0]
                                              ['ecoscore_grade'] ??
                                          "";

                                      return TarjetaAlimento(
                                        id: widget.registros[i]['id'],
                                        nombreUsuario: nombreUsuario,
                                        codigoDeBarras: codigoDeBarras,
                                        cantidad: cantidad,
                                        nombreAlimento: nombreAlimento,
                                        imageUrl: imageUrl,
                                        scoreImages: [
                                          'https://static.openfoodfacts.org/images/attributes/nutriscore-${nutriscore}.svg',
                                          'https://static.openfoodfacts.org/images/attributes/nova-group-${novaGroup}.svg',
                                          'https://static.openfoodfacts.org/images/attributes/ecoscore-${ecoscore}.svg'
                                        ],
                                        scoreTitles: [
                                          'Nutri-Score ${nutriscore}',
                                          'NOVA Group ${novaGroup}',
                                          'Eco-Score ${ecoscore}'
                                        ],
                                        fecha: widget.fecha,
                                        registros: widget.registros,
                                        tipodeComida: widget.tipoDeComida,
                                      );
                                    }));
                          }
                        })),
                    Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 56,
                          child: Center(),
                        )),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
