import 'package:flutter/material.dart';
import 'package:my_app/controllers/registroHelpers.dart';
import 'dart:convert';

import 'package:my_app/model/NavBar.dart';
import 'package:my_app/model/TarjetaAlimento.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/views/AddAlimentoPage.dart';

class PaginaTipoComida extends StatefulWidget {
  final String nombreUsuario;
  final String tipoDeComida;
  final String fecha;

  const PaginaTipoComida(
      {required this.nombreUsuario,
      required this.tipoDeComida,
      required this.fecha});

  @override
  _PaginaTipoComidaState createState() => _PaginaTipoComidaState();
}



class _PaginaTipoComidaState extends State<PaginaTipoComida> {
  RegistroHelper dataBaseHelper = RegistroHelper();
  late List _registros;
  



  _navigateAddAlimento(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddAlimentoPage(nombreUsuario: widget.nombreUsuario)));
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
        body: FutureBuilder<List>(
            future: dataBaseHelper.getRegistroComidas(widget.nombreUsuario.trim().toLowerCase(), widget.tipoDeComida.trim().toLowerCase(), widget.fecha..trim().toLowerCase()),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
              }else if(snapshot.hasData){
                print("napshot.hasData is true");
                 _registros = snapshot.data!;
                 print(_registros);
              }
              return snapshot.hasData
                  ? Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 56,
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () =>
                                      _navigateAddAlimento(context),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 8.0),
                                    decoration: BoxDecoration(
                                        color: Colors.orange
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
                            child: LayoutBuilder(builder: (BuildContext context,
                                BoxConstraints constraints) {
                              if (constraints.maxWidth < 600) {
                                return SizedBox(
                                    height: 250,
                                    child: GridView.builder(
                                        padding: const EdgeInsets.all(10.0),
                                        itemCount:
                                            _registros == null ? 0 : _registros.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 10.0,
                                          mainAxisSpacing: 10.0,
                                        ),
                                        itemBuilder: (context, i) {
                                          return TarjetaAlimento(
                                            nombreUsuario: widget.nombreUsuario,
                                            codigoDeBarras:_registros[i]['codigoDeBarras'],
                                            cantidad: 100.0,
                                            nombreAlimento:
                                                _registros[i]['codigoDeBarras'],
                                            imageUrl:
                                                'https://images.openfoodfacts.org/images/products/848/000/015/0936/front_es.42.200.jpg',
                                            scoreImages: [
                                              'https://static.openfoodfacts.org/images/attributes/nutriscore-b.svg',
                                              'https://static.openfoodfacts.org/images/attributes/nova-group-4.svg',
                                              'https://static.openfoodfacts.org/images/attributes/ecoscore-b.svg'
                                            ],
                                            scoreTitles: [
                                              'Nutri-Score B - Good nutritional quality',
                                              'NOVA 4 - Ultra processed foods',
                                              'Eco-Score B - Low environmental impact'
                                            ],
                                          );
                                        }));
                              } else if (constraints.maxWidth < 1100) {
                                return SizedBox(
                                    height: 250,
                                    child: GridView.builder(
                                        padding: const EdgeInsets.all(10.0),
                                        itemCount:
                                            _registros == null ? 0 : _registros.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 10.0,
                                          mainAxisSpacing: 10.0,
                                        ),
                                        itemBuilder: (context, i) {
                                          return TarjetaAlimento(
                                            nombreUsuario: widget.nombreUsuario,
                                            codigoDeBarras:_registros[i]['codigoDeBarras'],
                                            cantidad: 100.0,
                                            nombreAlimento:
                                                'Confitura de fresa 0% azúcares añadidos - Hacendado - 380 g',
                                            imageUrl:
                                                'https://images.openfoodfacts.org/images/products/848/000/015/0936/front_es.42.200.jpg',
                                            scoreImages: [
                                              'https://static.openfoodfacts.org/images/attributes/nutriscore-b.svg',
                                              'https://static.openfoodfacts.org/images/attributes/nova-group-4.svg',
                                              'https://static.openfoodfacts.org/images/attributes/ecoscore-b.svg'
                                            ],
                                            scoreTitles: [
                                              'Nutri-Score B - Good nutritional quality',
                                              'NOVA 4 - Ultra processed foods',
                                              'Eco-Score B - Low environmental impact'
                                            ],
                                          );
                                        }));
                              } else {
                                return SizedBox(
                                    height: 250,
                                    child: GridView.builder(
                                        padding: const EdgeInsets.all(10.0),
                                        itemCount:
                                            _registros == null ? 0 : _registros.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 6,
                                          crossAxisSpacing: 10.0,
                                          mainAxisSpacing: 10.0,
                                        ),
                                        itemBuilder: (context, i) {
                                          return TarjetaAlimento(
                                            nombreUsuario: widget.nombreUsuario,
                                            codigoDeBarras:_registros[i]['codigoDeBarras'],
                                            cantidad: 100.0,
                                            nombreAlimento:
                                                'Confitura de fresa 0% azúcares añadidos - Hacendado - 380 g',
                                            imageUrl:
                                                'https://images.openfoodfacts.org/images/products/848/000/015/0936/front_es.42.200.jpg',
                                            scoreImages: [
                                              'https://static.openfoodfacts.org/images/attributes/nutriscore-b.svg',
                                              'https://static.openfoodfacts.org/images/attributes/nova-group-4.svg',
                                              'https://static.openfoodfacts.org/images/attributes/ecoscore-b.svg'
                                            ],
                                            scoreTitles: [
                                              'Nutri-Score B - Good nutritional quality',
                                              'NOVA 4 - Ultra processed foods',
                                              'Eco-Score B - Low environmental impact'
                                            ],
                                          );
                                        }));
                              }
                            })),
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 56,
                              child: Center(
                                
                              ),
                            )),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            }));
  }
}

 
