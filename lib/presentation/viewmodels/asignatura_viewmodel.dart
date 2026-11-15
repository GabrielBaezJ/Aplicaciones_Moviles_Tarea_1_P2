import 'package:flutter/material.dart';
import '../../domain/entities/asignatura.dart';
import '../../domain/usecases/actualizar_asignatura.dart';
import '../../domain/usecases/crear_asignatura.dart';
import '../../domain/usecases/eliminar_asignatura.dart';
import '../../domain/usecases/obtener_asignaturas.dart';

class AsignaturaViewModel extends ChangeNotifier {
  final ObtenerAsignaturas obtenerAsignaturas;
  final CrearAsignatura crearAsignatura;
  final ActualizarAsignatura actualizarAsignatura;
  final EliminarAsignatura eliminarAsignatura;

  AsignaturaViewModel({
    required this.obtenerAsignaturas,
    required this.crearAsignatura,
    required this.actualizarAsignatura,
    required this.eliminarAsignatura,
  });

  List<Asignatura> asignaturas = [];
  bool cargando = false;
  String? error;

  Future<void> cargarAsignaturas() async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      asignaturas = await obtenerAsignaturas.ejecutar();
    } catch (e) {
      error = e.toString();
    }
    cargando = false;
    notifyListeners();
  }

  Future<bool> agregar(Asignatura asignatura) async {
    try {
      final nueva = await crearAsignatura.ejecutar(asignatura);
      asignaturas.add(nueva);
      error = null;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> editar(Asignatura asignatura) async {
    try {
      final actualizada = await actualizarAsignatura.ejecutar(asignatura);
      final i = asignaturas.indexWhere((a) => a.id == asignatura.id);
      if (i != -1) asignaturas[i] = actualizada;
      error = null;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminar(int id) async {
    try {
      await eliminarAsignatura.ejecutar(id);
      asignaturas.removeWhere((a) => a.id == id);
      error = null;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}