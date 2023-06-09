import 'dart:core';
import 'package:http/io_client.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:my_app/model/Alergias.dart';
import 'package:my_app/model/Alimento.dart';
import 'package:my_app/model/Usuario.dart';

final urlConexion = 'https://35.205.198.163:8443';

class DataBaseHelper {
// Add Alimento
  Future<http.Response> addAlimento(
      String nameController,
      double cantidadController,
      String unidadesCantidadController,
      double caloriasController,
      double grasasController,
      double proteinasController,
      double carbohidratosController,
      String imageController,
      String nombreUsuarioController,
      double sodioController,
      double azucarController,
      double fibraController,
      String codigoDeBarrasController,
      List<String> alergenosController,
      String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    var url = "${urlConexion}/foods/add";
    Map data = {
      'name': nameController,
      'unidadesCantidad': unidadesCantidadController,
      'cantidad': '$cantidadController',
      'calorias': '$caloriasController',
      'grasas': '$grasasController',
      'proteinas': '$proteinasController',
      'carbohidratos': '$carbohidratosController',
      'image': imageController,
      'nombreUsuario': nombreUsuarioController,
      'sodio': sodioController,
      'azucar': azucarController,
      'fibra': fibraController,
      'codigoDeBarras': codigoDeBarrasController,
      'alergenos': alergenosController,
    };
    var body = json.encode(data);
    var response = await ioClient.post(Uri.parse(url),
        headers: {"Content-Type": "application/json", "Authorization": token},
        body: body);
    print("${response.statusCode}");
    return response;
  }

  // Add Usuario
  Future<int> addUsuario(
    String nombreController,
    String nombreUsuarioController,
    String passwordController,
    String? ageController,
    String? heightController,
    String? weightController,
    String? genderController,
    String? activityController,
    String? objectiveController,
    String? imageController,
  ) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    var url = "${urlConexion}/users/add";
    Map data = {
      'nombre': nombreController,
      'nombreUsuario': nombreUsuarioController,
      'password': passwordController,
      'age': ageController,
      'height': heightController,
      'weight': weightController,
      'gender': genderController,
      'activity': activityController,
      'objective': objectiveController,
      'imageString': imageController,
      'roles': ["ROLE_USER"]
      //'allergies': allergiesController
    };
    var body = json.encode(data);
    var response = await ioClient.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: body);
    print("${response.statusCode}");

    return response.statusCode;
  }

//add Alergias
  Future<http.Response> addAlergias(
      String nombreUsuarioController,
      bool cacahuetesController,
      bool lecheController,
      bool huevoController,
      bool trigoController,
      bool sojaController,
      bool mariscosController,
      bool frutosSecosController,
      bool pescadoController,
      String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    var url = "${urlConexion}/allergies/add";
    Map data = {
      'nombreUsuario': nombreUsuarioController,
      'cacahuetes': cacahuetesController,
      'leche': lecheController,
      'huevo': huevoController,
      'trigo': trigoController,
      'soja': sojaController,
      'frutosSecos': frutosSecosController,
      'mariscos': mariscosController,
      'pescado': pescadoController
    };
    var body = json.encode(data);
    var response = await ioClient.post(Uri.parse(url),
        headers: {"Content-Type": "application/json", "Authorization": token},
        body: body);
    print("Codigo Alergias: ${response.statusCode}");
    return response;
  }

  Future<http.Response> addReceta(
      String nombre,
      int porciones,
      String unidadesMedida,
      String descripcion,
      List<Alimento> ingredientes,
      List<String> pasos,
      String imagen,
      String nombreUsuario,
      String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    var url = "${urlConexion}/recipes/add";
    List<Map<String, dynamic>> ingredientesData = [];
    for (var i = 0; i < ingredientes.length; i++) {
      var ingrediente = ingredientes[i];
      Map<String, dynamic> ingredienteData = {
        'name': ingrediente.name,
        'cantidad': ingrediente.cantidad,
        'unidadesCantidad': ingrediente.unidadesCantidad,
        'calorias': ingrediente.calorias,
        'grasas': ingrediente.grasas,
        'proteinas': ingrediente.proteinas,
        'carbohidratos': ingrediente.carbohidratos,
        'image': ingrediente.image,
        'nombreUsuario': nombreUsuario,
        'receta': nombre,
      };
      ingredientesData.add(ingredienteData);
    }
    Map data = {
      'nombre': nombre,
      'porciones': porciones,
      'unidadesMedida': unidadesMedida,
      'descripcion': descripcion,
      'ingredientes': ingredientesData,
      'pasos': pasos,
      'imagen': imagen,
      'nombreUsuario': nombreUsuario,
    };
    var body = json.encode(data);
    var response = await ioClient.post(Uri.parse(url),
        headers: {"Content-Type": "application/json", "Authorization": token},
        body: body);
    print("${response.statusCode}");
    return response;
  }

  // // Método para agregar un ingrediente a la lista de ingredientes de la receta
  Future agregarAlimento(int idReceta, Alimento alimento, String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    final url = Uri.parse('$urlConexion/$idReceta/addIngrediente');
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": token
    };
    final body = json.encode(alimento.toJson());
    final response = await ioClient.post(url, headers: headers, body: body);
    if (response.statusCode != 200) {
      throw Exception('Error al agregar alimento a la receta');
    }
    return json.decode(response.body);
  }

