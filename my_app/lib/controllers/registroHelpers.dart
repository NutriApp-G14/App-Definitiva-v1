import 'dart:core';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_app/model/Alimento.dart';

//final urlConection = 'http://34.77.36.66:8080';
//final urlConection = 'http://35.241.179.64:8080';
//final urlConection = 'http://34.77.252.254:8080';
//final urlConection = 'http://34.77.252.254:8080';

//final urlConection = 'http://35.189.241.218:8080';
//final urlConection = 'http://35.189.241.218:8080';
//final urlConection = 'http://35.241.179.64:8080';

final urlConection = 'http://localhost:8080';


class RegistroHelper {
  // Add Registro
  Future<http.Response> addRegistro(
      String codigoDeBarrasController,
      double cantidadController,
      String nombreUsuarioController,
      String fechaController,
      String tipoDeComidaController,
      String nombreAlimento,
      List<Alimento> alimento) async {
    print("Funcion ejecutada");
    var url = "${urlConection}/registro/add";
    Map data = {
      'codigoDeBarras': codigoDeBarrasController,
      'cantidad': cantidadController,
      'nombreUsuario': nombreUsuarioController,
      'fecha': fechaController,
      'tipoDeComida': tipoDeComidaController,
      'nombreAlimento': nombreAlimento,
      'alimentos': alimento,
    };
    var body = json.encode(data);

    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    return response;
  }

// Borrar Registro
  Future<http.Response> deleteRegistro(int id) async {
    var url = "${urlConection}/registro/reg/{id}";
    var response = await http
        .delete(Uri.parse(url), headers: {"Content-Type": "application/json"});
    print("${response.statusCode}");
    return response;
  }

  // Obtiene los registros a partir de su nombre de usuario,fecha y tipodeComida
  Future<List> getRegistroComidas(
      String nombreUsuario, String tipoDeComida, String fecha) async {
    final response = await http.get(Uri.parse(
        "${urlConection}/registro/registros/$fecha/$tipoDeComida/$nombreUsuario"));

    return json.decode(response.body);
  }
}
