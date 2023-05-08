import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:my_app/model/TarjetaMisAlimentos.dart';
import 'package:my_app/model/TarjetaReceta.dart';
import 'package:my_app/views/AddAlimentoPage.dart';
import 'package:my_app/views/AddRecetasPage.dart';
import 'package:my_app/views/CrearUsuario.dart';
import 'package:my_app/views/EditarUsuario.dart';
import 'package:my_app/views/PintarCards.dart';
import 'package:my_app/views/UsuarioPage.dart';
import 'package:my_app/model/NavBar.dart';

import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/views/mostrarFood.dart';
import 'package:my_app/views/mostrarReceta.dart';
import '../model/Usuario.dart';

class ListAlimentos extends StatefulWidget {
  final String nombreUsuario;
  final String token;
  final bool isPremium = true;

  const ListAlimentos({required this.nombreUsuario, required this.token});

  @override
  _ListAlimentosState createState() => _ListAlimentosState();
}

class _ListAlimentosState extends State<ListAlimentos> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  late List data;
  bool _showFoods = true;

  void _toggleShowFoods() {
    setState(() {
      _showFoods = !_showFoods;
    });
  }

  _navigateAddReceta(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddRecetasPage(nombreUsuario: widget.nombreUsuario, token: widget.token)));
  }

  _navigateAddAlimento(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddAlimentoPage(nombreUsuario: widget.nombreUsuario, token: widget.token)));
  }

  _navigateListViewRecetas(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddAlimentoPage(nombreUsuario: widget.nombreUsuario, token: widget.token)));
  }

  _navigateUsuarioPage(BuildContext context) async {
    Usuario usuario = await dataBaseHelper.getUsuarioById(widget.nombreUsuario);
    String usuarioNombre = usuario.nombre;
    String usuarioNombreUsuario = usuario.nombreUsuario;
    String imageProfile = "";
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => UsuarioPage(
          nombreUsuario: usuarioNombreUsuario, nombre: usuarioNombre,token:widget.token),
      transitionDuration: Duration(seconds: 0),
    ));
  }

  _navigateCrearUsuarioPage(BuildContext context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CrearUsuarioPage()));
  }

  Future<void> deleteData(int id) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    final response = await ioClient.delete(
      Uri.parse("$urlConexion/foods/$id"), headers: { "Authorization" : widget.token}
    );
    setState(() {});
  }

  Future<void> deleteDataReceta(int id) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    final response = await ioClient.delete(
      Uri.parse("${urlConexion}/recipes/$id"), headers: {"Authorization" : widget.token}
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(52),
            child: NutriAppBar(nombreUsuario: widget.nombreUsuario,token: widget.token),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 16.0), // Espacio vertical deseado
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (!_showFoods) {
                      _toggleShowFoods();
                    }
                  },
                  child: const Text('Alimentos'),
                  style: ElevatedButton.styleFrom(
                    primary: _showFoods
                        ? Color.fromARGB(255, 245, 199, 169)
                        : Color.fromARGB(255, 249, 239, 198),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (widget.isPremium) {
                      if (_showFoods) {
                        _toggleShowFoods();
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(children: [
                              Text('Solo para premium'),
                              Icon(
                                Icons.workspace_premium,
                                color: Colors.amberAccent,
                              )
                            ]),
                            content: Text(
                                'Esta funcionalidad está disponible solo para usuarios premium'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Comprar premium'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Row(children: [
                    Text('Mis recetas '),
                    Icon(Icons.workspace_premium, size: 15)
                  ]),
                  style: ElevatedButton.styleFrom(
                    primary: _showFoods
                        ? Color.fromARGB(255, 249, 239, 198)
                        : Color.fromARGB(255, 245, 199, 169),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _showFoods
                  ? FutureBuilder<List>(
                      future: dataBaseHelper.getData(widget.nombreUsuario,widget.token),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                        } else {
                          return snapshot.hasData
                              ? ItemList(
                                  nombreUsuario: widget.nombreUsuario,
                                  list: snapshot.data!,
                                  deleteItem: deleteData,
                                  token: widget.token,
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                );
                        }
                        return Column();
                      },
                    )
                  : FutureBuilder<List>(
                      future: dataBaseHelper.getRecetas(widget.nombreUsuario, widget.token),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          // print(snapshot.error);
                        }
                        return snapshot.hasData
                            ? ItemListReceta(
                                list: snapshot.data!,
                                deleteItem: deleteDataReceta,
                                nombreUsuario: widget.nombreUsuario,
                                token: widget.token
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              );
                      },
                    ),
            ),
          ],
        ),
        bottomNavigationBar: _showFoods
            ? BottomAppBar(
                //color: Colors.pink,
                child: SizedBox(
                height: 56,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => _navigateAddAlimento(context),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
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
              ))
            : BottomAppBar(
                //color: Colors.pink,
                child: SizedBox(
                height: 56,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => _navigateAddReceta(context),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      decoration: BoxDecoration(color: Colors.orange
                          //borderRadius: BorderRadius.circular(20.0),
                          ),
                      child: Text(
                        'Añadir receta',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              )));
  }
}