// Método para agregar un paso a la lista de pasos de la receta
  // Future<http.Response> addPaso(String paso, int recetaId) async {
  //   var url = "${urlConexion}/recipes/$recetaId/pasos";
  //   Map data = {'paso': paso};
  //   var body = json.encode(data);
  //   var response = await ioClient.post(Uri.parse(url),
  //       headers: {"Content-Type": "application/json"}, body: body);
  //   print("${response.statusCode}");
  //   print("${response.body}");
  //   return response;
  // }

// Funciones para Usuario

// Obtener un Usuario al Iniciar sesión comprobando la contraseña
  Future<Usuario?> getUsuario(String nombreUsuario, String password) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);
    final response =
        await ioClient.get(Uri.parse('${urlConexion}/users/$nombreUsuario'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final usuario = Usuario.fromJson(json);
      if (usuario.password == password) {
        return usuario;
      }
    }
    return null;
  }

// Comprueba si el Usuario Ya existe en la BBDD
  Future<bool> usuarioExists(String nombreUsuario) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);
    var url = Uri.parse("${urlConexion}/users/$nombreUsuario");
    //print(await ioClient.get(url));
    var response = await ioClient.get(url);
    if (response.statusCode == 200) {
      // var data = jsonDecode(response.body) as List<dynamic>;
      // return data.isNotEmpty;
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception("Failed to check if user exists");
    }
  }

// Obtener un Usuario con el Nombre de Usuario (id)
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

  Future<Usuario?> getUsuarioByNombreUsuarioParaLogin(
      String nombreUsuario) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    final response =
        await ioClient.get(Uri.parse('${urlConexion}/users/$nombreUsuario'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Usuario.fromJson(jsonData);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error al cargar el usuario');
    }
  }

// Actualizar Usuario
  Future<http.Response> updateUsuario(
      String nombreController,
      String nombreUsuarioController,
      String passwordController,
      String? ageController,
      String? heightController,
      String? weightController,
      String? genderController,
      String? activityController,
      String? objectiveController,
      String? imageController,
      String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    var url = "${urlConexion}/users/$nombreUsuarioController";
    Map data = {
      'nombre': nombreController,
      'nombreUsuario': nombreUsuarioController,
      'password': passwordController,
      'age': ageController,
      'height': heightController,
      'weight': weightController,
      'gender': genderController,
      'activity': activityController,
      'objective': objectiveController,
      'imageString': imageController,
    };
    var body = json.encode(data);
    var response = await ioClient.put(Uri.parse(url),
        headers: {"Content-Type": "application/json", "Authorization": token},
        body: body);
    print("${response.statusCode}");
    return response;
  }

  // Actualizar Usuario
  Future<http.Response> updatePassword(
    String nombreUsuarioController,
    String passwordController,
  ) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    var url = "${urlConexion}/users/password/$nombreUsuarioController";
    Map data = {
      'password': passwordController,
    };
    var body = json.encode(data);
    var response = await ioClient.put(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: body);
    print("${response.statusCode}");

    return response;
  }

// Funciones Para Alergías

