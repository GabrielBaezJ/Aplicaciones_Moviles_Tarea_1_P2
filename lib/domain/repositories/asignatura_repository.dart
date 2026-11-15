import '../entities/asignatura.dart';

abstract class AsignaturaRepository {
  Future<List<Asignatura>> obtenerAsignaturas();
  Future<Asignatura> crearAsignatura(Asignatura asignatura);
  Future<Asignatura> actualizarAsignatura(Asignatura asignatura);
  Future<void> eliminarAsignatura(int id);
}