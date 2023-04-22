import 'package:flutter/material.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/views/IniciarSesion.dart';
import 'package:my_app/views/listviewFood.dart';
import 'package:my_app/model/Alergias.dart';
import 'package:intl/intl.dart';

final bool cacahuetesController = false;
final bool lecheController = false;
final bool huevoController = false;
final bool trigoController = false;
final bool sojaController = false;
final bool mariscosController = false;
final bool frutosSecosController = false;
final bool pescadoController = false;

Map<String, bool> seleccionarAlergias(
    List<String> alergias, List<String> alergiasSeleccionadas) {
  Map<String, bool> resultado = {};

  for (String alergia in alergias) {
    if (alergiasSeleccionadas.contains(alergia)) {
      resultado[alergia] = true;
    } else {
      resultado[alergia] = false;
    }
  }

  return resultado;
}

List<String> alergias = [
  'Cacahuetes',
  'Leche',
  'Huevo',
  'Trigo',
  'Soja',
  'Mariscos',
  'Frutos secos',
  'Pescado',
];

class CrearUsuarioPage extends StatefulWidget {
  @override
  _CrearUsuarioPageState createState() => _CrearUsuarioPageState();
}

class _CrearUsuarioPageState extends State<CrearUsuarioPage> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController nombreUsuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  var _generoSeleccionado;
  var _nivelActividadSeleccionado;
  List<int> pesos = List<int>.generate(300, (index) => index + 35);
  List<int> alturas = List<int>.generate(240, (index) => index + 50);
  var pesoSeleccionado;
  var alturaSeleccionada;

  int calcularEdad(DateTime fechaNacimiento) {
    final ahora = DateTime.now();
    int edad = ahora.year - fechaNacimiento.year;
    if (ahora.month < fechaNacimiento.month ||
        (ahora.month == fechaNacimiento.month &&
            ahora.day < fechaNacimiento.day)) {
      edad--;
    }
    return edad;
  }

  bool obscureText = true;
  DateTime selectedDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Crear Usuario',
          style: TextStyle(color: Colors.white),
        )),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Introduzca su Nombre completo',
                    icon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: nombreUsuarioController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de usuario',
                    hintText: 'Introduzca su Nombre de Usuario',
                    icon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Introduzca su password',
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
                SizedBox(height: 16.0),
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
                        ageController.text = dateFormat.format(selectedDate);
                        //ageController.text=calcularEdad(selectedDate).toString();
                      });
                  },
                  decoration: InputDecoration(
                    labelText: 'Fecha de nacimiento',
                    icon: Icon(Icons.cake),
                  ),
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Altura',
                    hintText: 'Altura en cm',
                    icon: Icon(Icons.height),
                  ),
                  value: alturaSeleccionada,
                  items: alturas.map((int altura) {
                    return DropdownMenuItem<int>(
                      value: altura,
                      child: Text(altura.toString() + "cm"),
                    );
                  }).toList(),
                  onChanged: (nuevaAltura) {
                    setState(() {
                      alturaSeleccionada = nuevaAltura!;
                    });
                  },
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Peso',
                    hintText: 'Peso en kg',
                    icon: Icon(Icons.fitness_center),
                  ),
                  value: pesoSeleccionado,
                  items: pesos.map((int peso) {
                    return DropdownMenuItem<int>(
                      value: peso,
                      child: Text(peso.toString() + " kg"),
                    );
                  }).toList(),
                  onChanged: (nuevoPeso) {
                    setState(() {
                      pesoSeleccionado = nuevoPeso!;
                    });
                  },
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Género',
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
                    labelText: 'Nivel de actividad física',
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
              ],
            ),
          ),
          // CheckboxListTile para seleccionar alergias
          AlergiasWidget(),
          //Column(
          //  children: _crearAlergias(),
          //),
          SizedBox(height: 32.0),
          Column(children: [
            SizedBox(
                height: 40,
                width: 150,
                child: ElevatedButton(
                    onPressed: () async {
                      if (nombreUsuarioController.text.trim().isEmpty ||
                          nombreController.text.trim().isEmpty ||
                          passwordController.text.trim().isEmpty ||
                          ageController.text.trim().isEmpty ||
                          _generoSeleccionado.toString().trim().isEmpty ||
                          _nivelActividadSeleccionado
                              .toString()
                              .trim()
                              .isEmpty ||
                          pesoSeleccionado.toString().trim().isEmpty ||
                          alturaSeleccionada.toString().trim().isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Campos incompletos'),
                            content: Text('Por favor completa la información.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cerrar'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }
                      bool exists = await dataBaseHelper
                          .usuarioExists(nombreUsuarioController.text.trim());
                      if (exists) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Nombre de usuario existente'),
                            content: Text(
                                'El nombre de usuario ya existe. Por favor elige otro.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cerrar'),
                              ),
                            ],
                          ),
                        );
                        return;
                      } else {
                        dataBaseHelper.addUsuario(
                            nombreController.text.trim(),
                            nombreUsuarioController.text.trim(),
                            passwordController.text.trim(),
                            ageController.text.trim(),
                            alturaSeleccionada.toString(),
                            pesoSeleccionado.toString(),
                            _generoSeleccionado,
                            _nivelActividadSeleccionado,
                            "ninguno");
                        Map<String, bool> alergiasSeleccionadas =
                            seleccionarAlergias(alergias, seleccionadas);
                        bool cacahuetesController =
                            alergiasSeleccionadas['Cacahuetes'] ?? false;
                        bool lecheController =
                            alergiasSeleccionadas['Leche'] ?? false;
                        bool huevoController =
                            alergiasSeleccionadas['Huevo'] ?? false;
                        bool trigoController =
                            alergiasSeleccionadas['Trigo'] ?? false;
                        bool sojaController =
                            alergiasSeleccionadas['Soja'] ?? false;
                        bool mariscosController =
                            alergiasSeleccionadas['Mariscos'] ?? false;
                        bool frutosSecosController =
                            alergiasSeleccionadas['Frutos secos'] ?? false;
                        bool pescadoController =
                            alergiasSeleccionadas['Pescado'] ?? false;

                        dataBaseHelper.addAlergias(
                            nombreUsuarioController.text.trim(),
                            cacahuetesController,
                            lecheController,
                            huevoController,
                            trigoController,
                            sojaController,
                            mariscosController,
                            frutosSecosController,
                            pescadoController);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListAlimentos(
                                  nombreUsuario:
                                      nombreUsuarioController.text.trim())),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Crear cuenta',
                        style: TextStyle(fontWeight: FontWeight.bold)))),
            TextButton(
              onPressed: () {
                // Lógica para ir a la página de inicio de sesión
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IniciarSesionPage()));
              },
              child: Text('¿Ya tienes cuenta? Inicia sesión'),
            ),
          ])
        ],
      ),
    );
  }
}
