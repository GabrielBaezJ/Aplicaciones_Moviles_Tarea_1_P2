import '../../domain/entities/estudiantes.dart';

class EstudianteModel extends Estudiante {
  EstudianteModel({
    required super.id,
    super.idRemoto,
    required super.nombre,
    required super.apellido,
    required super.email,
  });

  factory EstudianteModel.fromJson(Map<String, dynamic> json) {
    final clave = json['id'] ?? json['ID'] ?? json['Id'] ??
        json['idEstudiante'] ?? json['estudianteId'] ?? json['id_estudiante'];
    final idRemoto = clave?.toString();
    return EstudianteModel(
      id: int.tryParse(idRemoto ?? ''),
      idRemoto: idRemoto,
      nombre: json['nombre']?.toString() ?? '',
      apellido: json['apellido']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {'nombre': nombre, 'apellido': apellido, 'email': email};
  }
}
