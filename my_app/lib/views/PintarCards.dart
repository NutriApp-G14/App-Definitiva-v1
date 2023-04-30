import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/views/AddAlimentoPage.dart';
import 'package:my_app/views/AddRecetasPage.dart';
import 'package:my_app/views/CrearUsuario.dart';
import 'package:my_app/views/EditarUsuario.dart';
import 'package:my_app/views/UsuarioPage.dart';
import 'package:my_app/model/NavBar.dart';

import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/views/mostrarFood.dart';
import 'package:my_app/views/mostrarReceta.dart';
import '../model/Usuario.dart';

class ItemListAlimento extends StatelessWidget {
  final List list;
  final Function(int) deleteItem;
  final String nombreUsuario;

  const ItemListAlimento(
      {required this.list,
      required this.deleteItem,
      required this.nombreUsuario});
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
            return GestureDetector(
                onTap: () {
                  print("codigo");
                  print(list[i]['codigoDeBarras']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MostrarFood(
                        id: list[i]['id'] ?? 0,
                        codigoDeBarras: list[i]['codigoDeBarras'] ?? "",
                        nombreUsuario: nombreUsuario,
                        name: list[i]['name'],
                        cantidad: list[i]['cantidad'],
                        unidadesCantidad: list[i]['unidadesCantidad'],
                        calorias: list[i]['calorias'],
                        grasas: list[i]['grasas'],
                        proteinas: list[i]['proteinas'],
                        carbohidratos: list[i]['carbohidratos'],
                        sodio: list[i]['sodio'] ?? 0.0,
                        azucar: list[i]['azucar'] ?? 0.0,
                        fibra: list[i]['fibra'] ?? 0.0,
                        image: list[i]['image'],
                        showBotonAlimentos: true,
                        showBotonRegistro: false,
                        showBotonGuardar: false,
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  height: 100.3,
                  child: Card(
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: list[i]['image'] != null &&
                                  list[i]['image'] != ""
                              ? FutureBuilder(
                                  future:
                                      http.head(Uri.parse(list[i]['image'])),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<http.Response> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.statusCode == 200) {
                                      return FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/placeholder_image.png',
                                        image: list[i]['image'],
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      return Icon(
                                        Icons.fastfood,
                                        color: Colors.black,
                                        size: 50,
                                      );
                                    }
                                  },
                                )
                              : Icon(
                                  Icons.fastfood,
                                  color: Colors.black,
                                  size: 50,
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.delete_outline),
                            color: Colors.black,
                            onPressed: () {
                              deleteItem(list[i]['id']);
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              list[i]['name'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                fontFamily: "Open Sans",
                                fontSize: 18.0,
                                // color: Color.fromARGB(255, 255, 255, 255),
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
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
            return GestureDetector(
                onTap: () {
                  print("codigo");
                  print(list[i]['codigoDeBarras']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MostrarFood(
                        id: list[i]['id'] ?? 0,
                        codigoDeBarras: list[i]['codigoDeBarras'] ?? "",
                        nombreUsuario: nombreUsuario,
                        name: list[i]['name'],
                        cantidad: list[i]['cantidad'],
                        unidadesCantidad: list[i]['unidadesCantidad'],
                        calorias: list[i]['calorias'],
                        grasas: list[i]['grasas'],
                        proteinas: list[i]['proteinas'],
                        carbohidratos: list[i]['carbohidratos'],
                        sodio: list[i]['sodio'] ?? 0.0,
                        azucar: list[i]['azucar'] ?? 0.0,
                        fibra: list[i]['fibra'] ?? 0.0,
                        image: list[i]['image'],
                        showBotonAlimentos: true,
                        showBotonRegistro: false,
                        showBotonGuardar: false,
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  height: 100.3,
                  child: Card(
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: list[i]['image'] != null &&
                                  list[i]['image'] != ""
                              ? FutureBuilder(
                                  future:
                                      http.head(Uri.parse(list[i]['image'])),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<http.Response> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.statusCode == 200) {
                                      return FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/placeholder_image.png',
                                        image: list[i]['image'],
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      return Icon(
                                        Icons.fastfood,
                                        color: Colors.black,
                                        size: 50,
                                      );
                                    }
                                  },
                                )
                              : Icon(
                                  Icons.fastfood,
                                  color: Colors.black,
                                  size: 50,
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.delete_outline),
                            color: Colors.black,
                            onPressed: () {
                              deleteItem(list[i]['id']);
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              list[i]['name'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                fontFamily: "Open Sans",
                                fontSize: 18.0,
                                // color: Color.fromARGB(255, 255, 255, 255),
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
            return GestureDetector(
                onTap: () {
                  print("codigo");
                  print(list[i]['codigoDeBarras']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MostrarFood(
                        id: list[i]['id'] ?? 0,
                        codigoDeBarras: list[i]['codigoDeBarras'] ?? "",
                        nombreUsuario: nombreUsuario,
                        name: list[i]['name'],
                        cantidad: list[i]['cantidad'],
                        unidadesCantidad: list[i]['unidadesCantidad'],
                        calorias: list[i]['calorias'],
                        grasas: list[i]['grasas'],
                        proteinas: list[i]['proteinas'],
                        carbohidratos: list[i]['carbohidratos'],
                        sodio: list[i]['sodio'] ?? 0.0,
                        azucar: list[i]['azucar'] ?? 0.0,
                        fibra: list[i]['fibra'] ?? 0.0,
                        image: list[i]['image'],
                        showBotonAlimentos: true,
                        showBotonRegistro: false,
                        showBotonGuardar: false,
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  height: 100.3,
                  child: Card(
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: list[i]['image'] != null &&
                                  list[i]['image'] != ""
                              ? FutureBuilder(
                                  future:
                                      http.head(Uri.parse(list[i]['image'])),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<http.Response> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.statusCode == 200) {
                                      return FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/placeholder_image.png',
                                        image: list[i]['image'],
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      return Icon(
                                        Icons.fastfood,
                                        color: Colors.black,
                                        size: 50,
                                      );
                                    }
                                  },
                                )
                              : Icon(
                                  Icons.fastfood,
                                  color: Colors.black,
                                  size: 50,
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.delete_outline),
                            color: Colors.black,
                            onPressed: () {
                              deleteItem(list[i]['id']);
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              list[i]['name'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                fontFamily: "Open Sans",
                                fontSize: 18.0,
                                // color: Color.fromARGB(255, 255, 255, 255),
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          },
        );
        ;
      }
    });
  }
}
