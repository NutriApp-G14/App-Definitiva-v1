import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/model/Usuario.dart';
import 'package:my_app/views/AddAlimentoPage.dart';
import 'package:my_app/views/CrearUsuario.dart';
import 'package:my_app/views/IniciarSesion.dart';
import 'package:my_app/views/NuevoBuscador.dart';
import 'package:my_app/views/RegistroComidas.dart';
import 'package:my_app/views/UsuarioPage.dart';
import 'package:my_app/views/buscador.dart';
import 'package:my_app/views/listviewfood.dart';

class TipoComidaCard extends StatefulWidget {
  final String nombreUsuario;
  final String tipoDeComida;

  const TipoComidaCard({required this.nombreUsuario, required this.tipoDeComida});

  @override
  _TipoComidaCardState createState() => _TipoComidaCardState();
}
class _TipoComidaCardState extends State<TipoComidaCard> {
  DateTime now = DateTime.now(); 
  late String formattedDate; 
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formattedDate = DateFormat('dd/MM/yyyy').format(now);
    print(formattedDate);
  }

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
                  children: [
                   // Row(
                    //children:[ 
                      Card(
                        margin: EdgeInsets.only(bottom: 0), 
                        color: Colors.orange[200],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),  
                      child: ListTile(
                        leading: Image.network("https://w7.pngwing.com/pngs/720/994/png-transparent-biscuit-cookie-iconfinder-icon-biscuit-food-orange-coffee-biscuits.png"),
                          title: Text(
                           "${widget.tipoDeComida}",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                              fontSize: 25,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ), onPressed: () { 
                             // _navigateMostrarTipoComida(context);
                             },
                          ), 
                        ),

        
                    ),
                    ]
                  //  )
                //  ],
                       
                  
        ),

      );
  }
}