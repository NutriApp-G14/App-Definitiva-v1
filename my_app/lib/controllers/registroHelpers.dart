import 'dart:core';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'dart:convert';


//final urlConexion = 'http://34.77.36.66:8080';
//final urlConexion = 'http://35.241.179.64:8080';
final urlConexion = 'http://localhost:8080';

class RegistroHelper {

    // Add Registro
  Future<http.Response> addRegistro(
    String codigoDeBarrasController,
    double cantidadController,
    String nombreUsuarioController,
    String fechaController,
    String tipoDeComidaController,
    String nombreAlimento
  ) async {
    print("Funcion ejecutada");
    var url = "${urlConexion}/registro/add";
    Map data = {
      'codigoDeBarras' : codigoDeBarrasController,
      'cantidad' : cantidadController,
      'nombreUsuario': nombreUsuarioController,
      'fecha' : fechaController,
      'tipoDeComida' : tipoDeComidaController,
      'nombreAlimento' :nombreAlimento

    };
    var body = json.encode(data);
    
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    return response;
  }

  // Borrar Registro
  Future<http.Response> deleteRegistro(int id) async {
    var url = "${urlConexion}/registro/{id}";
    var response = await http
        .delete(Uri.parse(url), headers: {"Content-Type": "application/json"});
    print("${response.statusCode}");
    return response;
  }

  // Obtiene los registros a partir de su nombre de usuario,fecha y tipodeComida
  Future<List> getRegistroComidas(String nombreUsuario, String tipoDeComida, String fecha) async {
  

    final response =  await http.get(Uri.parse("${urlConexion}/registro/registros/$fecha/$tipoDeComida/$nombreUsuario"));

    return json.decode(response.body);
  }





}
