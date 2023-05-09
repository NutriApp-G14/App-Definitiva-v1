import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:my_app/controllers/registroHelpers.dart';
import 'package:my_app/model/Alimento.dart';
import 'package:my_app/views/listviewFood.dart';
import 'package:my_app/views/mostrarFood.dart';
import 'package:my_app/views/mostrarReceta.dart';

// //final urlConexion1 = 'http://35.241.179.64:8080';
// final urlConexion1 = 'http://34.77.252.254:8080';
// //final urlConexion1 = 'http://35.189.241.218:8080';

class TarjetaReceta extends StatefulWidget {
  final int id;
  final String imageUrl;
  final String nombreUsuario;
  final int cantidad;
  final String unidadesCantidad;
  final String name;
  final String descripcion;
  final List pasos;
  final List ingredientes;
  final String token;

  const TarjetaReceta({
    required this.imageUrl,
    required this.id,
    required this.nombreUsuario,
    required this.cantidad,
    required this.unidadesCantidad,
    required this.name,
    required this.descripcion,
    required this.pasos,
    required this.ingredientes,
    required this.token,
  });

  @override
  _TarjetaReceta createState() => _TarjetaReceta();
}

class _TarjetaReceta extends State<TarjetaReceta> {
  Future<void> deleteData(int id) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);
    final response = await ioClient
      ..delete(Uri.parse("$urlConection/recipes/$id"),
          headers: {"Authorization": widget.token});
    _refreshListAlimentos();
  }

  _refreshListAlimentos() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListAlimentos(
            nombreUsuario: widget.nombreUsuario, token: widget.token),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MostrarReceta(
                        name: widget.name,
                        cantidad: widget.cantidad,
                        unidadesCantidad: widget.unidadesCantidad,
                        pasos: widget.pasos,
                        descripcion: widget.descripcion,
                        ingredientes: widget.ingredientes,
                        image: widget.imageUrl,
                        nombreUsuario: widget.nombreUsuario,
                        token: widget.token)));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topRight,
                heightFactor: 0.4,
                child: IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.delete_outline),
                  color: Colors.black,
                  onPressed: () {
                    deleteData(widget.id);
                    print("presionado");
                  },
                ),
              ),
              SizedBox(height: 5),
              widget.imageUrl != null && widget.imageUrl != ""
                  ? Expanded(
                      child: FutureBuilder(
                      future: http.head(Uri.parse(widget.imageUrl)),
                      builder: (BuildContext context,
                          AsyncSnapshot<http.Response> snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data!.statusCode == 200) {
                          return Padding(
                              padding: EdgeInsets.fromLTRB(12, 0, 32, 0),
                              child: SizedBox(
                                height: 90,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/placeholder_image.png',
                                    image: widget.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ));
                        } else {
                          return Icon(
                            Icons.fastfood,
                            color: Color.fromARGB(221, 255, 181, 71),
                            size: 90,
                          );
                        }
                      },
                    ))
                  : Icon(
                      Icons.fastfood,
                      color: Color.fromARGB(221, 255, 181, 71),
                      size: 90,
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name.length > 19
                          ? '${widget.name.substring(0, 20)}...'
                          : widget.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                    ),
                    // Text(
                    //   " ${widget.codigoDeBarras}",
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     fontSize: 10.0,
                    //   ),
                    //),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