//Pintar los Alimentos
class ItemList extends StatelessWidget {
  final List list;
  final Function(int) deleteItem;
  final String nombreUsuario;
  final String token;

  const ItemList(
      {required this.list,
      required this.deleteItem,
      required this.nombreUsuario, required this.token});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        return GridView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: list == null ? 0 : list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (context, i) {
            var nombreAlimento = list[i]['name'].toString() ?? "";
            var codigoDeBarras = list[i]['codigoDeBarras'] ?? "";
            var imageUrl = "";
            var id = list[i]['id'];
            if (list[i]['image'] != null && list[i]['image'] != "") {
              imageUrl = list[i]['image'];
            }

            var cantidad = list[i]['cantidad'] ?? 100.0;
            var calorias = list[i]['calorias'] ?? 0.0;
            var grasas = list[i]['grasas'] ?? 0.0;
            var proteinas = list[i]['proteinas'] ?? 0.0;
            var carbohidratos = list[i]['carbohidratos'] ?? 0.0;
            var sodio = list[i]['sodio'] ?? 0.0;
            var azucar = list[i]['azucar'] ?? 0.0;
            var fibra = list[i]['fibra'] ?? 0.0;
            var unidadesCantidad = list[i]['unidadesCantidad'] ?? "";
            List<dynamic> alergenos_dynamic = list[i]['alergenos'] ?? [''];
            var alergenos = alergenos_dynamic.map((e) => e.toString()).toList();
            return SizedBox(
                height: 100.3,
                child: TarjetaMisAlimento(
                    nombreAlimento: nombreAlimento,
                    codigoDeBarras: codigoDeBarras,
                    imageUrl: imageUrl,
                    id: id,
                    nombreUsuario: nombreUsuario,
                    cantidad: cantidad,
                    calorias: calorias,
                    grasas: grasas,
                    proteinas: proteinas,
                    carbohidratos: carbohidratos,
                    sodio: sodio,
                    azucar: azucar,
                    fibra: fibra,
                    unidadesCantidad: unidadesCantidad,
                    alergenos: alergenos,
                    token:token));
          },
        );
      } else if (constraints.maxWidth < 1100) {
        return GridView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: list == null ? 0 : list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (context, i) {
            var nombreAlimento = list[i]['name'].toString() ?? "";
            var codigoDeBarras = list[i]['codigoDeBarras'] ?? "";
            var imageUrl = "";
            var id = list[i]['id'];
            if (list[i]['image'] != null && list[i]['image'] != "") {
              imageUrl = list[i]['image'];
            }

            var cantidad = list[i]['cantidad'] ?? 100.0;
            var calorias = list[i]['calorias'] ?? 0.0;
            var grasas = list[i]['grasas'] ?? 0.0;
            var proteinas = list[i]['proteinas'] ?? 0.0;
            var carbohidratos = list[i]['carbohidratos'] ?? 0.0;
            var sodio = list[i]['sodio'] ?? 0.0;
            var azucar = list[i]['azucar'] ?? 0.0;
            var fibra = list[i]['fibra'] ?? 0.0;
            var unidadesCantidad = list[i]['unidadesCantidad'] ?? "";
            List<dynamic> alergenos_dynamic = list[i]['alergenos'] ?? [''];
            var alergenos = alergenos_dynamic.map((e) => e.toString()).toList();
            return SizedBox(
                height: 100.3,
                child: TarjetaMisAlimento(
                  nombreAlimento: nombreAlimento,
                  codigoDeBarras: codigoDeBarras,
                  imageUrl: imageUrl,
                  id: id,
                  nombreUsuario: nombreUsuario,
                  cantidad: cantidad,
                  calorias: calorias,
                  grasas: grasas,
                  proteinas: proteinas,
                  carbohidratos: carbohidratos,
                  sodio: sodio,
                  azucar: azucar,
                  fibra: fibra,
                  unidadesCantidad: unidadesCantidad,
                  alergenos: alergenos,
                  token:token
                ));
          },
        );
      } else {
        return GridView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: list == null ? 0 : list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (context, i) {
            var nombreAlimento = list[i]['name'].toString() ?? "";
            var codigoDeBarras = list[i]['codigoDeBarras'] ?? "";
            var imageUrl = "";
            var id = list[i]['id'];
            if (list[i]['image'] != null && list[i]['image'] != "") {
              imageUrl = list[i]['image'];
            }
            var cantidad = list[i]['cantidad'] ?? 100.0;
            var calorias = list[i]['calorias'] ?? 0.0;
            var grasas = list[i]['grasas'] ?? 0.0;
            var proteinas = list[i]['proteinas'] ?? 0.0;
            var carbohidratos = list[i]['carbohidratos'] ?? 0.0;
            var sodio = list[i]['sodio'] ?? 0.0;
            var azucar = list[i]['azucar'] ?? 0.0;
            var fibra = list[i]['fibra'] ?? 0.0;
            var unidadesCantidad = list[i]['unidadesCantidad'] ?? "";
            List<dynamic> alergenos_dynamic = list[i]['alergenos'] ?? [''];
            var alergenos = alergenos_dynamic.map((e) => e.toString()).toList();
            return SizedBox(
                height: 100.3,
                child: TarjetaMisAlimento(
                  nombreAlimento: nombreAlimento,
                  codigoDeBarras: codigoDeBarras,
                  imageUrl: imageUrl,
                  id: id,
                  nombreUsuario: nombreUsuario,
                  cantidad: cantidad,
                  calorias: calorias,
                  grasas: grasas,
                  proteinas: proteinas,
                  carbohidratos: carbohidratos,
                  sodio: sodio,
                  azucar: azucar,
                  fibra: fibra,
                  unidadesCantidad: unidadesCantidad,
                  alergenos: alergenos,
                  token:token
                ));
          },
        );
      }
    });
  }
}

