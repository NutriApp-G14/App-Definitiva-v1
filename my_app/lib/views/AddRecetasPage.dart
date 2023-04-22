import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/model/Alimento.dart';
import 'package:my_app/views/BuscadorIngredientes.dart';
import 'listviewFood.dart';

class AddRecetasPage extends StatefulWidget {
  final String nombreUsuario;
  const AddRecetasPage({required this.nombreUsuario});

  @override
  _AddRecetasPageState createState() => _AddRecetasPageState();
}

class _AddRecetasPageState extends State<AddRecetasPage> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController porcionesController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController ingredientesController = TextEditingController();
  final TextEditingController pasosController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController nombreUsuarioController = TextEditingController();
  List<String> _steps = [];
  List<Alimento> _ingredientes = [];
  var _unidadSeleccionadas;
  List<Alimento> ingredientes = [];
  _navigateListAlimento(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ListAlimentos(nombreUsuario: widget.nombreUsuario)));
  }

  Future<http.Response> addReceta(
      String nombre,
      int porciones,
      String unidadesMedida,
      String descripcion,
      List<Alimento> ingredientes,
      List<String> pasos,
      String imagen,
      String nombreUsuario) async {
    var url = "${urlConexion}/recipes/add";
    Map data = {
      'nombre': nombre,
      'porciones': porciones,
      'unidadesMedida': unidadesMedida,
      'descripcion': descripcion,
      'ingredientes': ingredientes.map((e) => e.toJson()).toList(),
      'pasos': pasos,
      'imagen': imagen,
      'nombreUsuario': nombreUsuario,
    };
    var body = json.encode(data);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    Navigator.pop(context);
    _navigateListAlimento(context);
    return response;
  }
  //List<String> _ingredientes = [];

//añadir ingredientes
  Future<void> _showAddStepDialogIngrediente() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        String newIngrediente = "";
        return AlertDialog(
          title: Text('Agregar un nuevo ingrediente'),
          content: BuscadorIngredientes(
              nombreUsuario: widget.nombreUsuario,
              ingredientes: ingredientes,
              onIngredientesUpdated: (listaDeIngredientes) {
                setState(() {
                  ingredientes = listaDeIngredientes;
                });
              }),
          actions: <Widget>[
            TextButton(
              child: Text('Añadir'),
              onPressed: () {},
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //añadirPasos
  Future<void> _showAddStepDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        String newStep = "";
        return AlertDialog(
          title: Text('Agregar un nuevo paso'),
          content: TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Paso',
              hintText: 'Ingrese un paso...',
            ),
            onChanged: (value) {
              newStep = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                setState(() {
                  _steps.add(newStep);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Añadir Receta'),
        ),
        body: Container(
            child: ListView(
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 12.0,
                  right: 12.0,
                  bottom: 12.0,
                ),
                children: [
              Card(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                controller: porcionesController,
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
                                  _unidadSeleccionadas = value.toString();
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
                                controller: descripcionController,
                                decoration: InputDecoration(
                                  labelText: 'Descripción',
                                  hintText: 'Description Receta',
                                  icon: new Icon(Icons.food_bank),
                                ),
                              ),
                            ),
                          ]))),
              Card(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ingredientes',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: ingredientes.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Text(
                                          "${index + 1}. ${ingredientes[index].name}");
                                    },
                                  ),
                                  SizedBox(height: 8),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _showAddStepDialogIngrediente();
                                      },
                                      child: Text("Agregar Ingrediente"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]))),
              Card(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pasos',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _steps.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Text(
                                          "${index + 1}. ${_steps[index]}");
                                    },
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _showAddStepDialog();
                                      },
                                      child: Text("Agregar paso"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]))),
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
              const SizedBox(height: 32.0),
              Column(children: [
                Center(
                    child: SizedBox(
                  height: 40,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      addReceta(
                          nameController.text.trim(),
                          int.parse(porcionesController.text.trim()),
                          _unidadSeleccionadas,
                          descripcionController.text.trim(),
                          ingredientes,
                          _steps,
                          imageController.text.trim(),
                          widget.nombreUsuario);
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
            ])));
  }
}
