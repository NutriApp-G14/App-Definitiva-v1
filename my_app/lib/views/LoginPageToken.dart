import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/io_client.dart';
import 'package:my_app/views/IniciarSesion.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String token = "";

  Future<void> login() async {
    HttpClient httpClient = new HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);
    var nombreUsuario = usernameController.text;
    final response = await ioClient.post(
      Uri.parse('https://localhost:8443/users/login/$nombreUsuario'),
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
        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IniciarSesionPage(
                                   )),
                          );

    } else {
      throw Exception('Failed to log in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                login();
              },
              child: Text('Log in'),
            ),
            Text('Token: $token'),
          ],
        ),
      ),
    );
  }
}
