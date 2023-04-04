class Usuario {
  final String nombre;
  final String nombreUsuario;
  final String password;


  Usuario({required this.nombre, required this.nombreUsuario, required this.password});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nombre: json['nombre'],
      nombreUsuario: json['nombreUsuario'],
      password: json['password'],


    );
  }
}