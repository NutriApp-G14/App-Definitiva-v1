import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:http/http.dart' as http;
import 'listviewFood.dart';

class AddAlimentoPage extends StatefulWidget {
  final String nombreUsuario;
  const AddAlimentoPage({required this.nombreUsuario});

  @override
  _AddAlimentoPageState createState() => _AddAlimentoPageState();
}

class _AddAlimentoPageState extends State<AddAlimentoPage> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController caloriasController = TextEditingController();
  final TextEditingController grasasController = TextEditingController();
  final TextEditingController proteinasController = TextEditingController();
  final TextEditingController carbohidratosController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController codigoDeBarrasController =
      TextEditingController();
  final TextEditingController alergenosController = TextEditingController();

  Future<http.Response> addAlimento(
      String nameController,
      double cantidadController,
      String unidadesCantidadController,
      double caloriasController,
      double grasasController,
      double proteinasController,
      double carbohidratosController,
      String imageController,
      String nombreUsuarioController,
      String codigoDeBarras) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    var url = "${urlConexion}/foods/add";
    Map data = {
      'name': nameController,
      'unidadesCantidad': unidadesCantidadController,
      'cantidad': '$cantidadController',
      'calorias': '$caloriasController',
      'grasas': '$grasasController',
      'proteinas': '$proteinasController',
      'carbohidratos': '$carbohidratosController',
      'image': imageController,
      'nombreUsuario': nombreUsuarioController,
      'codigoDeBarras': codigoDeBarrasController
    };
    var body = json.encode(data);
    var response = await ioClient.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");

    Navigator.pop(context);
    _navigateListAlimento(context);
    return response;
  }

  var _unidadSeleccionadas;

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
          title: Text('Añadir alimento'),
        ),
        body: Container(
            child: ListView(
          padding: const EdgeInsets.only(
              top: 12, left: 12.0, right: 12.0, bottom: 12.0),
          children: [
            Container(
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Product name',
                  icon: new Icon(Icons.food_bank),
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: cantidadController,
                decoration: InputDecoration(
                  labelText: 'Cantidad',
                  hintText: 'Product cantidad',
                  icon: new Icon(Icons.food_bank),
                ),
              ),
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Unidades de medición',
                icon: new Icon(Icons.food_bank),
              ),
              value: _unidadSeleccionadas,
              onChanged: (value) {
                setState(() {
                  _unidadSeleccionadas = value;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'kg',
                  child: Text('Kilogramos (kg)'),
                ),
                DropdownMenuItem(
                  value: 'g',
                  child: Text('Gramos (g)'),
                ),
                DropdownMenuItem(
                  value: 'l',
                  child: Text('Litros (l)'),
                ),
                DropdownMenuItem(
                  value: 'ml',
                  child: Text('Mililitros (ml)'),
                ),
                DropdownMenuItem(
                  value: 'oz',
                  child: Text('Onzas (oz)'),
                ),
                DropdownMenuItem(
                  value: 'lb',
                  child: Text('Libras (lb)'),
                ),
              ],
            ),
            Container(
              child: TextField(
                controller: caloriasController,
                decoration: InputDecoration(
                  labelText: 'Calorias',
                  hintText: 'Product calorias',
                  icon: new Icon(Icons.food_bank),
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: grasasController,
                decoration: InputDecoration(
                  labelText: 'Grasas',
                  hintText: 'Product grasas',
                  icon: new Icon(Icons.food_bank),
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: carbohidratosController,
                decoration: InputDecoration(
                  labelText: 'Carbohidratos',
                  hintText: 'Product carbohidratos',
                  icon: new Icon(Icons.food_bank),
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: proteinasController,
                decoration: InputDecoration(
                  labelText: 'Proteinas',
                  hintText: 'Product proteinas',
                  icon: new Icon(Icons.food_bank),
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: imageController,
                decoration: InputDecoration(
                  labelText: 'Image Link',
                  hintText: 'Link de la imagen del alimento',
                  icon: new Icon(Icons.link),
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: codigoDeBarrasController,
                decoration: InputDecoration(
                  labelText: 'Codigo de Barras',
                  hintText: 'Codigo de barras del producto',
                  icon: new Icon(Icons.scanner),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Column(children: [
              Center(
                  child: SizedBox(
                height: 40,
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    bool exists = await dataBaseHelper
                        .usuarioExists(codigoDeBarrasController.text.trim());
                    if (exists) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Codigo de barras existente'),
                          content: Text('Ese alimento ya está añadido'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cerrar'),
                            ),
                          ],
                        ),
                      );
                      return;
                    } else {
                      addAlimento(
                        nameController.text.trim(),
                        double.parse(cantidadController.text.trim()),
                        _unidadSeleccionadas,
                        double.parse(caloriasController.text.trim()),
                        double.parse(grasasController.text.trim()),
                        double.parse(proteinasController.text.trim()),
                        double.parse(carbohidratosController.text.trim()),
                        imageController.text.trim(),
                        widget.nombreUsuario.trim(),
                        codigoDeBarrasController.text.trim() ?? "",
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.orange,
                    foregroundColor: Color.fromARGB(255, 0, 0, 0),
                  ),
                  child: const Text('Añadir'),
                ),
              ))
            ])
          ],
        )));
  }
}
