import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_app/controllers/registroHelpers.dart';
import 'package:my_app/model/Alimento.dart';
import 'package:my_app/views/listviewfood.dart';
import 'package:my_app/views/mostrarFood.dart';

class TarjetaBuscador extends StatefulWidget {
  final int id;
  final String nombreUsuario;
  final String nombreAlimento;
  final String imageUrl;
  final List<String> scoreTitles;
  final List<String> scoreImages;
  final String codigoDeBarras;
  final double cantidad;
  final double calorias;
  final double grasas;
  final double proteinas;
  final double carbohidratos;
  final double sodio;
  final double azucar;
  final double fibra;
  final String unidadesCantidad;
  final bool anadirRegistro;
  final String tipoDeComida;
  final List alergenos;

  const TarjetaBuscador(
      {required this.nombreUsuario,
      required this.cantidad,
      required this.codigoDeBarras,
      required this.imageUrl,
      required this.nombreAlimento,
      required this.scoreImages,
      required this.scoreTitles,
      required this.id,
      required this.calorias,
      required this.grasas,
      required this.proteinas,
      required this.carbohidratos,
      required this.sodio,
      required this.azucar,
      required this.fibra,
      required this.unidadesCantidad,
      required this.anadirRegistro,
      required this.alergenos,
      required this.tipoDeComida});

  @override
  _TarjetaBuscadorState createState() => _TarjetaBuscadorState();
}

class _TarjetaBuscadorState extends State<TarjetaBuscador> {
  RegistroHelper registrohelper = RegistroHelper();
  DateTime now = DateTime.now();
  late String formattedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
  }

  List<Alimento> alimentoRegistro = [];
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
            List<String> listaAlergenos = widget.alergenos.map((elemento) => elemento.toString()).toList();
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
                          alergenos: listaAlergenos,
                          id: 0,
                        )));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              widget.imageUrl != null && widget.imageUrl != ""
                  ? Flexible(
                      child: FutureBuilder(
                        future: http.head(Uri.parse(widget.imageUrl)),
                        builder: (BuildContext context,
                            AsyncSnapshot<http.Response> snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data!.statusCode == 200) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: SizedBox(
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/placeholder_image.png',
                                    image: widget.imageUrl,
                                    fit: BoxFit
                                        .cover, // Ajustar la imagen para cubrir todo el espacio disponible
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Icon(
                              Icons.fastfood,
                              color: Color.fromARGB(221, 255, 181, 71),
                              size: 100,
                            );
                          }
                        },
                      ),
                    )
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
                      widget.nombreAlimento.length > 13
                          ? '${widget.nombreAlimento.substring(0, 11)}...'
                          : widget.nombreAlimento,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                      ),
                    ),
                    Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 4.0),
                            Row(
                              children: [
                                for (int i = 0;
                                    i < widget.scoreTitles.length;
                                    i++)
                                  // Verifica si el enlace de la imagen es válido
                                  widget.scoreImages[i] != null &&
                                          widget.scoreImages[i] != ""
                                      ?
                                      //if (Uri.tryParse(widget.scoreImages[i]) !=
                                      //null)
                                      // El enlace es válido, muestra la imagen
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Tooltip(
                                            message: widget.scoreTitles[i],
                                            child: Hero(
                                              tag:
                                                  'score_image_${Random().nextInt(5000) + 1}',
                                              child: SvgPicture.network(
                                                widget.scoreImages[i],
                                                placeholderBuilder:
                                                    (BuildContext context) =>
                                                        SizedBox(
                                                  height: 20.0,
                                                ),
                                                height: 20.0,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container()
                              ],
                            ),
                            SizedBox(height: 4.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    " ${widget.codigoDeBarras}",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.orange,
                            ),
                            onPressed: () {
                              alimentoRegistro = [];
                              alimentoRegistro.add(Alimento(
                                  name: widget.nombreAlimento,
                                  cantidad: widget.cantidad,
                                  unidadesCantidad: widget.unidadesCantidad,
                                  calorias: widget.calorias,
                                  grasas: widget.grasas,
                                  proteinas: widget.proteinas,
                                  carbohidratos: widget.carbohidratos,
                                  azucar: widget.azucar,
                                  fibra: widget.fibra,
                                  sodio: widget.sodio,
                                  image: widget.imageUrl));
                              if (widget.anadirRegistro) {
                                registrohelper.addRegistro(
                                    widget.codigoDeBarras.trim().toLowerCase(),
                                    widget.cantidad,
                                    widget.nombreUsuario.trim().toLowerCase(),
                                    formattedDate.trim().toLowerCase(),
                                    widget.tipoDeComida.trim().toLowerCase(),
                                    widget.nombreAlimento.trim(),
                                    alimentoRegistro);
                              } else {
                                insertarAlimento(
                                    widget.codigoDeBarras,
                                    widget.nombreAlimento,
                                    widget.calorias,
                                    widget.cantidad,
                                    widget.unidadesCantidad,
                                    widget.carbohidratos,
                                    widget.grasas,
                                    widget.proteinas,
                                    widget.sodio,
                                    widget.azucar,
                                    widget.fibra,
                                    widget.imageUrl);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ListAlimentos(
                                            nombreUsuario:
                                                widget.nombreUsuario)));
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<http.Response> insertarAlimento(
      String codigoDeBarras,
      String name,
      double calorias,
      double cantidad,
      String unidadesCantidad,
      double carbohidratos,
      double grasas,
      double proteinas,
      double sodio,
      double azucar,
      double fibra,
      String image) async {
    final response = await http.post(
      Uri.parse('${urlConexion}/foods/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'calorias': calorias,
        'cantidad': cantidad,
        'unidadesCantidad': unidadesCantidad,
        'carbohidratos': carbohidratos,
        'grasas': grasas,
        'fibra': fibra,
        'proteinas': proteinas,
        'sodio': sodio,
        'azucar': azucar,
        'image': image,
        'nombreUsuario': widget.nombreUsuario,
        'codigoDeBarras': codigoDeBarras
      }),
    );

    return response;
  }

  _navigateListAlimento(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ListAlimentos(nombreUsuario: widget.nombreUsuario)));
  }
}
