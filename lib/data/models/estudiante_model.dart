import '../../domain/entities/estudiantes.dart';

class EstudianteModel extends Estudiante {
  EstudianteModel({
    required super.id,
    required super.nombre,
    required super.apellido,
    required super.email,
  });

  factory EstudianteModel.fromJson(Map<String, dynamic> json) {
    return EstudianteModel(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      email: json['email'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {'nombre': nombre, 'apellido': apellido, 'email': email};
  }
}
