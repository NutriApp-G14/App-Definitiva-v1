import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/model/NavBar.dart';
import 'package:my_app/model/Usuario.dart';
import 'package:my_app/views/CrearUsuario.dart';
import 'package:my_app/views/EditarUsuario.dart';
import 'package:my_app/views/buscador.dart';
import 'package:my_app/views/listviewfood.dart';
import 'package:my_app/model/Alergias.dart';

List<String> alergias_ = [];
List<String> _alergias(Alergias alergia) {
  alergias_ = [];
  final Map<String, bool> alergiasMap = {
    'Cacahuetes': alergia.cacahuetes,
    'Leche': alergia.leche,
    'Huevo': alergia.huevo,
    'Trigo': alergia.trigo,
    'Soja': alergia.soja,
    'Mariscos': alergia.mariscos,
    'Frutos secos': alergia.frutosSecos,
    'Pescado': alergia.pescado,
  };

  alergiasMap.forEach((key, value) {
    if (value) {
      alergias_.add(key);
    }
  });

  return alergias_;
}

class UsuarioPage extends StatefulWidget {
  final String nombreUsuario;
  final String nombre;
  final bool isPremium = false;

  UsuarioPage({
    required this.nombreUsuario,
    required this.nombre,
  });

  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  late Future<Usuario> _futureUsuario;
  late Future<Alergias> _futureAlergias;
  var _edad;
  var _peso;
  var _altura;
  var _sexo;

  DataBaseHelper dataBaseHelper = DataBaseHelper();

  @override
  void initState() {
    //super.initState();
    _futureUsuario = dataBaseHelper.getUsuarioById(widget.nombreUsuario);
    _futureAlergias = dataBaseHelper.getAlergiasById(widget.nombreUsuario);
  }

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController nombreUsuarioController = TextEditingController();

  _navigateUsuarioPage(BuildContext context) async {
    Usuario usuario = await dataBaseHelper.getUsuarioById(widget.nombreUsuario);
    String usuarioNombre = usuario.nombre;
    String usuarioNombreUsuario = usuario.nombreUsuario;
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => UsuarioPage(
          nombreUsuario: usuarioNombreUsuario, nombre: usuarioNombre),
      transitionDuration: Duration(seconds: 0),
    ));
  }

  _navigateAlimentos(BuildContext context) async {
    Usuario usuario = await dataBaseHelper.getUsuarioById(widget.nombreUsuario);
    String usuarioNombre = usuario.nombre;
    String usuarioNombreUsuario = usuario.nombreUsuario;
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ListAlimentos(nombreUsuario: usuarioNombreUsuario),
        transitionDuration: Duration(seconds: 0),
      ),
    );
  }

  int calcularEdad(String fechaNacimiento) {
    List<String> fechaNacimientoArray = fechaNacimiento.split("/");
    int dia = int.parse(fechaNacimientoArray[0]);
    int mes = int.parse(fechaNacimientoArray[1]);
    int anio = int.parse(fechaNacimientoArray[2]);
    final fechaActual = DateTime.now();
    int edad = fechaActual.year - anio;
    if (fechaActual.month < mes ||
        (fechaActual.month == mes && fechaActual.day < dia)) {
      edad--;
    }
    return edad;
  }

  double _calculateTmb(double peso, double altura, String sexo, int edad) {
    double tmb = 0.0;
    if (sexo.trim().toLowerCase() == 'hombre') {
      tmb = (10 * peso) + (6.25 * altura) - (5 * edad) + 5;
    } else if (sexo.trim().toLowerCase() == 'mujer') {
      tmb = (10 * peso) + (6.25 * altura) - (5 * edad) - 161;
    }
    return tmb;
  }

  double _calcularIMC(double peso, double altura) {
    // convertir a metros
    altura = altura / 100;
    double _imc = peso / (altura * altura);
    return _imc;
  }

  double _calcularNecesidadAgua(
      double peso, double altura, String sexo, int edad) {
    var _necesidadAgua1 = 30 * peso + 500;
    _necesidadAgua1 = _necesidadAgua1 / 1000;
    return _necesidadAgua1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(52),
            child: NutriAppBar(nombreUsuario: widget.nombreUsuario),
          ),
        ),
        body: ListView(children: [
          FutureBuilder<Usuario>(
            future: _futureUsuario,
            builder: (BuildContext context, AsyncSnapshot<Usuario> snapshot) {
              if (snapshot.hasData) {
                final usuario = snapshot.data!;

                _edad = calcularEdad(
                    usuario.age); // llamamos a la función para calcular la edad
                _peso = double.parse(usuario.weight);
                _altura = double.parse(usuario.height);
                _sexo = usuario.gender;

                double _imc = _calcularIMC(_peso, _altura);
                double _necesidadAgua =
                    _calcularNecesidadAgua(_peso, _altura, _sexo, _edad);
                double _tmb = _calculateTmb(_peso, _altura, _sexo, _edad);

                return Column(children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 15),
                                    Text(
                                      usuario.nombreUsuario,
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Open Sans',
                                        fontSize: 30.0,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 1.0,
                                            color: Colors.grey,
                                            offset: Offset(0.5, 0.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
                                    child: SizedBox(
                                      height: 22,
                                      width: 115,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          print(valorInicial);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditarUsuarioPage(
                                                nombreUsuario:
                                                    usuario.nombreUsuario,
                                                nombre: usuario.nombre,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text("Editar perfil",
                                            style: TextStyle(fontSize: 13)),
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage:
                                      AssetImage("assets/user.jpeg"),
                                ),
                                SizedBox(
                                  width: 30,
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Información personal",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Edad:",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      ' $_edad',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Altura:",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "${usuario.height} cm",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Peso:",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "${usuario.weight} kg",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Actividad:",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "${usuario.activity}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Altura:",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "${usuario.gender}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                        Card(
                            child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "IMC:",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            "${_imc.toStringAsFixed(2)}",
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Metabolismo Basal:",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            "${_tmb} KCal",
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Necesidad de Agua:",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            "${_necesidadAgua} litros ",
                                          ),
                                        ],
                                      ),
                                    ])))
                      ],
                    ),
                  )
                ]);
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else {
                return Center(
                    child: Column(
                  children: [
                    SizedBox(height: 305),
                    CircularProgressIndicator(),
                  ],
                ));
              }
            },
          ),
          FutureBuilder<Alergias>(
            future: _futureAlergias,
            builder: (BuildContext context, AsyncSnapshot<Alergias> snapshot) {
              if (snapshot.hasData) {
                final alergia = snapshot.data!;
                final listaAlergias = _alergias(alergia);
                return Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Alergias:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Wrap(
                                    children: [
                                      for (String item in listaAlergias)
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 10, 5, 0),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 248, 220, 179),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 255, 119, 0),
                                                width: 2),
                                          ),
                                          child: Text(
                                            item,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        )
                                    ],
                                  )
                                ]))));
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else {
                return Center(
                  child: Text(""), //CircularProgressIndicator(),
                );
              }
            },
          ),
        ]));
  }
}
