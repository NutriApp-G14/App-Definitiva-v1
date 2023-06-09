import 'package:flutter/material.dart';
import 'package:my_app/views/AddRecetasPage.dart';
import 'package:my_app/views/CrearUsuario.dart';
import 'package:my_app/views/Estadisticas.dart';
import 'package:my_app/views/IniciarSesion.dart';
import 'package:my_app/views/LoginPageToken.dart';
//import 'package:my_app/views/NuevoBuscador.dart';
import 'package:my_app/views/listviewFood.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nutri',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IniciarSesionPage(),
    );
  }
}
