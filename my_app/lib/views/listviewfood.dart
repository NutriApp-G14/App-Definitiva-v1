import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/model/TarjetaMisAlimentos.dart';
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
  final bool isPremium = true;

  const ListAlimentos({required this.nombreUsuario});

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
                AddRecetasPage(nombreUsuario: widget.nombreUsuario)));
  }

  _navigateAddAlimento(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddAlimentoPage(nombreUsuario: widget.nombreUsuario)));
  }

  _navigateListViewRecetas(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddAlimentoPage(nombreUsuario: widget.nombreUsuario)));
  }

  _navigateUsuarioPage(BuildContext context) async {
    Usuario usuario = await dataBaseHelper.getUsuarioById(widget.nombreUsuario);
    String usuarioNombre = usuario.nombre;
    String usuarioNombreUsuario = usuario.nombreUsuario;
    String imageProfile = "";
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => UsuarioPage(
          nombreUsuario: usuarioNombreUsuario, nombre: usuarioNombre),
      transitionDuration: Duration(seconds: 0),
    ));
  }

  _navigateCrearUsuarioPage(BuildContext context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CrearUsuarioPage()));
  }

  Future<void> deleteData(int id) async {
    final response = await http.delete(
      Uri.parse("$urlConexion/foods/$id"),
    );
    setState(() {});
  }

  Future<void> deleteDataReceta(int id) async {
    final response = await http.delete(
      Uri.parse("${urlConexion}/recipes/$id"),
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
            child: NutriAppBar(nombreUsuario: widget.nombreUsuario),
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
                      future: dataBaseHelper.getData(widget.nombreUsuario),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                        } else {
                          return snapshot.hasData
                              ? ItemList(
                                  nombreUsuario: widget.nombreUsuario,
                                  list: snapshot.data!,
                                  deleteItem: deleteData,
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                );
                        }
                        return Column();
                      },
                    )
                  : FutureBuilder<List>(
                      future: dataBaseHelper.getRecetas(widget.nombreUsuario),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          // print(snapshot.error);
                        }
                        return snapshot.hasData
                            ? ItemListReceta(
                                list: snapshot.data!,
                                deleteItem: deleteDataReceta,
                                nombreUsuario: widget.nombreUsuario,
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

  const ItemList(
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
          var nombreAlimento = list[i]['name'].toString() ?? "";
          var codigoDeBarras= list[i]['codigoDeBarras'] ??"";
          var imageUrl = ""; 
          var id =  list[i]['id']; 
          if (list[i]['image'] != null && list[i]['image'] != ""){
            imageUrl = list[i]['image'];
          }

          var cantidad= list[i]['cantidad']?? 100.0;
          var calorias= list[i]['calorias']?? 0.0;
          var grasas= list[i]['grasas']?? 0.0;
          var proteinas= list[i]['proteinas']?? 0.0;
          var carbohidratos= list[i]['carbohidratos']?? 0.0;
          var sodio=  list[i]['sodio'] ?? 0.0;
          var azucar=  list[i]['azucar'] ?? 0.0;
          var fibra=  list[i]['fibra'] ?? 0.0;
          var unidadesCantidad =  list[i]['unidadesCantidad'] ?? "";

            return SizedBox(
              height: 100.3,
              child:  TarjetaMisAlimento(nombreAlimento: nombreAlimento 
              ,codigoDeBarras: codigoDeBarras, imageUrl: imageUrl, id:id,
               nombreUsuario: nombreUsuario, cantidad:cantidad, calorias: calorias, grasas: grasas,
               proteinas: proteinas, carbohidratos:carbohidratos, sodio: sodio , azucar: azucar, fibra:fibra,
               unidadesCantidad: unidadesCantidad,
            )
            );
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
          var codigoDeBarras= list[i]['codigoDeBarras'] ??"";
          var imageUrl = ""; 
          var id =  list[i]['id']; 
          if (list[i]['image'] != null && list[i]['image'] != ""){
            imageUrl = list[i]['image'];
          }

          var cantidad= list[i]['cantidad']?? 100.0;
          var calorias= list[i]['calorias']?? 0.0;
          var grasas= list[i]['grasas']?? 0.0;
          var proteinas= list[i]['proteinas']?? 0.0;
          var carbohidratos= list[i]['carbohidratos']?? 0.0;
          var sodio=  list[i]['sodio'] ?? 0.0;
          var azucar=  list[i]['azucar'] ?? 0.0;
          var fibra=  list[i]['fibra'] ?? 0.0;
          var unidadesCantidad =  list[i]['unidadesCantidad'] ?? "";

            return SizedBox(
              height: 100.3,
              child:  TarjetaMisAlimento(nombreAlimento: nombreAlimento 
              ,codigoDeBarras: codigoDeBarras, imageUrl: imageUrl, id:id,
               nombreUsuario: nombreUsuario, cantidad:cantidad, calorias: calorias, grasas: grasas,
               proteinas: proteinas, carbohidratos:carbohidratos, sodio: sodio , azucar: azucar, fibra:fibra,
               unidadesCantidad:unidadesCantidad ,
            )
            );
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
          var codigoDeBarras= list[i]['codigoDeBarras'] ??"";
          var imageUrl = ""; 
          var id =  list[i]['id']; 
          if (list[i]['image'] != null && list[i]['image'] != ""){
            imageUrl = list[i]['image'];
          }
          var cantidad= list[i]['cantidad']?? 100.0;
          var calorias= list[i]['calorias']?? 0.0;
          var grasas= list[i]['grasas']?? 0.0;
          var proteinas= list[i]['proteinas']?? 0.0;
          var carbohidratos= list[i]['carbohidratos']?? 0.0;
          var sodio=  list[i]['sodio'] ?? 0.0;
          var azucar=  list[i]['azucar'] ?? 0.0;
          var fibra=  list[i]['fibra'] ?? 0.0;
          var unidadesCantidad =  list[i]['unidadesCantidad'] ?? "";

            return SizedBox(
              height: 100.3,
              child: TarjetaMisAlimento(nombreAlimento: nombreAlimento 
              ,codigoDeBarras: codigoDeBarras, imageUrl: imageUrl, id:id,
               nombreUsuario: nombreUsuario, cantidad:cantidad, calorias: calorias, grasas: grasas,
               proteinas: proteinas, carbohidratos:carbohidratos, sodio: sodio , azucar: azucar, fibra:fibra,
               unidadesCantidad: unidadesCantidad,
            ));
          },
        );
      }
    });
  }
}

