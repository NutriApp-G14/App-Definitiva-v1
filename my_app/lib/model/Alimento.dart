class Alimento {
  final String name;
  final double cantidad;
  final String unidadesCantidad;
  final double calorias;
  final double grasas;
  final double proteinas;
  final double carbohidratos;
  final double sodio;
  final double azucar;
  final double fibra;
  final String image;

  Alimento({
    required this.name,
    required this.cantidad,
    required this.unidadesCantidad,
    required this.calorias,
    required this.grasas,
    required this.proteinas,
    required this.carbohidratos,
    required this.azucar,
    required this.fibra,
    required this.sodio,
    required this.image,
  });

  factory Alimento.fromJson(Map<String, dynamic> json) {
    return Alimento(
      name: json['name'] as String,
      cantidad: json['cantidad'] as double,
      unidadesCantidad: json['unidadesCantidad'] as String,
      calorias: json['calorias'] as double,
      grasas: json['grasas'] as double,
      proteinas: json['proteinas'] as double,
      carbohidratos: json['carbohidratos'] as double,
      azucar: json['azucar'] as double,
      fibra: json['fibra'] as double,
      sodio: json['sodio'] as double,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cantidad': cantidad,
      'unidadesCantidad': unidadesCantidad,
      'calorias': calorias,
      'grasas': grasas,
      'proteinas': proteinas,
      'carbohidratos': carbohidratos,
      'sodio': sodio,
      'azucar': azucar,
      'fibre': fibra,
      'image': image,
    };
  }
}
