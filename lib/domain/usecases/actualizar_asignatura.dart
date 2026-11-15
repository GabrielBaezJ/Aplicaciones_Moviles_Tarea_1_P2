import '../entities/asignatura.dart';
import '../repositories/asignatura_repository.dart';

class ActualizarAsignatura {
  final AsignaturaRepository repository;

  ActualizarAsignatura({required this.repository});

  Future<Asignatura> ejecutar(Asignatura asignatura) {
    return repository.actualizarAsignatura(asignatura);
  }
}