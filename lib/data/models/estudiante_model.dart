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
      id: int.tryParse(json['id']?.toString() ?? ''),
      nombre: json['nombre']?.toString() ?? '',
      apellido: json['apellido']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {'nombre': nombre, 'apellido': apellido, 'email': email};
  }
}
