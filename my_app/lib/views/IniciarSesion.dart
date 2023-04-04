import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/views/CrearUsuario.dart';
import 'package:my_app/views/listviewfood.dart';
import 'package:http/http.dart' as http;

import '../model/Usuario.dart';

class IniciarSesionPage extends StatefulWidget {
  @override
  _IniciarSesionPageState createState() => _IniciarSesionPageState();
}

class _IniciarSesionPageState extends State<IniciarSesionPage> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController nombreUsuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


   Future<Usuario?> getUsuario(String nombreUsuario, String password) async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/users/$nombreUsuario'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final usuario = Usuario.fromJson(json);
      if (usuario.password == password) {
        return usuario;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
        automaticallyImplyLeading:
            false, // esto evita que aparezca el botón de volver
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            TextField(
              controller: nombreUsuarioController,
              decoration: InputDecoration(
                labelText: 'Nombre de usuario',
                hintText: 'Introduzca su Nombre de usuario',
                icon: Icon(Icons.email),
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Introduzca su password',
                icon: Icon(Icons.password),
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton.icon(
              onPressed: () async {
                if (nombreUsuarioController.text.trim().isEmpty ||
                    passwordController.text.trim().isEmpty ) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Campos incompletos'),
                      content: Text('Por favor completa la información.'),
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
                }
                // Lógica para iniciar sesión

                final usuario =
                    await getUsuario(nombreUsuarioController.text.trim(), passwordController.text.trim());
                if (usuario != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListAlimentos(
                            nombreUsuario:
                                nombreUsuarioController.text.trim())),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Usuario incorrecto'),
                      content: Text('Usuario o contraseña incorrecto'),
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
                }
              },
              icon: Icon(Icons.check),
              label: Text('Iniciar sesión'),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // Lógica para ir a la página de inicio de sesión
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CrearUsuarioPage()),
                );
              },
              child: Text('¿No tienes cuenta? Crea tu propia cuenta!'),
            ),
          ],
        ),
      ),
    );
  }
}
