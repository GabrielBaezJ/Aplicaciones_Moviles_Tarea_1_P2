import '../repositories/estudiante_repository.dart';

class EliminarEstudiante {
  final EstudianteRepository repository;
  final Future<bool> Function(int estudiante) tieneNotas;

  EliminarEstudiante({required this.repository, required this.tieneNotas});

  Future<void> ejecutar(int id) async {
    if (await tieneNotas(id)) {
      throw Exception(
        'No se puede eliminar: el estudiante tiene notas registradas'
        'Elimine primero sus registros académicos',
      );
    }
    return repository.eliminarEstudiante(id);
  }
}
