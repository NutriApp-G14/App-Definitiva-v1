import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/model/Usuario.dart';
import 'package:my_app/views/CrearUsuario.dart';
import 'package:my_app/views/listviewFood.dart';
import 'package:my_app/model/Alergias.dart';
import 'package:my_app/views/UsuarioPage.dart';

class EditarUsuarioPage extends StatefulWidget {
  final String nombreUsuario;
  final String nombre;
  final String token;

  EditarUsuarioPage({
    required this.nombreUsuario,
    required this.nombre, required this.token,
  });

  @override
  _EditarUsuarioPageState createState() => _EditarUsuarioPageState();
}

class _EditarUsuarioPageState extends State<EditarUsuarioPage> {
  late Future<Usuario> _futureUsuario;
  late Future<Alergias> _futureAlergias;

  @override
  void initState() {
    super.initState();
    _futureUsuario = getUsuarioById(widget.nombreUsuario);
    _futureAlergias = getAlergiasById(widget.nombreUsuario);
  }

  Future<Usuario> getUsuarioById(String nombreUsuario) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    final response =
        await ioClient.get(Uri.parse('${urlConexion}/users/$nombreUsuario'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Usuario.fromJson(jsonData);
    } else {
      throw Exception('Error al cargar el usuario');
    }
  }

