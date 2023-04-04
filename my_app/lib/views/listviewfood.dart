import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/views/AddAlimentoPage.dart';
import 'package:my_app/views/CrearUsuario.dart';
import 'package:my_app/views/EditarUsuario.dart';
import 'package:my_app/views/buscador.dart';

import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/views/mostrarFood.dart';
import '../model/Usuario.dart';

class ListAlimentos extends StatefulWidget {
  final String nombreUsuario;
  final bool isPremium = false;

  const ListAlimentos({required this.nombreUsuario});

  @override
  _ListAlimentosState createState() => _ListAlimentosState();
}

class _ListAlimentosState extends State<ListAlimentos> {
  late List data;
  bool _showFoods = true;

  void _toggleShowFoods() {
    setState(() {
      _showFoods = !_showFoods;
    });
  }

  @override
  void initState() {
    this.getData();
  }

  Future<List> getData() async {
    final response = await http.get(
        Uri.parse("http://localhost:8080/foods/user/${widget.nombreUsuario}"));
    return json.decode(response.body);
  }

  Future<Usuario> getUser() async {
    final response = await http
        .get(Uri.parse("http://localhost:8080/users/${widget.nombreUsuario}"));
    if (response.statusCode == 200) {
      return Usuario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  _navigateAddAlimento(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddAlimentoPage(nombreUsuario: widget.nombreUsuario)));
  }

  _navigateEditarUsuarioPage(BuildContext context) async {
    Usuario usuario = await getUser();
    String usuarioNombre = usuario.nombre;
    String usuarioNombreUsuario = usuario.nombreUsuario;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditarUsuarioPage(
                nombreUsuario: usuarioNombreUsuario, nombre: usuarioNombre)));
  }

  _navigateCrearUsuarioPage(BuildContext context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CrearUsuarioPage()));
  }

  Future<void> deleteData(int id) async {
    final response = await http.delete(
      Uri.parse("http://localhost:8080/foods/$id"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // esto evita que aparezca el botón de volver
        actions: [
          Expanded(
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Cerrar sesión'),
                      content:
                          Text('¿Estás seguro de que deseas cerrar sesión?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Cerrar el cuadro de diálogo
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Lógica para cerrar sesión
                            // Cerrar el cuadro de diálogo
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => CrearUsuarioPage()),
                            );
                          },
                          child: Text('Confirmar'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.person),
              onPressed: () => _navigateEditarUsuarioPage(context),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.apple),
              onPressed: () {
                // Código para la acción de la manzana
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.bar_chart),
              onPressed: () {
                if (widget.isPremium) {
                  // Código para la acción de estadísticas
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Solo para premium'),
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
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.swap_horiz),
              onPressed: () {
                if (widget.isPremium) {
                  // Código para la acción de intercambio
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Solo para premium'),
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
            ),
          ),
          Expanded(
              child: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BuscadorComida(nombreUsuario: widget.nombreUsuario)));
            },
          )),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (!_showFoods) {
                    _toggleShowFoods();
                  }
                },
                child: const Text('Mis alimentos'),
                style: ElevatedButton.styleFrom(
                  primary: _showFoods ? Colors.green : Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  if (_showFoods) {
                    _toggleShowFoods();
                  }
                },
                child: const Text('Mis recetas'),
                style: ElevatedButton.styleFrom(
                  primary: _showFoods ? Colors.grey : Colors.green,
                ),
              ),
            ],
          ),
          Expanded(
            child: _showFoods
                ? FutureBuilder<List>(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                       // print(snapshot.error);
                      }
                      return snapshot.hasData
                          ? ItemList(
                              list: snapshot.data!,
                              deleteItem: deleteData,
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            );
                    },
                  )
                : Container(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 56.0,
          child: ElevatedButton(
            onPressed: () => _navigateAddAlimento(context),
            child: Text(
              'Añadir alimento',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.orangeAccent,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  final Function(int) deleteItem;

  const ItemList({required this.list, required this.deleteItem});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: list == null ? 0 : list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (context, i) {
        return SizedBox(
          height: 100.3,
          child: Card(
            color: Colors.orange[200],
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: list[i]['image'] != null && list[i]['image'] != ""
                      ? FutureBuilder(
                          future: http.head(Uri.parse(list[i]['image'])),
                          builder: (BuildContext context,
                              AsyncSnapshot<http.Response> snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data!.statusCode == 200) {
                              return FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder_image.png',
                                image: list[i]['image'],
                                fit: BoxFit.cover,
                              );
                            } else {
                              return Icon(
                                Icons.fastfood,
                                color: Colors.white,
                                size: 50,
                              );
                            }
                          },
                        )
                      : Icon(
                          Icons.fastfood,
                          color: Colors.white,
                          size: 50,
                        ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.delete_outline),
                    color: Colors.white,
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
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                        fontFamily: "Open Sans",
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MostrarFood(
                            name: list[i]['name'],
                            cantidad: list[i]['cantidad'],
                            unidadesCantidad: list[i]['unidadesCantidad'],
                            calorias: list[i]['calorias'],
                            grasas: list[i]['grasas'],
                            proteinas: list[i]['proteinas'],
                            carbohidratos: list[i]['carbohidratos'],
                            image: list[i]['image']
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
