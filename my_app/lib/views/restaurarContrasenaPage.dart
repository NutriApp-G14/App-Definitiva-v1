import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/views/IniciarSesion.dart';


class RecuperarContrasenaPage extends StatefulWidget {
  final String nombreUsuario;

  const RecuperarContrasenaPage({required this.nombreUsuario});
  @override
  _RecuperarContrasenaPageState createState() => _RecuperarContrasenaPageState();
}

class _RecuperarContrasenaPageState extends State<RecuperarContrasenaPage> {
  final emailController = TextEditingController();
  final nombreUsuarioController = TextEditingController();

  final dataBaseHelper = DataBaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar contraseña'),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nombre de Usuario',
                hintText: 'Introduce tu nombre de usuario',
              ),
              controller: nombreUsuarioController,
            ),
            
            TextField(
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                hintText: 'Introduce tu correo electrónico',
              ),
              controller: emailController,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              
              onPressed: () {
                sendPasswordRecoveryEmail(emailController.text,nombreUsuarioController.text);
                
              },
              child: Text(
              'Enviar correo electrónico',
              style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        ),),
              

            ),
          ],
        ),
      ),
    );
  }

  void sendPasswordRecoveryEmail(String email, String nombreusuario) async {
  final smtpServer = gmail('gruponutriapp@gmail.com', 'gevelldiwglrnedz');


  var random = Random();
  var newPass = random.nextInt(100000000).toString();

  final message = Message()
    ..from = Address('gruponutriapp@gmail.com', 'NutriApp Team')
    ..recipients.add(email)
    ..subject = 'Recuperación de contraseña'
    ..text = 'Aquí está tu nueva contraseña: $newPass';

  try {
    await send(message, smtpServer);
    print('Correo electrónico enviado correctamente');

    dataBaseHelper.updatePassword(nombreusuario, newPass);

    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IniciarSesionPage()));
              
  } catch (e) {
    print('Error al enviar el correo electrónico: $e');
  }
}

}
