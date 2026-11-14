import 'package:flutter/material.dart';

import '../../domain/entities/estudiantes.dart';
import '../../domain/usecases/actualizar_estudiante.dart';
import '../../domain/usecases/crear_estudiantes.dart';
import '../../domain/usecases/eliminar_estudiante.dart';
import '../../domain/usecases/obtener_estudiantes.dart';

class EstudianteViewModel extends ChangeNotifier {
  final ObtenerEstudiantes obtenerEstudiantes;
  final CrearEstudiantes crearEstudiantes;
  final ActualizarEstudiante actualizarEstudiante;
  final EliminarEstudiante eliminarEstudiante;

  //funcion que calcula el promedio (la implementa Nota)
  final Future<double> Function(int estudianteId) obtenerPromedio;

  EstudianteViewModel({
    required this.obtenerEstudiantes,
    required this.crearEstudiantes,
    required this.actualizarEstudiante,
    required this.eliminarEstudiante,
    required this.obtenerPromedio,
  });

  List<Estudiante> estudiantes = [];
  bool cargando = false;
  String? error;

  Future<void> cargarEstudiantes() async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      estudiantes = await obtenerEstudiantes.ejecutar();
    } catch (e) {
      error = e.toString();
    }
    cargando = false;
    notifyListeners();
  }

  Future<bool> agregar(Estudiante estudiante) async {
    try {
      final nuevo = await crearEstudiantes.ejecutar(estudiante);
      estudiantes.add(nuevo);
      error = null;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> editar(Estudiante estudiante) async {
    try {
      final actualizado = await actualizarEstudiante.ejecutar(estudiante);
      final i = estudiantes.indexWhere((e) => e.id == estudiante.id);
      if (i != -1) estudiantes[i] = actualizado;
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
      await eliminarEstudiante.ejecutar(id);
      estudiantes.removeWhere((e) => e.id == id);
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
