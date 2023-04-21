import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/model/NavBar.dart';
import 'package:my_app/model/TipoComidaCard.dart';


class RegistroComidasPage extends StatefulWidget {
  final String nombreUsuario;

  RegistroComidasPage({
    required this.nombreUsuario,
  });

  @override
  _RegistroComidasPageState createState() => _RegistroComidasPageState();
}

class _RegistroComidasPageState extends State<RegistroComidasPage> {
   @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(52),
            child: NutriAppBar(nombreUsuario: widget.nombreUsuario),
          ),
        ),
        body: Column(children: [
          TipoComidaCard( nombreUsuario: widget.nombreUsuario, tipoDeComida:"Desayuno"),
          TipoComidaCard( nombreUsuario: widget.nombreUsuario, tipoDeComida:"Almuerzo"),
          TipoComidaCard( nombreUsuario: widget.nombreUsuario, tipoDeComida:"Comida"),
          TipoComidaCard( nombreUsuario: widget.nombreUsuario, tipoDeComida:"Merienda"),
          TipoComidaCard( nombreUsuario: widget.nombreUsuario, tipoDeComida:"Cena"),
          
        ],) 
      );
    
     }
  
}