zimport 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controllers/databasehelpers.dart';
import 'package:my_app/model/NavBar.dart';
import 'package:my_app/model/Usuario.dart';
import 'package:my_app/views/CrearUsuario.dart';
import 'package:my_app/views/EditarUsuario.dart';
import 'package:my_app/views/buscador.dart';
import 'package:my_app/views/listviewFood.dart';
import 'package:my_app/model/Alergias.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:io';

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
  var _objectiveSeleccionado;
  late Map<String, dynamic> requerimientoCalorico;
  late File? _profileImage = null;
  String? _profileImageURL;

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

  Map<String, dynamic> _factorActividad(String actividad, double tmb,
      String _objectiveSeleccionado, double weight) {
    var calorieRequirement;

    switch (actividad) {
      case 'sedentario':
        calorieRequirement = tmb * 1.2;
        break;
      case 'poco activo':
        calorieRequirement = tmb * 1.375;
        break;
      case 'moderadamente activo':
        calorieRequirement = tmb * 1.55;
        break;
      case 'activo':
        calorieRequirement = tmb * 1.725;
        break;
      case 'muy activo':
        calorieRequirement = tmb * 1.9;
        break;
      default:
        calorieRequirement = tmb;
    }

    switch (_objectiveSeleccionado) {
      case 'perder peso rapidamente':
        calorieRequirement *= 0.8;
        break;
      case 'perder peso lentamente':
        calorieRequirement *= 0.9;
        break;
      case 'mantener peso':
        calorieRequirement *= 1;
        break;
      case 'aumentar peso lentamente':
        calorieRequirement *= 1.1;
        break;
      case 'aumentar peso rapidamente':
        calorieRequirement *= 1.2;
        break;
      default:
        calorieRequirement = calorieRequirement;
    }

    // Calculate macronutrient ranges
    double protein = weight *
        (_objectiveSeleccionado == 'aumentar peso lentamente' ||
                _objectiveSeleccionado == 'aumentar peso rapidamente'
            ? 2.2
            : 1.8);
    double fat = calorieRequirement * 0.25 / 9;
    double carb = (calorieRequirement - (protein * 4) - (fat * 9)) / 4;

    return {
      'calories': calorieRequirement,
      'protein': protein,
      'fat': fat,
      'carb': carb,
    };
  }

  
  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _profileImageURL = null;
      });
    } else {
      showSnackBar('No se ha seleccionado ninguna imagen');
    }
  }

  Future<void> _showUrlDialog() async {
    String url = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ingresa la URL de la imagen'),
          content: TextField(
            onChanged: (value) {
              url = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _profileImage = null;
                  _profileImageURL = null;
                });
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _profileImage = null;
                  _profileImageURL = url;
                });
              },
            ),
          ],
        );
      },
    );
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
                _objectiveSeleccionado = usuario.objective;

                double _imc = _calcularIMC(_peso, _altura);
                double _necesidadAgua =
                    _calcularNecesidadAgua(_peso, _altura, _sexo, _edad);
                double _tmb = _calculateTmb(_peso, _altura, _sexo, _edad);
                if (_objectiveSeleccionado != "ninguno") {
                  requerimientoCalorico = _factorActividad(
                      usuario.activity, _tmb, _objectiveSeleccionado, _peso);
                }

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
                                      usuario.nombre,
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
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          child: Wrap(
                                            children: <Widget>[
                                              ListTile(
                                                leading:
                                                    Icon(Icons.photo_library),
                                                title: Text(
                                                    'Seleccionar imagen de galería'),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  _pickImageFromGallery();
                                                },
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.link),
                                                title:
                                                    Text('Pegar URL de imagen'),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  _showUrlDialog();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage: _profileImage != null
                                        ? FileImage(_profileImage!)
                                            as ImageProvider<Object>?
                                        : _profileImageURL != null
                                            ? NetworkImage(_profileImageURL!)
                                                as ImageProvider<Object>?
                                            : AssetImage("assets/user.jpeg")
                                                as ImageProvider<Object>?,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.blue,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
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
                                      "Sexo:",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "${usuario.gender}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                FutureBuilder<Alergias>(
                                  future: _futureAlergias,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<Alergias> snapshot) {
                                    if (snapshot.hasData) {
                                      final alergia = snapshot.data!;
                                      final listaAlergias = _alergias(alergia);
                                      return Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Alergias:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Wrap(
                                                spacing: 0,
                                                children: [
                                                  for (String item
                                                      in listaAlergias)
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 10, 5, 0),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 248, 220, 179),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          color: Color.fromARGB(
                                                              255, 255, 119, 0),
                                                          width: 2,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        item,
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text("Error: ${snapshot.error}"),
                                      );
                                    } else {
                                      return Center(
                                        child: Text(
                                            ""), //CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
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
                                    ]))),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Objetivo',
                                    icon: Icon(Icons.sports_score),
                                  ),
                                  value: _objectiveSeleccionado,
                                  onChanged: (value) {
                                    setState(() {
                                      _objectiveSeleccionado = value;
                                    });
                                    dataBaseHelper.updateUsuario(
                                        usuario.nombre,
                                        usuario.nombreUsuario,
                                        usuario.password,
                                        usuario.age,
                                        usuario.height,
                                        usuario.weight,
                                        usuario.gender,
                                        usuario.activity,
                                        _objectiveSeleccionado,
                                        usuario.imageString);

                                    requerimientoCalorico = _factorActividad(
                                        usuario.activity,
                                        _tmb,
                                        _objectiveSeleccionado,
                                        _peso);
                                    print(requerimientoCalorico);
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      value: 'ninguno',
                                      child: Text('Ninguno'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'perder peso rapidamente',
                                      child: Text('Perder peso rapidamente'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'perder peso lentamente',
                                      child: Text('Perder peso lentamente'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'mantener peso',
                                      child: Text('Mantener peso'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'aumentar peso rapidamente',
                                      child: Text('Aumentar peso rapidamente'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'aumentar peso lentamente',
                                      child: Text('Aumentar peso lentamente'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                if (usuario.objective == "ninguno") ...[
                                  Text("No se ha establecido ningún objetivo"),
                                  Text(
                                      "Introduzca su objetivo para poder ver esta sección"),
                                  Text(
                                      "Segun su objetivo se calculara su requerimiento calorico"),
                                ] else ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Calorias:",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        "${requerimientoCalorico['calories'].toStringAsFixed(2)} KCal",
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Proteinas:",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: const Color.fromARGB(
                                                238, 104, 201, 253)),
                                      ),
                                      Text(
                                        "${requerimientoCalorico['protein'].toStringAsFixed(2)} g",
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Hidratos:",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: const Color.fromARGB(
                                                251, 93, 223, 54)),
                                      ),
                                      Text(
                                        "${requerimientoCalorico['carb'].toStringAsFixed(2)} g",
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Grasas:",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: const Color.fromARGB(
                                                234, 236, 97, 87)),
                                      ),
                                      Text(
                                        "${requerimientoCalorico['fat'].toStringAsFixed(2)} g",
                                      ),
                                    ],
                                  ),
                                  PieChart(
                                    dataMap: {
                                      "Proteínas":
                                          requerimientoCalorico['protein'],
                                      "Hidratos": requerimientoCalorico['carb'],
                                      "Grasas": requerimientoCalorico['fat'],
                                    },
                                    chartRadius: 100,
                                    ringStrokeWidth: 10,
                                    colorList: [
                                      Color.fromARGB(238, 104, 201, 253),
                                      Color.fromARGB(251, 93, 223, 54),
                                      Color.fromARGB(234, 236, 97, 87),
                                    ], // especifica colores para los segmentos
                                    legendOptions: LegendOptions(
                                      showLegends: false,
                                      legendPosition: LegendPosition
                                          .right, // coloca la leyenda a la derecha del gráfico
                                      legendTextStyle: TextStyle(
                                          fontSize: 5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    chartValuesOptions: ChartValuesOptions(
                                      showChartValueBackground: true,
                                      chartValueBackgroundColor:
                                          Colors.grey[200],
                                      chartValueStyle: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                      showChartValuesInPercentage: true,
                                      // coloca un fondo gris para los valores del gráfico
                                    ),
                                    chartType: ChartType.ring,
                                    //ringStrokeWidthFactor: 0.3,
                                    // utiliza un gráfico de pastel de anillo
                                  ),
                                ],
                              ],
                            ),
                          ),
                        )
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
        ]));
  }
}
