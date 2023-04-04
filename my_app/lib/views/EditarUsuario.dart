import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/model/Usuario.dart';
import 'package:my_app/views/listviewfood.dart';

class EditarUsuarioPage extends StatefulWidget {
  final String nombreUsuario;
  final String nombre;

  EditarUsuarioPage({
    required this.nombreUsuario,
    required this.nombre,
  });

  @override
  _EditarUsuarioPageState createState() => _EditarUsuarioPageState();
}

class _EditarUsuarioPageState extends State<EditarUsuarioPage> {
  late Future<Usuario> _futureUsuario;

  final dataBaseHelper = DataBaseHelper();
  final nombreController = TextEditingController();
  final nombreUsuarioController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureUsuario = getUsuarioById(widget.nombreUsuario);
  }

  Future<Usuario> getUsuarioById(String nombreUsuario) async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/users/$nombreUsuario'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Usuario.fromJson(jsonData);
    } else {
      throw Exception('Error al cargar el usuario');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<Usuario>(
          future: _futureUsuario,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error al cargar el usuario'),
              );
            } else {
              final usuario = snapshot.data!;
              nombreUsuarioController.text = usuario.nombreUsuario;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Nombre de usuario',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    usuario.nombreUsuario,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nombre',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      hintText: 'Ingresa tu nombre',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Ingresa tu password',
                    ),
                    obscureText: true,
                    textAlignVertical: TextAlignVertical.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      dataBaseHelper.updateUsuario(
                        nombreController.text.trim(),
                        usuario.nombreUsuario,
                        usuario.password,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListAlimentos(
                            nombreUsuario: usuario.nombreUsuario,
                          ),
                        ),
                      );
                    },
                    child: Text('Guardar cambios'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
