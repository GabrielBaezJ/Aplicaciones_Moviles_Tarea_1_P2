import '../../domain/entities/asignatura.dart';
import '../../domain/repositories/asignatura_repository.dart';
import '../datasources/asignatura_api.dart';
import '../models/asignatura_model.dart';

class AsignaturaRepositoryImpl implements AsignaturaRepository {
  final AsignaturaApi api;

  AsignaturaRepositoryImpl({required this.api});

  AsignaturaModel _aModelo(Asignatura a) {
    return AsignaturaModel(id: a.id, nombre: a.nombre, codigo: a.codigo);
  }

  @override
  Future<List<Asignatura>> obtenerAsignaturas() {
    return api.obtenerAsignaturas();
  }

  @override
  Future<Asignatura> crearAsignatura(Asignatura asignatura) {
    return api.crearAsignatura(_aModelo(asignatura));
  }

  @override
  Future<Asignatura> actualizarAsignatura(Asignatura asignatura) {
    return api.actualizarAsignatura(_aModelo(asignatura));
  }

  @override
  Future<void> eliminarAsignatura(int id) {
    return api.eliminarAsignatura(id);
  }
}