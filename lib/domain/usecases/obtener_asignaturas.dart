import '../entities/asignatura.dart';
import '../repositories/asignatura_repository.dart';

class ObtenerAsignaturas {
  final AsignaturaRepository repository;

  ObtenerAsignaturas({required this.repository});

  Future<List<Asignatura>> ejecutar() {
    return repository.obtenerAsignaturas();
  }
}