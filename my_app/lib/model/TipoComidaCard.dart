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
             List<String> alimentos =[];
            if (registroComidas!=null && !registroComidas.isEmpty){
                  alimentos = registroComidas.map((registro) => registro['nombreAlimento'].toString()).toList();
            }
          


            return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Card(
                    margin: EdgeInsets.only(bottom: 0),
                    color: Color.fromARGB(255, 250, 228, 198),
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
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Column(
                                  children: [
                                    Row(
                                    children: [
                                      Text(
                                      '${registroComidas.length} comidas registradas : '),
                                if (registroComidas!=null && !registroComidas.isEmpty)
                                    for (int i = 0; i < alimentos.length; i++)
                                    Text(
                                      '${alimentos[i]} ',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                    ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Text('Aquí pueden ir las estadisticas'),
                                      ],
                                    ),
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
                                          formattedDate.trim().toLowerCase());
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
                    )));
          }else{
          return CircularProgressIndicator();
          }
        
        });
  }
}
