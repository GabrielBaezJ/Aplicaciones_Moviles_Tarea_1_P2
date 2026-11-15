import '../repositories/asignatura_repository.dart';

class ExisteAsignatura {
  final AsignaturaRepository repository;

  ExisteAsignatura({required this.repository});

  Future<bool> ejecutar(int asignaturaId) async {
    final asignaturas = await repository.obtenerAsignaturas();
    return asignaturas.any((a) => a.id == asignaturaId);
  }
}