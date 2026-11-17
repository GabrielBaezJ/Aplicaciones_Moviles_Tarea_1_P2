import '../../domain/entities/nota.dart';
import '../../domain/repositories/nota_repository.dart';
import '../datasources/nota_remote_datasource.dart';
import '../models/nota_model.dart';

class NotaRepositoryImpl implements NotaRepository {
  final NotaRemoteDatasource datasource;

  NotaRepositoryImpl({required this.datasource});

  @override
  Future<Nota> registrarNota(Nota nota) {
    return datasource.registrarNota(
      NotaModel(
        id: nota.id,
        estudianteId: nota.estudianteId,
        asignaturaId: nota.asignaturaId,
        valor: nota.valor,
      ),
    );
  }

  @override
  Future<List<Nota>> obtenerNotasPorEstudiante(int estudianteId) {
    return datasource.obtenerNotasPorEstudiante(estudianteId);
  }

  @override
  Future<void> eliminarNota(int id) {
    return datasource.eliminarNota(id);
  }

  @override
  Future<bool> tieneNotas(int estudianteId) async {
    final notas = await obtenerNotasPorEstudiante(estudianteId);
    return notas.isNotEmpty;
  }
}
