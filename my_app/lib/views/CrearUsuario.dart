import 'package:flutter/material.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/views/IniciarSesion.dart';
import 'package:my_app/views/listviewfood.dart';

class CrearUsuarioPage extends StatefulWidget {
  @override
  _CrearUsuarioPageState createState() => _CrearUsuarioPageState();
}

class _CrearUsuarioPageState extends State<CrearUsuarioPage> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController nombreUsuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Usuario'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                hintText: 'Introduzca su Nombre completo',
                icon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: nombreUsuarioController,
              decoration: InputDecoration(
                labelText: 'Nombre de usuario',
                hintText: 'Introduzca su Nombre de Usuario',
                icon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'password',
                hintText: 'Introduzca su password',
                icon: Icon(Icons.lock),
              ),
              obscureText: true,
            textAlignVertical: TextAlignVertical.center,
            ),
            SizedBox(height: 32.0),
            ElevatedButton.icon(
              onPressed: () async {
                if (nombreUsuarioController.text.trim().isEmpty ||
                    nombreController.text.trim().isEmpty ||
                    passwordController.text.trim().isEmpty) {
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
                bool exists = await dataBaseHelper.usuarioExists(nombreUsuarioController.text.trim());
                if (exists) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Nombre de usuario existente'),
                      content: Text(
                          'El nombre de usuario ya existe. Por favor elige otro.'),
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

                  dataBaseHelper.addUsuario(

                    nombreController.text.trim(),
                    nombreUsuarioController.text.trim(),
                    passwordController.text.trim()
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListAlimentos(
                            nombreUsuario:
                                nombreUsuarioController.text.trim())),
                  );
                }
              },
              icon: Icon(Icons.check),
              label: Text('Crear cuenta'),
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
                    MaterialPageRoute(
                        builder: (context) => IniciarSesionPage()));
              },
              child: Text('¿Ya tienes cuenta? Inicia sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