class ItemListReceta extends StatelessWidget {
  final List list;
  final Function(int) deleteItem;
  final String nombreUsuario;
  final String token;

  const ItemListReceta(
      {required this.list,
      required this.deleteItem,
      required this.nombreUsuario, required this.token});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: list == null ? 0 : list.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilder: (context, i) {
              var imageUrl = "";
              var id = list[i]['id'];
              if (list[i]['image'] != null && list[i]['image'] != "") {
                imageUrl = list[i]['image'];
              }
              var name = list[i]['nombre'] ?? "";
              var cantidad = list[i]['porciones'] ?? 0;
              var unidadesCantidad = list[i]['unidadesMedida'] ?? "";

              var ingredientes = list[i]['ingredientes'] ?? [];
              var descripcion = list[i]['descripcion'] ?? '';
              var pasos = list[i]['pasos'] ?? [];

              return SizedBox(
                  height: 100.3,
                  child: TarjetaReceta(
                      imageUrl: imageUrl,
                      id: id,
                      nombreUsuario: nombreUsuario,
                      cantidad: cantidad,
                      unidadesCantidad: unidadesCantidad,
                      name: name,
                      descripcion: descripcion,
                      pasos: pasos,
                      ingredientes: ingredientes,
                      token:token
                      ));
            });
      } else if (constraints.maxWidth < 1100) {
        return GridView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: list == null ? 0 : list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (context, i) {
            var imageUrl = "";
            var id = list[i]['id'];
            if (list[i]['image'] != null && list[i]['image'] != "") {
              imageUrl = list[i]['image'];
            }
            var name = list[i]['nombre'] ?? "";
            var cantidad = list[i]['porciones'] ?? 0;
            var unidadesCantidad = list[i]['unidadesMedida'] ?? "";

            var ingredientes = list[i]['ingredientes'] ?? [];
            var descripcion = list[i]['descripcion'] ?? '';
            var pasos = list[i]['pasos'] ?? [];

            return SizedBox(
                height: 100.3,
                child: TarjetaReceta(
                    imageUrl: imageUrl,
                    id: id,
                    nombreUsuario: nombreUsuario,
                    cantidad: cantidad,
                    unidadesCantidad: unidadesCantidad,
                    name: name,
                    descripcion: descripcion,
                    pasos: pasos,
                    ingredientes: ingredientes,token:token));
          },
        );
      } else {
        return GridView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: list == null ? 0 : list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (context, i) {
            var imageUrl = "";
            var id = list[i]['id'];
            if (list[i]['image'] != null && list[i]['image'] != "") {
              imageUrl = list[i]['image'];
            }
            var name = list[i]['nombre'] ?? "";
            var cantidad = list[i]['porciones'] ?? 0;
            var unidadesCantidad = list[i]['unidadesMedida'] ?? "";

            var ingredientes = list[i]['ingredientes'] ?? [];
            var descripcion = list[i]['descripcion'] ?? '';
            var pasos = list[i]['pasos'] ?? [];

            return SizedBox(
                height: 100.3,
                child: TarjetaReceta(
                    imageUrl: imageUrl,
                    id: id,
                    nombreUsuario: nombreUsuario,
                    cantidad: cantidad,
                    unidadesCantidad: unidadesCantidad,
                    name: name,
                    descripcion: descripcion,
                    pasos: pasos,
                    ingredientes: ingredientes, token:token));
          },
        );
      }
    });
  }
}
