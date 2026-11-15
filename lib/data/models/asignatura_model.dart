import '../../domain/entities/asignatura.dart';

class AsignaturaModel extends Asignatura {
  AsignaturaModel({
    required super.id,
    required super.nombre,
    required super.codigo,
  });

  factory AsignaturaModel.fromJson(Map<String, dynamic> json) {
    return AsignaturaModel(
      id: int.tryParse(json['id'].toString()),
      nombre: json['nombre'] ?? '',
      codigo: json['codigo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'nombre': nombre, 'codigo': codigo};
  }
}
