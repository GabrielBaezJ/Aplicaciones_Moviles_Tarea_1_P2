import '../entities/estudiantes.dart';

abstract class EstudianteRepository {
  Future<List<Estudiante>> obtenerEstudiante();
  Future<Estudiante> crearEstudiante(Estudiante estudiante);
  Future<Estudiante> actualizarEstudiante(Estudiante estudiante);
  Future<void> eliminarEstudiante(int id);
}
