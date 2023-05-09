import 'dart:core';
import 'package:http/io_client.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:my_app/model/Alimento.dart';

final urlConection = 'https://localhost:8443';



class RegistroHelper {

  Future<http.Response> addRegistro(
      String codigoDeBarrasController,
      double cantidadController,
      String nombreUsuarioController,
      String fechaController,
      String tipoDeComidaController,
      String nombreAlimento,
      List<Alimento> alimento,
      String token)async {
    HttpClient httpClient = new HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  IOClient ioClient = IOClient(httpClient);

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

    var response = await ioClient.post(Uri.parse(url),
        headers: {"Content-Type": "application/json", "Authorization" : token}, body: body);
    print("${response.statusCode}");
    return response;
  }

// Borrar Registro
  Future<http.Response> deleteRegistro(int id, String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    var url = "${urlConection}/registro/reg/{id}";
    var response = await http
        .delete(Uri.parse(url), headers: {"Content-Type": "application/json", "Authorization" : token});
    print("${response.statusCode}");
    return response;
  }

  // Obtiene los registros a partir de su nombre de usuario,fecha y tipodeComida
  Future<List> getRegistroComidas(
      String nombreUsuario, String tipoDeComida, String fecha, String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    final response = await ioClient.get(Uri.parse(
        "${urlConection}/registro/registros/$fecha/$tipoDeComida/$nombreUsuario"),headers: {"Authorization" : token});

    return json.decode(response.body);
  }

  Future<List> getRegistroDiario(String nombreUsuario, String fecha, String token) async {
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    final response = await ioClient.get(
        Uri.parse("${urlConection}/registro/registros/$fecha/$nombreUsuario"),headers: { "Authorization" : token});

    return json.decode(response.body);
  }
}
