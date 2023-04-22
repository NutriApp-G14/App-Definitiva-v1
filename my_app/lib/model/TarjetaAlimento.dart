import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/views/mostrarFood.dart';

class TarjetaAlimento extends StatefulWidget {
  final int id;
  final String nombreUsuario;
  final String nombreAlimento;
  final String imageUrl;
  final List<String> scoreTitles;
  final List<String> scoreImages;
  final String codigoDeBarras;
  final double cantidad;

  const TarjetaAlimento(
      {required this.nombreUsuario,
      required this.cantidad,
      required this.codigoDeBarras,
      required this.imageUrl,
      required this.nombreAlimento,
      required this.scoreImages,
      required this.scoreTitles, required this.id});

  @override
  _TarjetaAlimentoState createState() => _TarjetaAlimentoState();
}

class _TarjetaAlimentoState extends State<TarjetaAlimento> {
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
            //MostrarFood(name: name, cantidad: cantidad, unidadesCantidad: unidadesCantidad, calorias: calorias, grasas: grasas, proteinas: proteinas, carbohidratos: carbohidratos, sodio: sodio, azucar: azucar, fibra: fibra, image: image)
          },
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    widget.imageUrl != null && widget.imageUrl != ""
        ? Flexible(
            child: FutureBuilder(
              future: http.head(Uri.parse(widget.imageUrl)),
              builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
                if (snapshot.hasData && snapshot.data!.statusCode == 200) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: SizedBox(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder_image.png',
                          image: widget.imageUrl,
                          fit: BoxFit.cover, // Ajustar la imagen para cubrir todo el espacio disponible
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
              widget.nombreAlimento.length > 20
                  ? '${widget.nombreAlimento.substring(0, 20)}...'
                  : widget.nombreAlimento,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 4.0),
            Row(
              children: [
                for (int i = 0; i < widget.scoreTitles.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Tooltip(
                      message: widget.scoreTitles[i],
                      child: SvgPicture.network(
                        widget.scoreImages[i],
                        placeholderBuilder: (BuildContext context) => SizedBox(
                          height: 20.0,
                        ),
                        height: 20.0,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4.0),
            Text(
              " ${widget.codigoDeBarras}",
              style: TextStyle(
                color: Colors.grey,
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
