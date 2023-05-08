import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/views/IniciarSesion.dart';

import 'dart:core';
import 'package:http/io_client.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;


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

    var usuario = await dataBaseHelper.getUsuarioByNombreUsuarioParaLogin(nombreusuario);

    if (usuario == null){
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Usuario no encontrado'),
          content: const Text('Por favor verifica que has introducido el nombre de usuario correcto'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
               
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    return; 

    }




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

    var response = await dataBaseHelper.updatePassword(nombreusuario, newPass);


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Correo electrónico enviado'),
          content: Text('Se ha enviado un correo electrónico con una nueva contraseña.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IniciarSesionPage(),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    print('Error al enviar el correo electrónico: $e');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Correo electrónico no válido'),
          content: Text('Por favor introduzca otro correo electrónico'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
            
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


//   void sendPasswordRecoveryEmail(String email, String nombreusuario) async {
//   final smtpServer = gmail('gruponutriapp@gmail.com', 'gevelldiwglrnedz');


//   var random = Random();
//   var newPass = random.nextInt(100000000).toString();

//   final message = Message()
//     ..from = Address('gruponutriapp@gmail.com', 'NutriApp Team')
//     ..recipients.add(email)
//     ..subject = 'Recuperación de contraseña'
//     ..text = 'Aquí está tu nueva contraseña: $newPass';

//   try {
//     await send(message, smtpServer);
//     print('Correo electrónico enviado correctamente');

//     dataBaseHelper.updatePassword(nombreusuario, newPass);

//     Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => IniciarSesionPage()));
              
//   } catch (e) {
//     print('Error al enviar el correo electrónico: $e');
//   }
// }

}
