import '../../domain/entities/estudiantes.dart';
import '../../domain/repositories/estudiante_repository.dart';
import '../datasources/estudiante_api.dart';
import '../models/estudiante_model.dart';

class EstudianteRepositoryImpl implements EstudianteRepository {
  final EstudianteApi api;

  EstudianteRepositoryImpl({required this.api});

  @override
  Future<Estudiante> actualizarEstudiante(Estudiante estudiante) {
    final model = EstudianteModel(
      id: estudiante.id,
      idRemoto: estudiante.idRemoto,
      nombre: estudiante.nombre,
      apellido: estudiante.apellido,
      email: estudiante.email,
    );
    return api.actualizarEstudiante(model);
  }

  @override
  Future<Estudiante> crearEstudiante(Estudiante estudiante) {
    final model = EstudianteModel(
      id: estudiante.id,
      idRemoto: estudiante.idRemoto,
      nombre: estudiante.nombre,
      apellido: estudiante.apellido,
      email: estudiante.email,
    );
    return api.crearEstudiante(model);
  }

  @override
  Future<void> eliminarEstudiante(int id) {
    return api.eliminarEstudiante(id);
  }

  @override
  Future<List<Estudiante>> obtenerEstudiante() {
    return api.obtenerEstudiantes();
  }
}
