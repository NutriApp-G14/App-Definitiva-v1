import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/views/mostrarFood.dart';

class TarjetaAlimento extends StatefulWidget {
  final String nombreUsuario;
  final String nombreAlimento;
  final String imageUrl;
  final List<String> scoreTitles;
  final List<String> scoreImages;
  final int codigoDeBarras;
  final double cantidad;

  const TarjetaAlimento(
      {required this.nombreUsuario, required this.cantidad, required this.codigoDeBarras, required this.imageUrl, required this.nombreAlimento, required this.scoreImages, required this.scoreTitles});

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
             
              Image.network(
                widget.imageUrl,
                height : 115,
                width: 115,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nombreAlimento,
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
                                   placeholderBuilder: (BuildContext context) => CircularProgressIndicator(),
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

// @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.25),
//             blurRadius: 4.0,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         borderRadius: BorderRadius.circular(8.0),
//         color: Colors.white,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(8.0),
//           onTap: () {
//             // Handle card tap
//           },
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Image.network(
//                 imageUrl,
//                 height: 150,
//                 fit: BoxFit.cover,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                     SizedBox(height: 4.0),
//                     Row(
//                       children: [
//                         for (int i = 0; i < scoreTitles.length; i++)
//                           Padding(
//                             padding: const EdgeInsets.only(right: 8.0),
//                             child: Tooltip(
//                               message: scoreTitles[i],
//                               child: Image.network(
//                                 scoreImages[i],
//                                 height: 20.0,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     SizedBox(height: 4.0),
//                     Text(
//                       barcode,
//                       style: TextStyle(
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }