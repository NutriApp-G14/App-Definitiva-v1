import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:my_app/controllers/registroHelpers.dart';
import 'package:my_app/views/listviewFood.dart';
import 'package:my_app/views/mostrarFood.dart';

// //final urlConexion1 = 'http://35.241.179.64:8080';
// final urlConexion1 = 'http://34.77.252.254:8080';
// //final urlConexion1 = 'http://35.189.241.218:8080';

class TarjetaMisAlimento extends StatefulWidget {
  final int id;
  final String nombreAlimento;
  final String imageUrl;
  final String codigoDeBarras;
  final String nombreUsuario;
  final double cantidad;
  final double calorias;
  final double grasas;
  final double proteinas;
  final double carbohidratos;
  final double sodio;
  final double azucar;
  final double fibra;
  final String unidadesCantidad;
  final List<String> alergenos;

  const TarjetaMisAlimento({
    required this.codigoDeBarras,
    required this.imageUrl,
    required this.nombreAlimento,
    required this.id,
    required this.nombreUsuario,
    required this.cantidad,
    required this.calorias,
    required this.grasas,
    required this.proteinas,
    required this.carbohidratos,
    required this.sodio,
    required this.azucar,
    required this.fibra,
    required this.unidadesCantidad,
    required this.alergenos,
  });

  @override
  _TarjetaMisAlimentoState createState() => _TarjetaMisAlimentoState();
}

class _TarjetaMisAlimentoState extends State<TarjetaMisAlimento> {
  Future<void> deleteData(int id) async {
    HttpClient httpClient = new HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  IOClient ioClient = IOClient(httpClient);
    final response = await ioClient..delete(
      Uri.parse("$urlConection/foods/$id"),
    );
    _refreshListAlimentos();
  }

  _refreshListAlimentos() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ListAlimentos(nombreUsuario: widget.nombreUsuario),
      ),
    );
  }

  _navigateAlimentos(BuildContext context) async {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ListAlimentos(nombreUsuario: widget.nombreUsuario),
        transitionDuration: Duration(seconds: 0),
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
                    builder: (context) => MostrarFood(
                          name: widget.nombreAlimento,
                          cantidad: widget.cantidad,
                          unidadesCantidad: widget.unidadesCantidad,
                          calorias: widget.calorias,
                          grasas: widget.grasas,
                          proteinas: widget.proteinas,
                          carbohidratos: widget.carbohidratos,
                          sodio: widget.sodio,
                          azucar: widget.azucar,
                          fibra: widget.fibra,
                          image: widget.imageUrl,
                          codigoDeBarras: widget.codigoDeBarras,
                          nombreUsuario: widget.nombreUsuario,
                          id: 0,
                          alergenos: widget.alergenos,
                          showBotonAlimentos: false,
                          showBotonRegistro: true,
                          showBotonGuardar: false,
                        )));
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
                            size: 100,
                          );
                        }
                      },
                    ))
                  : Icon(
                      Icons.fastfood,
                      color: Color.fromARGB(221, 255, 181, 71),
                      size: 100,
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nombreAlimento.length > 19
                          ? '${widget.nombreAlimento.substring(0, 20)}...'
                          : widget.nombreAlimento,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      " ${widget.codigoDeBarras}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                      ),
                    ),
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
