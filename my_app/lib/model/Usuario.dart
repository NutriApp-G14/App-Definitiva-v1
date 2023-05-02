class Usuario {
  final String nombre;
  final String nombreUsuario;
  final String password;
  final String age;
  final String height;
  final String weight;
  final String gender;
  final String activity;
  final String objective;
  final String imageString;
  //final List<String> allergies;

  Usuario(
      this.nombre,
      this.nombreUsuario,
      this.password,
      this.age,
      this.height,
      this.weight,
      this.gender,
      this.activity,
      this.objective,
      this.imageString);

  String get _password => password;

  void setPassword(String password) {
    // expresión regular que valida que la contraseña tenga al menos 8 caracteres y una mayúscula
    final passwordRegExp = RegExp(r'^(?=.*[A-Z]).{8,}$');

    if (!passwordRegExp.hasMatch(password)) {
      throw ArgumentError(
          'La contraseña debe tener al menos 8 caracteres y una letra mayúscula.');
    }
    password = _password;
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      json['nombre'],
      json['nombreUsuario'],
      json['password'],
      json['age'],
      json['height'],
      json['weight'],
      json['gender'],
      json['activity'],
      json['objective'],
      json['imageString'],
    );
  }
}
