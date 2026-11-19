class Estudiante {
  final int? id;
  // MockAPI puede identificar el registro con texto. Las notas usan el ID numérico.
  final String? idRemoto;
  final String nombre;
  final String apellido;
  final String email;

  Estudiante({
    required this.id,
    this.idRemoto,
    required this.nombre,
    required this.apellido,
    required this.email,
  });
}
