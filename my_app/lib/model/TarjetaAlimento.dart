import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:my_app/controllers/registroHelpers.dart';
import 'package:my_app/model/PaginaTipoComida.dart';
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
  final String fecha;
  final List registros;
  final String tipodeComida;

  const TarjetaAlimento(
      {required this.nombreUsuario,
      required this.cantidad,
      required this.codigoDeBarras,
      required this.imageUrl,
      required this.nombreAlimento,
      required this.scoreImages,
      required this.scoreTitles,
      required this.id,
      required this.fecha,
      required this.registros,
      required this.tipodeComida});

  @override
  _TarjetaAlimentoState createState() => _TarjetaAlimentoState();
}

class _TarjetaAlimentoState extends State<TarjetaAlimento> {
  RegistroHelper dataBaseHelper = RegistroHelper();
  // Agregar una variable para almacenar los datos obtenidos del Future

  late var _alimentoFuture;
  var nombreAlimento;
  var cantidad;
  var calorias;
  var carbohidratos;
  var grasas;
  var proteinas;
  var azucar;
  var sodio;
  var codigoDeBarras;
  var fibra;
  var unidadesCantidad;
  var nombreDeUsuario;
  var id;

  @override
  void initState() {
    super.initState();
    _alimentoFuture = searchAndDisplayFoodNuevaAPIList(widget.codigoDeBarras);
    calcularDatos();
  }

  void calcularDatos() async {
    _alimentoFuture =
        await searchAndDisplayFoodNuevaAPIList(widget.codigoDeBarras);
    var alimento = _alimentoFuture[0];
    setState(() {
      nombreAlimento = widget.nombreAlimento;
      cantidad = widget.cantidad;
      unidadesCantidad = "gramos";
      calorias = double.parse(
          alimento[0]['nutriments']['energy-kcal_100g']?.toString() ?? '0.0');
      grasas = double.parse(
          alimento[0]['nutriments']?['fat_100g']?.toString() ?? '0.0');
      proteinas = double.parse(
          alimento[0]['nutriments']?['proteins_100g']?.toString() ?? '0.0');

      carbohidratos = double.parse(
          alimento[0]['nutriments']?['carbohydrates_100g']?.toString() ??
              '0.0');
      sodio = double.parse(
          alimento[0]['nutriments']?['sodium_100g']?.toString() ?? '0.0');
      azucar = double.parse(
          alimento[0]['nutriments']?['sugars_100g']?.toString() ?? '0.0');
      fibra = double.parse(
          alimento[0]['nutriments']?['fiber_100g']?.toString() ?? '0.0');
      codigoDeBarras = widget.codigoDeBarras;
      nombreDeUsuario = widget.nombreUsuario;
      id = widget.id;
    });
  }

  Future<List<dynamic>> searchAndDisplayFoodNuevaAPI(
      String codigoDeBarras) async {
    var url =
        'https://world.openfoodfacts.org/cgi/search.pl?code=$codigoDeBarras&search_simple=1&action=process&json=true';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var alimento = body['products'].toList();
      return alimento;
    } else {
      print('Error al realizar la búsqueda');
      return [];
    }
  }

  // Agregar un nuevo método para llamar al método de búsqueda para varios códigos de barras
  Future<List<dynamic>> searchAndDisplayFoodNuevaAPIList(
      String codigoDeBarras) async {
    var alimentos = [];
    var alimento = await searchAndDisplayFoodNuevaAPI(codigoDeBarras);
    alimentos.add(alimento);
    return alimentos;
  }

  Future<void> deleteReg(int id) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    print(widget.registros);
    final response = await ioClient.delete(
      Uri.parse("$urlConection/registro/reg/$id"),
    );
    setState(() {});
    widget.registros.removeWhere((element) => element['id'] == id);
    print("reg sin el borrado: ${widget.registros}");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaginaTipoComida(
                nombreUsuario: widget.nombreUsuario,
                tipoDeComida: widget.tipodeComida,
                fecha: widget.fecha,
                registros: widget.registros)));
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
            print("calorias : ${calorias}");

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MostrarFood(
                          name: widget.nombreAlimento,
                          cantidad: widget.cantidad,
                          unidadesCantidad: unidadesCantidad,
                          calorias: calorias,
                          grasas: grasas,
                          proteinas: proteinas,
                          carbohidratos: carbohidratos,
                          sodio: sodio,
                          azucar: azucar,
                          fibra: fibra,
                          image: widget.imageUrl,
                          codigoDeBarras: codigoDeBarras,
                          nombreUsuario: nombreDeUsuario,
                          id: 0,
                          alergenos: [],
                          showBotonAlimentos: false,
                          showBotonRegistro: false,
                          showBotonGuardar: true,
                        )));

            //MostrarFood(name: name, cantidad: cantidad, unidadesCantidad: unidadesCantidad, calorias: calorias, grasas: grasas, proteinas: proteinas, carbohidratos: carbohidratos, sodio: sodio, azucar: azucar, fibra: fibra, image: image)
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topRight,
                heightFactor: 0.4,
                child: IconButton(
                  icon: Icon(Icons.delete_outline),
                  color: Colors.black,
                  onPressed: () {
                    deleteReg(widget.id);
                    //_navigatePaginaTipoComida(context, widget.id);
                  },
                ),
              ),
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
                                        .fitHeight, // Ajustar la imagen para cubrir todo el espacio disponible
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Icon(
                              Icons.fastfood,
                              color: Color.fromARGB(221, 255, 181, 71),
                            );
                          }
                        },
                      ),
                    )
                  : Icon(
                      Icons.fastfood,
                      color: Color.fromARGB(221, 255, 181, 71),
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
                                  placeholderBuilder: (BuildContext context) =>
                                      CircularProgressIndicator.adaptive()),
                            ),
                          )
                      ],
                    ),
                    SizedBox(height: 2.0),
                    Text(
                      " ${widget.codigoDeBarras}",
                      style: TextStyle(color: Colors.grey, fontSize: 8.0),
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
