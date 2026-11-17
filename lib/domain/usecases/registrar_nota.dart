import '../entities/nota.dart';
import '../repositories/asignatura_repository.dart';
import '../repositories/estudiante_repository.dart';
import '../repositories/nota_repository.dart';

class RegistrarNota {
  final NotaRepository notaRepository;
  final EstudianteRepository estudianteRepository;
  final AsignaturaRepository asignaturaRepository;

  RegistrarNota({
    required this.notaRepository,
    required this.estudianteRepository,
    required this.asignaturaRepository,
  });

  Future<Nota> ejecutar(Nota nota) async {
    if (nota.valor < 0 || nota.valor > 20) {
      throw Exception('La nota debe estar entre 0 y 20');
    }

    final estudiantes = await estudianteRepository.obtenerEstudiante();
    if (!estudiantes.any((estudiante) => estudiante.id == nota.estudianteId)) {
      throw Exception('El estudiante seleccionado no existe');
    }

    final asignaturas = await asignaturaRepository.obtenerAsignaturas();
    if (!asignaturas.any((asignatura) => asignatura.id == nota.asignaturaId)) {
      throw Exception('La asignatura seleccionada no existe');
    }

    return notaRepository.registrarNota(nota);
  }
}
