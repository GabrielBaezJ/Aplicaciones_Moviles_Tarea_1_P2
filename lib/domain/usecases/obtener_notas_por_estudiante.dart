import '../entities/nota.dart';
import '../repositories/nota_repository.dart';

class ObtenerNotasPorEstudiante {
  final NotaRepository repository;

  ObtenerNotasPorEstudiante({required this.repository});

  Future<List<Nota>> ejecutar(int estudianteId) {
    return repository.obtenerNotasPorEstudiante(estudianteId);
  }
}
