import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/controllers/registroHelpers.dart';
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
      required this.scoreTitles, 
      required this.id});

  @override
  _TarjetaAlimentoState createState() => _TarjetaAlimentoState();
}

class _TarjetaAlimentoState extends State<TarjetaAlimento> {
  RegistroHelper dataBaseHelper = RegistroHelper();
  late List<dynamic> _alimento;

  // Agregar una variable para almacenar los datos obtenidos del Future
  late Future<List<dynamic>> _alimentoFuture;

  // Llamar al método una sola vez antes de construir la pantalla
  @override
  void initState() {
    super.initState();
    _alimentoFuture = searchAndDisplayFoodNuevaAPI(widget.codigoDeBarras);
    
  }


    Future<void> deleteData(int id) async {
    final response = await http.delete(
      Uri.parse("$urlConexion1/foods/$id"),
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
print(_alimentoFuture);
              // alimento = await 

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => MostrarFood(
              //             name: widget.nombreAlimento,
              //             cantidad: widget.cantidad,
              //             unidadesCantidad: widget.unidadesCantidad,
              //             calorias: widget.calorias,
              //             grasas: widget.grasas,
              //             proteinas: widget.proteinas,
              //             carbohidratos: widget.carbohidratos,
              //             sodio: widget.sodio,
              //             azucar: widget.azucar,
              //             fibra: widget.fibra,
              //             image: widget.imageUrl,
              //             codigoDeBarras: widget.codigoDeBarras,
              //             nombreUsuario: widget.nombreUsuario,
              //             id: 0,
              //           ))); 
            
            //MostrarFood(name: name, cantidad: cantidad, unidadesCantidad: unidadesCantidad, calorias: calorias, grasas: grasas, proteinas: proteinas, carbohidratos: carbohidratos, sodio: sodio, azucar: azucar, fibra: fibra, image: image)
          },
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
      Align(
                alignment: Alignment.topRight,
                heightFactor: 0.2,
                child: IconButton(
                  icon: Icon(Icons.delete_outline),
                  color: Colors.black,
                  onPressed: () {
                    deleteData(widget.id);
                  },
                ),
              ),
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
                          fit: BoxFit.fitHeight, // Ajustar la imagen para cubrir todo el espacio disponible
                        ),
                      ),
                    ),
                  );
                } else {
                  return Flexible(
                    child: Icon(
                    Icons.fastfood,
                    color: Color.fromARGB(221, 255, 181, 71),
                    )
                  );
                }
              },
            ),
          )
        :        Flexible(
                    child: Icon(
                    Icons.fastfood,
                    color: Color.fromARGB(221, 255, 181, 71),
                    )
                  ),
     Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.nombreAlimento.length > 20
                  ? '${widget.nombreAlimento.substring(0, 20)}...'
                  : widget.nombreAlimento,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 2.0),
            Row(
              children: [
                for (int i = 0; i < widget.scoreTitles.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Tooltip(
                      message: widget.scoreTitles[i],
                      child: SvgPicture.network(
                        height: 20,
                        widget.scoreImages[i],
                        placeholderBuilder: (BuildContext context) => CircularProgressIndicator.adaptive( )
                      ),
                    ),) 
                  
              ],
            ),
            SizedBox(height: 2.0),
            Text(
              " ${widget.codigoDeBarras}",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 8.0
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

  Future<List<dynamic>> searchAndDisplayFoodNuevaAPI(
      String codigoDeBarras) async {
    var url =
        'https://world.openfoodfacts.org/cgi/search.pl?code=$codigoDeBarras&search_simple=1&action=process&json=true';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var alimento = body['products'].toList();
       setState(() => _alimentoFuture = alimento);
      return alimento;
     
    } else {
      print('Error al realizar la búsqueda');
      return [];
    }
  }

}