//Pintar las Recetas

// class ItemListReceta extends StatelessWidget {
//   final String nombreUsuario;
//   final List list;
//   final Function(int) deleteItem;

//   const ItemListReceta({required this.list, required this.deleteItem, required this.nombreUsuario});
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//       if (constraints.maxWidth < 600) {
//         return GridView.builder(
//           padding: const EdgeInsets.all(10.0),
//           itemCount: list == null ? 0 : list.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 10.0,
//             mainAxisSpacing: 10.0,
//           ),
//           itemBuilder: (context, i) {
//             print("media");
//             return SizedBox(
//               height: 100.3,
//               child: Card(
//                 color: Colors.orange[200],
//                 child: Stack(
//                   children: [
//                     Align(
//                       alignment: Alignment.center,
//                       child: list[i]['imagen'] != null &&
//                               list[i]['imagen'] != ""
//                           ? FutureBuilder(
//                               future: http.head(Uri.parse(list[i]['imagen'])),
//                               builder: (BuildContext context,
//                                   AsyncSnapshot<http.Response> snapshot) {
//                                 if (snapshot.hasData &&
//                                     snapshot.data!.statusCode == 200) {
//                                   return FadeInImage.assetNetwork(
//                                     placeholder: 'assets/placeholder_image.png',
//                                     image: list[i]['imagen'],
//                                     fit: BoxFit.cover,
//                                   );
//                                 } else {
//                                   return Icon(
//                                     Icons.fastfood,
//                                     color: Colors.white,
//                                     size: 50,
//                                   );
//                                 }
//                               },
//                             )
//                           : Icon(
//                               Icons.fastfood,
//                               color: Colors.white,
//                               size: 50,
//                             ),
//                     ),
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: IconButton(
//                         icon: Icon(Icons.delete_outline),
//                         color: Colors.orange,
//                         onPressed: () {
//                           deleteItem(list[i]['id']);
//                         },
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.bottomLeft,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           list[i]['nombre'].toString(),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontStyle: FontStyle.normal,
//                             fontFamily: "Open Sans",
//                             fontSize: 18.0,
//                             // color: Color.fromARGB(255, 255, 255, 255),
//                             color: Colors.orange,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: IconButton(
//                         icon: Icon(Icons.remove_red_eye),
//                         //color: Color.fromARGB(255, 255, 255, 255),
//                         color: Colors.orange,
//                         onPressed: () {
//                           print("codigo");
//                           print(list[i]['codigoDeBarras']);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => MostrarFood(
//                                 id: list[i]['id'] ?? 0,
//                                 codigoDeBarras: list[i]['codigoDeBarras'] ?? "",
//                                 nombreUsuario: nombreUsuario,
//                                 name: list[i]['name'],
//                                 cantidad: list[i]['cantidad'],
//                                 unidadesCantidad: list[i]['unidadesCantidad'],
//                                 calorias: list[i]['calorias'],
//                                 grasas: list[i]['grasas'],
//                                 proteinas: list[i]['proteinas'],
//                                 carbohidratos: list[i]['carbohidratos'],
//                                 sodio: list[i]['sodio'] ?? 0.0,
//                                 azucar: list[i]['azucar'] ?? 0.0,
//                                 fibra: list[i]['fibra'] ?? 0.0,
//                                 image: list[i]['image'],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       } else if (constraints.maxWidth < 1100) {
//         return GridView.builder(
//           padding: const EdgeInsets.all(10.0),
//           itemCount: list == null ? 0 : list.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             crossAxisSpacing: 10.0,
//             mainAxisSpacing: 10.0,
//           ),
//           itemBuilder: (context, i) {
//             return SizedBox(
//               height: 100.3,
//               child: Card(
//                 color: Colors.orange[200],
//                 child: Stack(
//                   children: [
//                     Align(
//                       alignment: Alignment.center,
//                       child: list[i]['imagen'] != null &&
//                               list[i]['imagen'] != ""
//                           ? FutureBuilder(
//                               future: http.head(Uri.parse(list[i]['imagen'])),
//                               builder: (BuildContext context,
//                                   AsyncSnapshot<http.Response> snapshot) {
//                                 if (snapshot.hasData &&
//                                     snapshot.data!.statusCode == 200) {
//                                   return FadeInImage.assetNetwork(
//                                     placeholder: 'assets/placeholder_image.png',
//                                     image: list[i]['imagen'],
//                                     fit: BoxFit.cover,
//                                   );
//                                 } else {
//                                   return Icon(
//                                     Icons.fastfood,
//                                     color: Colors.white,
//                                     size: 50,
//                                   );
//                                 }
//                               },
//                             )
//                           : Icon(
//                               Icons.fastfood,
//                               color: Colors.white,
//                               size: 50,
//                             ),
//                     ),
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: IconButton(
//                         icon: Icon(Icons.delete_outline),
//                         color: Colors.orange,
//                         onPressed: () {
//                           deleteItem(list[i]['id']);
//                         },
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.bottomLeft,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           list[i]['nombre'].toString(),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontStyle: FontStyle.normal,
//                             fontFamily: "Open Sans",
//                             fontSize: 18.0,
//                             // color: Color.fromARGB(255, 255, 255, 255),
//                             color: Colors.orange,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: IconButton(
//                         icon: Icon(Icons.remove_red_eye),
//                         //color: Color.fromARGB(255, 255, 255, 255),
//                         color: Colors.orange,
//                         onPressed: () {
//                           print("codigo");
//                           print(list[i]['codigoDeBarras']);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => MostrarFood(
//                                 id: list[i]['id'] ?? 0.0,
//                                 codigoDeBarras: list[i]['codigoDeBarras'] ?? "",
//                                 nombreUsuario: nombreUsuario,
//                                 name: list[i]['name'],
//                                 cantidad: list[i]['cantidad'],
//                                 unidadesCantidad: list[i]['unidadesCantidad'],
//                                 calorias: list[i]['calorias'],
//                                 grasas: list[i]['grasas'],
//                                 proteinas: list[i]['proteinas'],
//                                 carbohidratos: list[i]['carbohidratos'],
//                                 sodio: list[i]['sodio'] ?? 0.0,
//                                 azucar: list[i]['azucar'] ?? 0.0,
//                                 fibra: list[i]['fibra'] ?? 0.0,
//                                 image: list[i]['image'],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       } else {
//         return GridView.builder(
//           padding: const EdgeInsets.all(10.0),
//           itemCount: list == null ? 0 : list.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 6,
//             crossAxisSpacing: 10.0,
//             mainAxisSpacing: 10.0,
//           ),
//           itemBuilder: (context, i) {
//             return SizedBox(
//               height: 100.3,
//               child: Card(
//                 color: Colors.orange[200],
//                 child: Stack(
//                   children: [
//                     Align(
//                       alignment: Alignment.center,
//                       child: list[i]['imagen'] != null &&
//                               list[i]['imagen'] != ""
//                           ? FutureBuilder(
//                               future: http.head(Uri.parse(list[i]['imagen'])),
//                               builder: (BuildContext context,
//                                   AsyncSnapshot<http.Response> snapshot) {
//                                 if (snapshot.hasData &&
//                                     snapshot.data!.statusCode == 200) {
//                                   return FadeInImage.assetNetwork(
//                                     placeholder: 'assets/placeholder_image.png',
//                                     image: list[i]['imagen'],
//                                     fit: BoxFit.cover,
//                                   );
//                                 } else {
//                                   return Icon(
//                                     Icons.fastfood,
//                                     color: Colors.white,
//                                     size: 50,
//                                   );
//                                 }
//                               },
//                             )
//                           : Icon(
//                               Icons.fastfood,
//                               color: Colors.white,
//                               size: 50,
//                             ),
//                     ),
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: IconButton(
//                         icon: Icon(Icons.delete_outline),
//                         color: Colors.orange,
//                         onPressed: () {
//                           deleteItem(list[i]['id']);
//                         },
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.bottomLeft,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           list[i]['nombre'].toString(),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontStyle: FontStyle.normal,
//                             fontFamily: "Open Sans",
//                             fontSize: 18.0,
//                             // color: Color.fromARGB(255, 255, 255, 255),
//                             color: Colors.orange,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: IconButton(
//                         icon: Icon(Icons.remove_red_eye),
//                         //color: Color.fromARGB(255, 255, 255, 255),
//                         color: Colors.orange,
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => MostrarFood(
//                                 id: list[i]['id'] ?? 0.0,
//                                 codigoDeBarras: list[i]['codigoDeBarras'] ?? "",
//                                 nombreUsuario: nombreUsuario,
//                                 name: list[i]['name'],
//                                 cantidad: list[i]['cantidad'],
//                                 unidadesCantidad: list[i]['unidadesCantidad'],
//                                 calorias: list[i]['calorias'],
//                                 grasas: list[i]['grasas'],
//                                 proteinas: list[i]['proteinas'],
//                                 carbohidratos: list[i]['carbohidratos'],
//                                 sodio: list[i]['sodio'] ?? 0.0,
//                                 azucar: list[i]['azucar'] ?? 0.0,
//                                 fibra: list[i]['fibra'] ?? 0.0,
//                                 image: list[i]['image'],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }
//     });
//   }
// }

//Pintar las Recetas

class ItemListReceta extends StatelessWidget {
  final List list;
  final Function(int) deleteItem;
  final String nombreUsuario;

  const ItemListReceta(
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
            return SizedBox(
              height: 100.3,
              child: Card(
                color: Colors.white,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: list[i]['imagen'] != null &&
                              list[i]['imagen'] != ""
                          ? FutureBuilder(
                              future: http.head(Uri.parse(list[i]['imagen'])),
                              builder: (BuildContext context,
                                  AsyncSnapshot<http.Response> snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data!.statusCode == 200) {
                                  return FadeInImage.assetNetwork(
                                    placeholder: 'assets/placeholder_image.png',
                                    image: list[i]['imagen'],
                                    fit: BoxFit.cover,
                                  );
                                } else {
                                  return Icon(
                                    Icons.fastfood,
                                    color: Colors.orange[200],
                                    size: 50,
                                  );
                                }
                              },
                            )
                          : Icon(
                              Icons.fastfood,
                              color: Colors.orange[200],
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

                          list[i]['nombre'].toString().length > 16
                  ? '${list[i]['nombre'].toString().substring(0,15)}...'
                  : list[i]['nombre'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontFamily: "Open Sans",
                            fontSize: 15.0,
                            // color: Color.fromARGB(255, 255, 255, 255),
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        //color: Color.fromARGB(255, 255, 255, 255),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MostrarReceta(
                                  name: list[i]['nombre'],
                                  cantidad: list[i]['porciones'],
                                  unidadesCantidad: list[i]['unidadesMedida'],
                                  ingredientes: list[i]['ingredientes'],
                                  descripcion: list[i]['descripcion'],
                                  pasos: list[i]['pasos'],
                                  nombreUsuario: nombreUsuario,
                                  // calorias: list[i]['calorias'],
                                  // grasas: list[i]['grasas'],
                                  // proteinas: list[i]['proteinas'],
                                  // carbohidratos: list[i]['carbohidratos'],
                                  // sodio: list[i]['sodio'] ?? 0.0,
                                  // azucar: list[i]['azucar'] ?? 0.0,
                                  // fibra: list[i]['fibra'] ?? 0.0,
                                  image: list[i]['imagen']),
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
            return SizedBox(
              height: 100.3,
              child: Card(
                color: Colors.white,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: list[i]['imagen'] != null &&
                              list[i]['imagen'] != ""
                          ? FutureBuilder(
                              future: http.head(Uri.parse(list[i]['imagen'])),
                              builder: (BuildContext context,
                                  AsyncSnapshot<http.Response> snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data!.statusCode == 200) {
                                  return FadeInImage.assetNetwork(
                                    placeholder: 'assets/placeholder_image.png',
                                    image: list[i]['imagen'],
                                    height: 90,
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
                          list[i]['nombre'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontFamily: "Open Sans",
                            fontSize: 18.0,
                            // color: Color.fromARGB(255, 255, 255, 255),
                            color: Colors.orange,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        //color: Color.fromARGB(255, 255, 255, 255),
                        color: Colors.orange,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MostrarReceta(
                                  name: list[i]['nombre'],
                                  cantidad: list[i]['porciones'],
                                  unidadesCantidad: list[i]['unidadesMedida'],
                                  ingredientes: list[i]['ingredientes'],
                                  descripcion: list[i]['descripcion'],
                                  pasos: list[i]['pasos'],
                                  nombreUsuario: nombreUsuario,
                                  // calorias: list[i]['calorias'],
                                  // grasas: list[i]['grasas'],
                                  // proteinas: list[i]['proteinas'],
                                  // carbohidratos: list[i]['carbohidratos'],
                                  // sodio: list[i]['sodio'] ?? 0.0,
                                  // azucar: list[i]['azucar'] ?? 0.0,
                                  // fibra: list[i]['fibra'] ?? 0.0,
                                  image: list[i]['imagen']),
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
            return SizedBox(
              height: 100.3,
              child: Card(
                color: Colors.orange[200],
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: list[i]['imagen'] != null &&
                              list[i]['imagen'] != ""
                          ? FutureBuilder(
                              future: http.head(Uri.parse(list[i]['imagen'])),
                              builder: (BuildContext context,
                                  AsyncSnapshot<http.Response> snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data!.statusCode == 200) {
                                  return FadeInImage.assetNetwork(
                                    placeholder: 'assets/placeholder_image.png',
                                    image: list[i]['imagen'],
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
                        color: Colors.orange,
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
                          list[i]['nombre'].toString(),
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
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        //color: Color.fromARGB(255, 255, 255, 255),
                        //color: Colors.orange,
                        focusColor:Colors.black,
                        
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MostrarReceta(
                                  name: list[i]['nombre'],
                                  cantidad: list[i]['porciones'],
                                  unidadesCantidad: list[i]['unidadesMedida'],
                                  ingredientes: list[i]['ingredientes'],
                                  descripcion: list[i]['descripcion'],
                                  pasos: list[i]['pasos'],
                                  nombreUsuario: nombreUsuario,
                                  // calorias: list[i]['calorias'],
                                  // grasas: list[i]['grasas'],
                                  // proteinas: list[i]['proteinas'],
                                  // carbohidratos: list[i]['carbohidratos'],
                                  // sodio: list[i]['sodio'] ?? 0.0,
                                  // azucar: list[i]['azucar'] ?? 0.0,
                                  // fibra: list[i]['fibra'] ?? 0.0,
                                  image: list[i]['imagen']),
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
    });
  }
}
