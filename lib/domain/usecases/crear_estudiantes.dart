import '../entities/estudiantes.dart';
import '../repositories/estudiante_repository.dart';

class CrearEstudiantes {
  final EstudianteRepository repository;

  CrearEstudiantes({required this.repository});

  Future<Estudiante> ejecutar(Estudiante estudiante) {
    return repository.crearEstudiante(estudiante);
  }
}
