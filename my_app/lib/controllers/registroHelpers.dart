import 'dart:core';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'dart:convert';


//final urlConexion = 'http://34.77.36.66:8080';
final urlConexion = 'http://localhost:8080';

class RegistroHelper {

    // Add Registro
  Future<http.Response> addRegistro(
    Int codigoDeBarrasController,
    Double cantidadController,
    String nombreUsuarioController,
    String fechaController,
    String tipoDeComidaController,
  ) async {
    var url = "${urlConexion}/registro/add";
    Map data = {
      'codigoDeBarras' : codigoDeBarrasController,
      'cantidad' : cantidadController,
      'nombreUsuario': nombreUsuarioController,
      'fecha' : fechaController,
      'tipoDeComida' : tipoDeComidaController,

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
    var url = "${urlConexion}/registro/{id}";
    var response = await http
        .delete(Uri.parse(url), headers: {"Content-Type": "application/json"});
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

}