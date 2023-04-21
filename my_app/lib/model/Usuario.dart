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
  final String imageProfile;
  //final List<String> allergies;


  Usuario( this.nombre, this.nombreUsuario, this.password,  this.age,
             this.height, this.weight, this.gender, this.activity, this.objective, this.imageProfile);

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
      json['imageProfile']


    );
  }
}