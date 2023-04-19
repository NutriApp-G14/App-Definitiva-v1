import 'dart:core';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/model/Alergias.dart';
import 'dart:convert';

import 'package:my_app/model/Usuario.dart';

final urlConexion = 'http://localhost:8080';

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
      double fibraController) async {
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
      'fibra': fibraController
    };
    var body = json.encode(data);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  // Add Usuario
  Future<http.Response> addUsuario(
    String nombreController,
    String nombreUsuarioController,
    String passwordController,
    String? ageController,
    String? heightController,
    String? weightController,
    String? genderController,
    String? activityController,
    String? objectiveController,
  ) async {
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
      'objective': objectiveController
      //'allergies': allergiesController
    };
    var body = json.encode(data);
    print(body);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
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
      bool pescadoController) async {
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
    print(body);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

// Funciones para Usuario

// Obtener un Usuario al Iniciar sesión comprobando la contraseña
  Future<Usuario?> getUsuario(String nombreUsuario, String password) async {
    final response =
        await http.get(Uri.parse('${urlConexion}/users/$nombreUsuario'));

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
    var url = Uri.parse("${urlConexion}/users/$nombreUsuario");
    var response = await http.get(url);
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
    final response =
        await http.get(Uri.parse('${urlConexion}/users/$nombreUsuario'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Usuario.fromJson(jsonData);
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
  ) async {
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
    };
    var body = json.encode(data);
    var response = await http.put(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

// Funciones Para Alergías

// Obtienen las Alergía de un Usuario a partir de su nombre de Usuario
  Future<Alergias> getAlergiasById(String nombreUsuario) async {
    final response =
        await http.get(Uri.parse('${urlConexion}/allergies/$nombreUsuario'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Alergias.fromJson(jsonData);
    } else {
      throw Exception('Error al cargar el usuario');
    }
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
      bool pescadoController) async {
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
    var response = await http.put(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

// Funciones Para Alimentos

// Borrar Alimento
  Future<http.Response> deleteAlimento(int id) async {
    var url = "${urlConexion}/foods/{id}";
    var response = await http
        .delete(Uri.parse(url), headers: {"Content-Type": "application/json"});
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

// Obtiene los alimentos de un usuario a partir de su nombre de usuario
  Future<List> getData(String nombreUsuario) async {
    final response =
        await http.get(Uri.parse("${urlConexion}/foods/user/$nombreUsuario"));
    return json.decode(response.body);
  }
}
