import '../entities/asignatura.dart';
import '../repositories/asignatura_repository.dart';

class CrearAsignatura {
  final AsignaturaRepository repository;

  CrearAsignatura({required this.repository});

  Future<Asignatura> ejecutar(Asignatura asignatura) {
    return repository.crearAsignatura(asignatura);
  }
}