  Future<Alergias> getAlergiasById(String nombreUsuario) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    final response = await ioClient
        .get(Uri.parse('${urlConexion}/allergies/$nombreUsuario'), headers: {"Authorization" : widget.token});
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Alergias.fromJson(jsonData);
    } else {
      throw Exception('Error al cargar el usuario');
    }
  }

  DataBaseHelper dataBaseHelper = DataBaseHelper();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController nombreUsuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  late bool cacahueteController;

  var _generoSeleccionado;
  var _nivelActividadSeleccionado;
  List<int> pesos = List<int>.generate(300, (index) => index + 35);
  List<int> alturas = List<int>.generate(240, (index) => index + 50);
  var pesoSeleccionado;
  var alturaSeleccionada;

  bool obscureText = true;
  DateTime selectedDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  _navigateUsuarioPage(BuildContext context) async {
    Usuario usuario = await dataBaseHelper.getUsuarioById(widget.nombreUsuario);
    String usuarioNombre = usuario.nombre;
    String usuarioNombreUsuario = usuario.nombreUsuario;
    setState() {}
    ;
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => UsuarioPage(
          nombreUsuario: usuarioNombreUsuario, nombre: usuarioNombre, token:widget.token),
      transitionDuration: Duration(seconds: 0),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Perfil',
          style: TextStyle(
            color: Colors.black,
          ),
          // automaticallyImplyLeading: false,
        ),
        leading: IconButton(
          icon: Icon(Icons
              .arrow_back_ios_new_sharp), // Agrega aquí la imagen personalizada de flecha
          onPressed: () => _navigateUsuarioPage(context),
          color: Colors.black,
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: FutureBuilder<Usuario>(
              future: _futureUsuario,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error al cargar el usuario'),
                  );
                } else {
                  final usuario = snapshot.data!;
                  nombreUsuarioController.text = usuario.nombreUsuario;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        usuario.nombreUsuario,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nombreController,
                        decoration: InputDecoration(
                          labelText: usuario.nombre,
                          hintText: 'Editar nombre',
                          icon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Nueva contraseña',
                          hintText: 'Cambiar tu contraseña',
                          icon: Icon(Icons.password),
                          suffixIcon: IconButton(
                            icon: Icon(obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          ),
                        ),
                        obscureText: obscureText,
                        textAlignVertical: TextAlignVertical.center,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: ageController,
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now());
                          if (pickedDate != null && pickedDate != selectedDate)
                            setState(() {
                              selectedDate = pickedDate;
                              ageController.text =
                                  dateFormat.format(selectedDate);
                            });
                        },
                        decoration: InputDecoration(
                          labelText: usuario.age,
                          icon: Icon(Icons.cake),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        controller: heightController,
                        decoration: InputDecoration(
                          labelText: 'Altura',
                          hintText: 'Altura en cm',
                          icon: Icon(Icons.height),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        // Validamos que solo se ingresen números
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        controller: weightController,
                        decoration: InputDecoration(
                          labelText: 'Peso',
                          hintText: 'Peso en kg',
                          icon: Icon(Icons.fitness_center),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        // Validamos que solo se ingresen números
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: usuario.gender,
                          icon: Icon(Icons.wc),
                        ),
                        value: _generoSeleccionado,
                        onChanged: (value) {
                          setState(() {
                            _generoSeleccionado = value;
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            value: 'hombre',
                            child: Text('Hombre'),
                          ),
                          DropdownMenuItem(
                            value: 'mujer',
                            child: Text('Mujer'),
                          ),
                        ],
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: usuario.activity,
                          icon: Icon(Icons.directions_run),
                        ),
                        value: _nivelActividadSeleccionado,
                        onChanged: (value) {
                          setState(() {
                            _nivelActividadSeleccionado = value;
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            value: 'sedentario',
                            child: Text('Sedentario'),
                          ),
                          DropdownMenuItem(
                            value: 'poco activo',
                            child: Text('Poco activo'),
                          ),
                          DropdownMenuItem(
                            value: 'moderadamente activo',
                            child: Text('Moderadamente Activo'),
                          ),
                          DropdownMenuItem(
                            value: 'activo',
                            child: Text('Activo'),
                          ),
                          DropdownMenuItem(
                            value: 'muy activo',
                            child: Text('Muy activo'),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      // CheckboxListTile para seleccionar alergias
                      AlergiasWidget(),

                      SizedBox(height: 32.0),
                      Column(children: [
                        SizedBox(
                          height: 40,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              dataBaseHelper.updateUsuario(
                                (nombreController.text.trim() == null ||
                                        nombreController.text.trim() == '')
                                    ? usuario.nombre
                                    : nombreController.text.trim(),
                                (nombreUsuarioController.text.trim() == null ||
                                        nombreUsuarioController.text.trim() ==
                                            '')
                                    ? usuario.nombreUsuario
                                    : nombreUsuarioController.text.trim(),
                                (passwordController.text.trim() == null ||
                                        passwordController.text.trim() == '')
                                    ? usuario.password
                                    : passwordController.text.trim(),
                                (ageController.text.trim() == null ||
                                        ageController.text.trim() == '')
                                    ? usuario.age
                                    : ageController.text.trim(),
                                (heightController == null ||
                                        heightController.text.trim() == '')
                                    ? usuario.height
                                    : heightController.text.trim(),
                                (weightController == null ||
                                        weightController.text.trim() == '')
                                    ? usuario.weight
                                    : weightController.text.trim(),
                                (_generoSeleccionado == null ||
                                        _generoSeleccionado == '')
                                    ? usuario.gender
                                    : _generoSeleccionado,
                                (_nivelActividadSeleccionado == null ||
                                        _nivelActividadSeleccionado == '')
                                    ? usuario.activity
                                    : _nivelActividadSeleccionado,
                                usuario.objective,
                                usuario.imageString, widget.token
                                //luego hay q cambiar esto
                              );

                              dataBaseHelper.updateAlergias(
                                (nombreController.text.trim() == null ||
                                        nombreController.text.trim() == '')
                                    ? usuario.nombre
                                    : nombreController.text.trim(),
                                seleccionadas.contains('Cacahuetes'),
                                seleccionadas.contains('Leche'),
                                seleccionadas.contains('Huevo'),
                                seleccionadas.contains('Trigo'),
                                seleccionadas.contains('Soja'),
                                seleccionadas.contains('Mariscos'),
                                seleccionadas.contains('Frutos secos'),
                                seleccionadas.contains('Pescado'),
                                widget.token
                              );

                              ;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListAlimentos(
                                    nombreUsuario: usuario.nombreUsuario,
                                    token: widget.token
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.orange,
                              //foregroundColor: Color.fromARGB(255, 0, 0, 0),
                              foregroundColor: Colors.black,
                            ),
                            child: Text('Guardar cambios'),
                          ),
                        )
                      ])
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

            //final double total = double.parse(remaining) + double.parse(consumed);
    // final double progress = double.parse(consumed) / total;
    // final bool goalReached = double.parse(remaining) <= 0; 
    // goalReached
            //     ? Text('Objetivo cumplido')
            //     : LinearProgressIndicator(
            //         value: progress,
            //         valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            //         backgroundColor: Colors.grey[300],