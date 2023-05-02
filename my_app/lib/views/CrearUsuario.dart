import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  var aceptarTerminos = false;
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController nombreUsuarioController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  var _generoSeleccionado;
  var _nivelActividadSeleccionado;
  List<int> pesos = List<int>.generate(300, (index) => index + 35);
  List<int> alturas = List<int>.generate(240, (index) => index + 50);
  var pesoSeleccionado;
  var alturaSeleccionada;

  bool _aceptado = false;
  bool _showTerminos = false;

  void _mostrarTerminos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Términos de uso y privacidad', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Términos de uso:\n\n'
                  'NutriApp es una aplicación de seguimiento de la nutrición que proporciona información y herramientas para ayudar a los usuarios a lograr sus objetivos de salud y bienestar.\n\n'
                  'Los usuarios pueden crear una cuenta en NutriApp y utilizar la aplicación para rastrear sus comidas, nutrientes y otros datos de salud y bienestar.\n\n'
                  'Al utilizar NutriApp, los usuarios aceptan que la aplicación es solo una herramienta de seguimiento y no debe utilizarse como sustituto de la atención médica o el asesoramiento de un profesional de la salud.\n\n'
                  'NutriApp no se hace responsable de ninguna lesión, enfermedad o daño resultante del uso de la aplicación.\n\n'
                  'Los usuarios deben ser mayores de 18 años para crear una cuenta en NutriApp, o tener el permiso de un padre o tutor legal.\n\n'
                  'NutriApp se reserva el derecho de modificar o actualizar estos términos de uso en cualquier momento, y los usuarios deben revisar regularmente los términos actualizados.\n\n'
                  'Privacidad:\n\n'
                  'NutriApp recopila información personal de los usuarios, como su nombre, dirección de correo electrónico y datos de salud, para proporcionar servicios personalizados y mejorar la experiencia del usuario.\n\n'
                  'NutriApp se compromete a proteger la privacidad de los usuarios y no compartirá su información personal con terceros sin su consentimiento explícito.\n\n'
                  'NutriApp utiliza cookies y tecnologías similares para recopilar información sobre el uso de la aplicación, como las páginas visitadas y las acciones realizadas.\n\n'
                  'Los usuarios pueden optar por no participar en la recopilación de datos de NutriApp al cambiar su configuración de privacidad en la aplicación.\n\n'
                  'NutriApp se reserva el derecho de utilizar datos agregados y anónimos para fines de investigación y análisis de mercado.',
                  textAlign: TextAlign.center,
                )),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _cerrarTerminos() {
    setState(() {
      _showTerminos = false;
    });
  }

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
                TextField(
                  controller: heightController,
                  decoration: InputDecoration(
                      labelText: 'Altura',
                      hintText: 'Altura en cm',
                      icon: Icon(Icons.height)),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  // Validamos que solo se ingresen números
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
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
                      child: Text('Sedentario (0 días)'),
                    ),
                    DropdownMenuItem(
                      value: 'poco activo',
                      child: Text('Poco activo (1 día)'),
                    ),
                    DropdownMenuItem(
                      value: 'moderadamente activo',
                      child: Text('Moderadamente Activo (2-3 días)'),
                    ),
                    DropdownMenuItem(
                      value: 'activo',
                      child: Text('Activo (4-5 días)'),
                    ),
                    DropdownMenuItem(
                      value: 'muy activo',
                      child: Text('Muy activo (más de 5 días)'),
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
          Row(
            children: [
              Checkbox(
                value: _aceptado,
                onChanged: (value) {
                  setState(() {
                    _aceptado = value!;
                  });
                },
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: _mostrarTerminos,
                child: Text(
                  'Acepto los términos de uso y privacidad',
                  style: TextStyle(
                    color: Colors.orange,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),

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
                          weightController.text.trim().isEmpty ||
                          heightController.text.trim().isEmpty) {
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
                        if (_aceptado == false) {
                          _mostrarDialogoTerminos();
                        } else {
                          dataBaseHelper.addUsuario(
                              nombreController.text.trim(),
                              nombreUsuarioController.text.trim(),
                              passwordController.text.trim(),
                              ageController.text.trim(),
                              heightController.text.trim(),
                              weightController.text.trim(),
                              _generoSeleccionado,
                              _nivelActividadSeleccionado,
                              "ninguno",
                              "");
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
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Crear cuenta',
                        style: TextStyle(fontWeight: FontWeight.bold)))),
            SizedBox(
              height: 5,
            ),
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
            SizedBox(
              height: 15,
            ),
          ])
        ],
      ),
    );
  }

  void _mostrarDialogoTerminos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Términos de uso'),
          content: Text('Por favor, acepte los términos de uso'),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class TerminosDeUsoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Términos de uso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Aquí va la información de los términos de uso.'),
      ),
    );
  }
}
