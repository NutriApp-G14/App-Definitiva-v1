import 'dart:core';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'dart:convert';

//final urlConection = 'http://34.77.36.66:8080';
final urlConection = 'http://localhost:8080';

class RegistroHelper {
  // Add Registro
  Future<http.Response> addRegistro(
    String codigoDeBarrasController,
    double cantidadController,
    String nombreUsuarioController,
    String fechaController,
    String tipoDeComidaController,
  ) async {
    print("Funcion ejecutada");
    var url = "${urlConection}/registro/add";
    Map data = {
      'codigoDeBarras': codigoDeBarrasController,
      'cantidad': cantidadController,
      'nombreUsuario': nombreUsuarioController,
      'fecha': fechaController,
      'tipoDeComida': tipoDeComidaController,
    };
    var body = json.encode(data);

    print(body);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  // Borrar Registro
  Future<http.Response> deleteRegistro(int id) async {
    var url = "${urlConection}/registro/{id}";
    var response = await http
        .delete(Uri.parse(url), headers: {"Content-Type": "application/json"});
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  // Obtiene los registros a partir de su nombre de usuario,fecha y tipodeComida
  Future<List> getRegistroComidas(
      String nombreUsuario, String tipoDeComida, String fecha) async {
    print("buscando registros...");
    print(nombreUsuario);
    print(tipoDeComida);
    print(fecha);

    final response = await http.get(Uri.parse(
        "${urlConection}/registro/registros/$fecha/$tipoDeComida/$nombreUsuario"));
    print("termino de buscar");
    print(response.body);
    return json.decode(response.body);
  }
}
