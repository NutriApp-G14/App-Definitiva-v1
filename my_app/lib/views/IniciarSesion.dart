import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/views/CrearUsuario.dart';
import 'package:my_app/views/listviewFood.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/views/restaurarContrasenaPage.dart';

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
  late var token;

  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Iniciar sesión',
          style: TextStyle(color: Colors.white),
        )),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
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
                suffixIcon: IconButton(
                  icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
              ),
              obscureText: obscureText,
              textAlignVertical: TextAlignVertical.center,
            ),
            SizedBox(height: 32.0),
            Column(children: [
              SizedBox(
                  height: 40,
                  width: 150,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (nombreUsuarioController.text.trim().isEmpty ||
                            passwordController.text.trim().isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Campos incompletos'),
                              content:
                                  Text('Por favor completa la información.'),
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
                        final usuario = await dataBaseHelper.getUsuario(
                            nombreUsuarioController.text.trim(),
                            passwordController.text.trim());

                        if (usuario != null) {
                          final token1 = await login();
                          print(token1);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListAlimentos(
                                      nombreUsuario:
                                          nombreUsuarioController.text.trim(),
                                      token: token1)));
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
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Iniciar sesión',
                          style: TextStyle(fontWeight: FontWeight.bold)))),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CrearUsuarioPage()));
                },
                child: Text('¿Aún no eres miembro? Crea una cuenta'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecuperarContrasenaPage(
                              nombreUsuario:
                                  nombreUsuarioController.text.trim())));
                },
                child: Text('¿Has olvidado tu contraseña?'),
              ),
            ])
          ],
        ),
      ),
    );
  }

  Future<String> login() async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);
    var nombreUsuario = nombreUsuarioController.text;
    final response = await ioClient.post(
      Uri.parse('https://35.205.198.163:8443/users/login/$nombreUsuario'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'password': passwordController.text,
      }),
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      token = data['token'];
      print(token);
      return token;
    } else {
      throw Exception('Failed to log in');
    }
  }
}
