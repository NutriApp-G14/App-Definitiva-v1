import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MostrarFood extends StatelessWidget {
  final String name;
  final double cantidad;
  final String unidadesCantidad;
  final double calorias;
  final double grasas;
  final double proteinas;
  final double carbohidratos;
  final String image;

  const MostrarFood({
    required this.name,
    required this.cantidad,
    required this.unidadesCantidad,
    required this.calorias,
    required this.grasas,
    required this.proteinas,
    required this.carbohidratos,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8.0,
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.orangeAccent),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    title: Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    trailing: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  title: Text(
                    'Cantidad: $cantidad $unidadesCantidad',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  title: Text(
                    'Calorías: $calorias | Grasas: $grasas | Proteínas: $proteinas | Carbohidratos: $carbohidratos',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                FutureBuilder<http.Response>(
                  future: http.get(Uri.parse(image)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData &&
                        snapshot.data!.statusCode == 200 &&
                        ['http', 'https']
                            .contains(Uri.parse(image).scheme)) {
                      return FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder_image.png',
                        image: image,
                        fit: BoxFit.cover,
                      );
                    } else {
                      return Image.asset(
                        'assets/placeholder_image.png',
                        fit: BoxFit.cover,


                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
