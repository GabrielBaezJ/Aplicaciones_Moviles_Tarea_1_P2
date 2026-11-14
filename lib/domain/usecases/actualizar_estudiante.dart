import '../entities/estudiantes.dart';
import '../repositories/estudiante_repository.dart';

class ActualizarEstudiante {
  final EstudianteRepository repository;

  ActualizarEstudiante({required this.repository});

  Future<Estudiante> ejecutar(Estudiante estudiante) {
    return repository.actualizarEstudiante(estudiante);
  }
}
