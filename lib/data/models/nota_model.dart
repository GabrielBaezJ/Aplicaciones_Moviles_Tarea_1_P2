import '../../domain/entities/nota.dart';

class NotaModel extends Nota {
  NotaModel({
    required super.id,
    required super.estudianteId,
    required super.asignaturaId,
    required super.valor,
  });

  factory NotaModel.fromJson(Map<String, dynamic> json) {
    return NotaModel(
      id: int.tryParse(json['id'].toString()),
      estudianteId: int.parse(json['estudianteId'].toString()),
      asignaturaId: int.parse(json['asignaturaId'].toString()),
      valor: double.parse(json['valor'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estudianteId': estudianteId,
      'asignaturaId': asignaturaId,
      'valor': valor,
    };
  }
}
