import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/views/CrearUsuario.dart';
import 'package:my_app/views/listviewFood.dart';
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
            ])
          ],
        ),
      ),
    );
  }
}
