import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/controllers/registroHelpers.dart';
import 'package:my_app/model/PaginaTipoComida.dart';
import 'package:my_app/model/Usuario.dart';
import 'package:my_app/views/AddAlimentoPage.dart';
import 'package:my_app/views/CrearUsuario.dart';
import 'package:my_app/views/IniciarSesion.dart';
import 'package:my_app/views/NuevoBuscador.dart';
import 'package:my_app/views/RegistroComidas.dart';
import 'package:my_app/views/UsuarioPage.dart';
import 'package:my_app/views/listviewfood.dart';

class TipoComidaCard extends StatefulWidget {
  final String nombreUsuario;
  final String tipoDeComida;

  const TipoComidaCard(
      {required this.nombreUsuario, required this.tipoDeComida});

  @override
  _TipoComidaCardState createState() => _TipoComidaCardState();
}

class _TipoComidaCardState extends State<TipoComidaCard> {
  DateTime now = DateTime.now();
  late String formattedDate;
  RegistroHelper dataBaseHelper = RegistroHelper();

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
  }

  _navigateMostrarTipoComida(BuildContext context, String fecha,
      String tipoDeComida, String nombreUsuario) async {
    List registros = await dataBaseHelper.getRegistroComidas(
        nombreUsuario.trim().toLowerCase(),
        tipoDeComida.trim().toLowerCase(),
        formattedDate.trim().toLowerCase());

    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PaginaTipoComida(
        nombreUsuario: nombreUsuario,
        tipoDeComida: tipoDeComida,
        fecha: fecha,
        registros: registros,
      ),
      transitionDuration: Duration(seconds: 0),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: dataBaseHelper.getRegistroComidas(
          widget.nombreUsuario.trim().toLowerCase(),
          widget.tipoDeComida.trim().toLowerCase(),
          formattedDate.trim().toLowerCase(),
        ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List registroComidas = snapshot.data;
            List<String> alimentos = [];
            List<dynamic> tamanos =
                List.generate(alimentos.length, (index) => 0);
            int size = 0;
            if (registroComidas != null && !registroComidas.isEmpty) {
              alimentos = registroComidas
                  .map((registro) => registro['nombreAlimento'].toString())
                  .toList();
              for (int i = 0; i < alimentos.length; i++) {
                size += alimentos[i].length;
                tamanos.add(size);
              }
            }

            return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Card(
                        margin: EdgeInsets.only(bottom: 0),
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/${widget.tipoDeComida}.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${widget.tipoDeComida}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${registroComidas.length} comidas registradas: '),
                                        Row(
                                          children: [
                                            if (registroComidas != null &&
                                                !registroComidas.isEmpty)
                                              for (int i = 0;
                                                  i < alimentos.length;
                                                  i++)
                                                if (tamanos[i] < 40)
                                                  Text(
                                                    '${tamanos[i] > 37 ? '${alimentos[i].substring(0, 2)} ...' : alimentos[i]}, ',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
                                                      fontFamily: 'Montserrat',
                                                    ),
                                                  ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 320,
                                                  child: Container(
                                                      height: 10,
                                                      color: Color.fromARGB(255, 255, 241, 134)),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                    flex: 125,
                                                    child: Text(
                                                      '320 kcal',
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    )),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 60,
                                                  child: Container(
                                                    
                                                    height: 10,
                                                    color: Color.fromARGB(
                                                        238, 104, 201, 253),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                    flex: 125,
                                                    child: Text(
                                                      '60 g',
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    )),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 90,
                                                  child: Container(
                                                    height: 10,
                                                    color: Color.fromARGB(
                                                        251, 93, 223, 54),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                    flex: 125,
                                                    child: Text(
                                                      '90 g',
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    )),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 30,
                                                  child: Container(
                                                    height: 10,
                                                    color: Color.fromARGB(
                                                        234, 236, 97, 87),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                    flex: 125,
                                                    child: Text(
                                                      '30 g',
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          dataBaseHelper.getRegistroComidas(
                                              widget.nombreUsuario
                                                  .trim()
                                                  .toLowerCase(),
                                              widget.tipoDeComida
                                                  .trim()
                                                  .toLowerCase(),
                                              formattedDate
                                                  .trim()
                                                  .toLowerCase());
                                          _navigateMostrarTipoComida(
                                              context,
                                              formattedDate,
                                              widget.tipoDeComida,
                                              widget.nombreUsuario);
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ))));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