// Obtienen las Alergía de un Usuario a partir de su nombre de Usuario
  Future<Alergias> getAlergiasById(String nombreUsuario, String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    final response = await ioClient
        .get(Uri.parse('${urlConexion}/allergies/$nombreUsuario'), headers: {
      "Content-Type": "application/json",
      "Authorization": "$token"
    });

    print("estado ${response.statusCode}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Alergias.fromJson(jsonData);
    } else {
      throw Exception('Error al cargar el usuario');
    }
  }

  // Obtienen las Alergenos del nombre del alimento
  // Future<Alergenos> getAlergenosById(String name) async {
  //   final response =
  //       await http.get(Uri.parse('${urlConexion}/allergens/$name'));
  //   if (response.statusCode == 200) {
  //     final jsonData = jsonDecode(response.body);
  //     return Alergenos.fromJson(jsonData);
  //   } else {
  //     throw Exception('Error al cargar el usuario');
  //   }
  // }

  //actualizaAlimentos
  Future<http.Response> updateAlimento(
      int idController,
      String nameController,
      double cantidadController,
      String unidadesCantidadController,
      double caloriasController,
      double grasasController,
      double proteinasController,
      double carbohidratosController,
      String imageController,
      String nombreUsuarioController,
      double sodioController,
      double azucarController,
      double fibraController,
      String codigoDeBarrasController,
      List<String> alergenosController,
      String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    var url = "${urlConexion}/foods/$idController";
    Map data = {
      'name': nameController,
      'cantidad': cantidadController,
      'unidadesCantidad': unidadesCantidadController,
      'calorias': caloriasController,
      'grasas': grasasController,
      'proteinas': proteinasController,
      'carbohidratos': carbohidratosController,
      'image': imageController,
      'nombreUsuario': nombreUsuarioController,
      'sodio': sodioController,
      'azucar': azucarController,
      'fibra': fibraController,
      'codigoDeBarras': codigoDeBarrasController,
      'alergenos': alergenosController
    };
    var body = json.encode(data);
    var response = await ioClient.put(Uri.parse(url),
        headers: {"Content-Type": "application/json", "Authorization": token},
        body: body);
    //Navigator.pop(context);
    return response;
  }

// Actualiza Alergias
  Future<http.Response> updateAlergias(
      String nombreUsuarioController,
      bool cacahuetesController,
      bool lecheController,
      bool huevoController,
      bool trigoController,
      bool sojaController,
      bool mariscosController,
      bool frutosSecosController,
      bool pescadoController,
      String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    var url = "${urlConexion}/allergies/$nombreUsuarioController";
    Map data = {
      'nombreUsuario': nombreUsuarioController,
      'cacahuetes': cacahuetesController,
      'leche': lecheController,
      'huevo': huevoController,
      'trigo': trigoController,
      'soja': sojaController,
      'frutosSecos': frutosSecosController,
      'mariscos': mariscosController,
      'pescado': pescadoController
    };
    var body = json.encode(data);
    var response = await ioClient.put(Uri.parse(url),
        headers: {"Content-Type": "application/json", "Authorization": token},
        body: body);
    print("${response.statusCode}");
    return response;
  }

//Funciones para Receta

// Método para eliminar una receta por ID
  Future<http.Response> deleteReceta(int recetaId, String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    var url = "${urlConexion}/recipes/$recetaId";
    var response = await http.delete(Uri.parse(url),
        headers: {"Content-Type": "application/json", "Authorization": token});
    print("${response.statusCode}");
    return response;
  }

// Método para obtener todas las recetas de un usuario por nombre de usuario
  Future<List> getRecetas(String nombreUsuario, String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    final response = await ioClient.get(
        Uri.parse("${urlConexion}/recipes/user/$nombreUsuario"),
        headers: {"Authorization": token});
    return json.decode(response.body);
  }

  //Actualizar Receta
  Future<http.Response> updateReceta(
      String idController,
      String nombreController,
      int porcionesController,
      String unidadesMedidaController,
      String descripcionController,
      List<Alimento> ingredientesController,
      List<String> pasosController,
      String imagenController,
      String nombreUsuarioController,
      String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    var url = "${urlConexion}/recipes/$idController";
    Map data = {
      'nombre': nombreController,
      'porciones': porcionesController.toString(),
      'unidadesMedida': unidadesMedidaController,
      'descripcion': descripcionController,
      'ingredientes': jsonEncode(
          ingredientesController.map((alimento) => alimento.toJson()).toList()),
      'pasos': jsonEncode(pasosController),
      'imagen': imagenController,
      'nombreUsuario': nombreUsuarioController,
    };
    var body = json.encode(data);
    var response = await ioClient.put(Uri.parse(url),
        headers: {"Content-Type": "application/json", "Authorization": token},
        body: body);
    print("${response.statusCode}");
    return response;
  }

// Funciones Para Alimentos

// Obtener un Alimento al añadirlo
  Future<bool> getAlimento(int id, String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    final response = await ioClient.get(Uri.parse('${urlConexion}/foods/$id'),
        headers: {"Authorization": token});
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

// Borrar Alimento
  Future<http.Response> deleteAlimento(int id, String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    var url = "${urlConexion}/foods/{id}";
    var response = await ioClient.delete(Uri.parse(url),
        headers: {"Content-Type": "application/json", "Authorization": token});
    print("${response.statusCode}");
    return response;
  }

// Obtiene los alimentos de un usuario a partir de su nombre de usuario
  Future<List> getData(String nombreUsuario, String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    final response = await ioClient.get(
        Uri.parse("${urlConexion}/foods/user/$nombreUsuario"),
        headers: {"Authorization": token});

    return json.decode(response.body);
  }
}
