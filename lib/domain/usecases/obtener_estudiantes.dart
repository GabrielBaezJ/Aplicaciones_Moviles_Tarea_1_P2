import '../entities/estudiantes.dart';
import '../repositories/estudiante_repository.dart';

class ObtenerEstudiantes {
  final EstudianteRepository repository;

  ObtenerEstudiantes({required this.repository});

  Future<List<Estudiante>> ejecutar() {
    return repository.obtenerEstudiante();
  }
}
