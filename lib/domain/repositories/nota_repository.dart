import '../entities/nota.dart';

abstract class NotaRepository {
  Future<Nota> registrarNota(Nota nota);
  Future<List<Nota>> obtenerNotasPorEstudiante(int estudianteId);
  Future<void> eliminarNota(int id);
  Future<bool> tieneNotas(int estudianteId);
}
