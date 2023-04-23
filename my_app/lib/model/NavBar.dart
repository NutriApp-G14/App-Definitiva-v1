import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/model/Usuario.dart';
import 'package:my_app/views/AddAlimentoPage.dart';
import 'package:my_app/views/BuscadorNuevo.dart';
import 'package:my_app/views/CrearUsuario.dart';
import 'package:my_app/views/IniciarSesion.dart';
import 'package:my_app/views/NuevoBuscador.dart';
import 'package:my_app/views/RegistroComidas.dart';
import 'package:my_app/views/UsuarioPage.dart';
import 'package:my_app/views/listviewFood.dart';

class NutriAppBar extends StatefulWidget {
  final String nombreUsuario;
  final bool isPremium = false;

  const NutriAppBar({required this.nombreUsuario});

  @override
  _NutriAppBarState createState() => _NutriAppBarState();
}

class _NutriAppBarState extends State<NutriAppBar> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  DateTime now = DateTime.now();
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
  }

  _navigateAddAlimento(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddAlimentoPage(nombreUsuario: widget.nombreUsuario)));
  }
  _navigateRegistroComidas(BuildContext context) async{
    String usuarioNombreUsuario = widget.nombreUsuario;

    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => RegistroComidasPage(
          nombreUsuario: usuarioNombreUsuario),
      transitionDuration: Duration(seconds: 0),
    ));
  }

  _navigateUsuarioPage(BuildContext context) async {
    Usuario usuario = await dataBaseHelper.getUsuarioById(widget.nombreUsuario);
    String usuarioNombre = usuario.nombre;
    String usuarioNombreUsuario = usuario.nombreUsuario;
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => UsuarioPage(nombreUsuario: usuarioNombreUsuario, nombre: usuarioNombre),
      transitionDuration: Duration(seconds: 0),
    ));
  }

  _navigateCrearUsuarioPage(BuildContext context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => IniciarSesionPage()));
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

  @override
  Widget build(BuildContext context) {
    return Container(
      //  backgroundColor: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.logout),
                color: Colors.black,
                highlightColor: Colors
                    .transparent, // desactiva la sombra del botón cuando se presiona
                splashRadius: 1.0,
                hoverColor: Colors.transparent,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Cerrar sesión'),
                        content:
                            Text('¿Estás seguro de que deseas cerrar sesión?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Cerrar el cuadro de diálogo
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Lógica para cerrar sesión
                              // Cerrar el cuadro de diálogo
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CrearUsuarioPage(),
                                ),
                              );
                            },
                            child: Text('Confirmar'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Text(
                "NutriApp",
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                color: Colors.black,
                highlightColor: Colors
                    .transparent, // desactiva la sombra del botón cuando se presiona
                splashRadius: 1.0,
                onPressed: () {
                  Navigator.push(
                    context,
                    // MaterialPageRoute(
                    //   builder: (context) => BuscadorComida(
                    //     nombreUsuario: widget.nombreUsuario,
                    //   ),
                      //  MaterialPageRoute(
                      // builder: (context) => NuevoBuscador(
                      //   nombreUsuario: widget.nombreUsuario,
                      // ),
                       MaterialPageRoute(
                      builder: (context) => BuscadorNuevo(
                        nombreUsuario: widget.nombreUsuario,
                        fecha: formattedDate,
                      ),
                    ),
                  );
                },
                hoverColor: Colors.transparent,
              ),
            ],
          ),
          Container(
            height: 60,
            width: double.infinity,
            color: Color.fromARGB(255, 255, 191, 94),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    icon: Icon(Icons.person),
                    color: Colors.black,
                    onPressed: () => _navigateUsuarioPage(context),
                    highlightColor: Colors
                        .transparent, // desactiva la sombra del botón cuando se presiona
                    splashRadius: 1.0,
                    hoverColor: Colors.transparent),
                IconButton(
                    icon: Icon(Icons.apple),
                    color: Colors.black,
                    onPressed: () {
                      _navigateAlimentos(context);
                    },
                    highlightColor: Colors
                        .transparent, // desactiva la sombra del botón cuando se presiona
                    splashRadius: 1.0,
                    hoverColor: Colors.transparent),
                IconButton(
                    icon: Icon(Icons.menu_book),
                    color: Colors.black,
                    onPressed: () {
                      
                       _navigateRegistroComidas(context);
                      // if (widget.isPremium) {
                      //   // Código para la acción de estadísticas
                      // } else {
                      //   showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return AlertDialog(
                      //         title: Text('Sprint 3'),
                      //         content: Text(
                      //             'Esta funcionalidad estará disponible en el Sprint 3'),
                      //         actions: [
                      //           TextButton(
                      //             onPressed: () {
                      //               Navigator.of(context).pop();
                      //             },
                      //             child: Text('Aceptar'),
                      //           ),
                      //         ],
                      //       );
                      //     },
                      //   );
                      // }
                    },
                    highlightColor: Colors
                        .transparent, // desactiva la sombra del botón cuando se presiona
                    splashRadius: 1.0,
                    hoverColor: Colors.transparent),
                IconButton(
                  icon: Icon(Icons.bar_chart),
                  color: Colors.black,
                  highlightColor: Colors
                      .transparent, // desactiva la sombra del botón cuando se presiona
                  splashRadius: 1.0,
                  hoverColor: Colors.transparent,
                  onPressed: () {
                    if (widget.isPremium) {
                      // Código para la acción de estadísticas
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(children: [
                              Text('Solo para premium'),
                              Icon(
                                Icons.workspace_premium,
                                color: Colors.amberAccent,
                              )
                            ]),
                            content: Text(
                                'Esta funcionalidad está disponible solo para usuarios premium'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Comprar premium'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.swap_horiz),
                  color: Colors.black,
                  highlightColor: Colors
                      .transparent, // desactiva la sombra del botón cuando se presiona
                  splashRadius: 1.0,
                  hoverColor: Colors.transparent,
                  onPressed: () {
                    if (widget.isPremium) {
                      // Código para la acción de intercambio
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(children: [
                              Text('Solo para premium'),
                              Icon(
                                Icons.workspace_premium,
                                color: Colors.amberAccent,
                              )
                            ]),
                            content: Text(
                                'Esta funcionalidad está disponible solo para usuarios premium'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Comprar premium'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
