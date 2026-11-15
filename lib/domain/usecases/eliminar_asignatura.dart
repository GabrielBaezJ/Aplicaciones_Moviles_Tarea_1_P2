import '../repositories/asignatura_repository.dart';

class EliminarAsignatura {
  final AsignaturaRepository repository;

  EliminarAsignatura({required this.repository});

  Future<void> ejecutar(int id) {
    return repository.eliminarAsignatura(id);
  }
}