import '../repositories/nota_repository.dart';

class CalcularPromedio {
  final NotaRepository repository;

  CalcularPromedio({required this.repository});

  Future<double> ejecutar(int estudianteId) async {
    final notas = await repository.obtenerNotasPorEstudiante(estudianteId);
    if (notas.isEmpty) return 0;
    final suma = notas.fold<double>(0, (total, nota) => total + nota.valor);
    return suma / notas.length;
  }
}
